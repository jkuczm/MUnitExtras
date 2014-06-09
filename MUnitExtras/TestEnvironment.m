(* ::Package:: *)

BeginPackage["MUnitExtras`TestEnvironment`"]


(* ::Section:: *)
(*Public*)


BeginTestEnvironment::usage =
"\
BeginTestEnvironment[] \
performs various tasks needed to start isolated environment for tests. \
Begins new sub-context, makes it, MUnit`, MUnitExtras` and System` the only \
active contexts. \
Saves options for relevant symbols \
(by default all symbols from needed contexts). \
Clears system cache. \
Resets pseudorandom generator using seed from \"SeedRandom\" option. \
Returns rule: Name of started context -> saved options identifier.\

BeginTestEnvironment[\"name`\"] \
begined context will be named \"name`\".\

BeginTestEnvironment[\"name`\", {\"need1\", \"need2\", ...}] \
calls Needs on the needi."


EndTestEnvironment::usage =
"\
EndTestEnvironment[] \
Performs various tasks needed to end isolated environment for tests. \
Ends sub-context.
Restores saved options. \
Clears system cache. \
Returns rule: Name of ended context -> restored options identifier."


(* Unprotect all public symbols in this package. *)
Unprotect["`*"];


(* ::Section:: *)
(*Private*)


Begin["`Private`"]


(* ::Subsection:: *)
(*Imports*)


Needs["MUnitExtras`Package`"] (* `Private`$TestingFunctions *)


Needs["ProtectionUtilities`"] (* ProtectContextNonVariables, ProtectSyntax *)
Needs["OptionsUtilities`"]
(* SaveOptions, RestoreOptions, `Private`$SavedOptions *)


(* ::Subsection:: *)
(*Private symbols*)


$TestEnvironments = {}


(* ::Subsection:: *)
(*BeginTestEnvironment*)


Options[BeginTestEnvironment] = {
	"BasicNeeds" -> {
		"MUnitExtras`TestEnvironment`",
		"MUnitExtras`MUnit`",
		"MUnitExtras`Tests`",
		"MUnitExtras`TestCases`",
		"MUnit`"
	},
	"SaveOptionsForSymbols" -> Automatic,
	"SeedRandom" -> 0,
	"ClearSystemCache" -> True
}


functionCall:BeginTestEnvironment[
	contextArg:(_String | Automatic):Automatic,
	needsArg:{___String}:{},
	OptionsPattern[]
] := (
	(* Test validity of option values. *)
	If[!MatchQ[OptionValue["BasicNeeds"], {___String}],
		Message[
			BeginTestEnvironment::unknownOptionValue,
			OptionValue["BasicNeeds"],
			"BasicNeeds",
			"List of zero or more strings with context names",
			HoldForm[functionCall]
		];
		Return[$Failed]
	];
	If[!MatchQ[OptionValue["SaveOptionsForSymbols"], Automatic | {___Symbol}],
		Message[
			BeginTestEnvironment::unknownOptionValue,
			OptionValue["SaveOptionsForSymbols"],
			"SaveOptionsForSymbols",
			"Automatic or List of zero or more symbols",
			HoldForm[functionCall]
		];
		Return[$Failed]
	];
	
	Module[
		{
			context =
				If[contextArg === Automatic,
					"TestEnvironment`" <> SymbolName[Unique[]] <> "`"
				(* else *),
					contextArg
				]
			,
			needs = DeleteDuplicates[Join[needsArg, OptionValue["BasicNeeds"]]]
			,
			symbToSaveOpt,
			savedOptionsId,
			beginPackageResult
		}
		,
		
		If[OptionValue["SaveOptionsForSymbols"] === Automatic,
			symbToSaveOpt =
				Cases[
					Symbol /@ Flatten[Names[# <> "*"]& /@ needs],
					_Symbol
				];
			
		(* else *),
			symbToSaveOpt = OptionValue["SaveOptionsForSymbols"];
		];
		
		beginPackageResult = 
			(* BeginPackage does not accept empty list as second argument. *)
			If[needs === {},
				BeginPackage[context]
			(* else *),
				BeginPackage[context, needs]
			];
		
		(*
			If BeginPackage didn't returned context name something is wrong,
			so return $Failed.
		*)
		If[beginPackageResult =!= context,
			Return[$Failed]
		];
		
		savedOptionsId = SaveOptions[symbToSaveOpt];
		
		context = context -> savedOptionsId;
		
		AppendTo[$TestEnvironments, context];
		
		If[OptionValue["SeedRandom"] =!= None,
			SeedRandom[OptionValue["SeedRandom"]];
		];
		
		If[OptionValue["ClearSystemCache"],
			ClearSystemCache[];
		];
		
		context
	]
)


(* ::Subsection:: *)
(*EndTestEnvironment*)


EndTestEnvironment::noTestEnv = "No test environment to end."


Options[EndTestEnvironment] = {
	"RemoveSymbols" -> True,
	"RestoreOptions" -> True,
	"ClearSystemCache" -> True
}


EndTestEnvironment[OptionsPattern[]] := (
	If[Length[$TestEnvironments] < 1,
		Message[EndTestEnvironment::noTestEnv];
		Return[$Failed]
	];
	
	(*
		If EndPackage generates any messages something is wrong,
		so return $Failed.
	*)
	Check[
		EndPackage[]
		,
		Return[$Failed]
	];
	
	Module[
		{
			lastTestEnvData = Last[$TestEnvironments],
			lastTestEnvContex,
			lastTestEnvOptionsId
		}
		,
		lastTestEnvContex = First[lastTestEnvData];
		lastTestEnvOptionsId = Last[lastTestEnvData];
		
		If[OptionValue["RemoveSymbols"],
			With[
				{allSymbsInContext = lastTestEnvContex <> "*"}
				,
				Unprotect[allSymbsInContext];
				(*
					User doesn't have to be warned about non-existence of
					symbols in test environment, so we quiet Remove::rmnsm
					message.
				*)
				Quiet[Remove[allSymbsInContext], {Remove::rmnsm}];
			];
			
			(*
				Custom testing functions could have been defined in test
				environment and is now removed. Clear all remnants of such
				functions.
			*)
			MUnitExtras`Package`Private`$TestingFunctions =
				Delete[
					MUnitExtras`Package`Private`$TestingFunctions
					,
					Position[
						ToString /@
							MUnitExtras`Package`Private`$TestingFunctions,
						_String?(StringMatchQ[#, "Removed[" ~~ __ ~~ "]"] &)
					]
				];
		];
		
		$ContextPath = DeleteCases[$ContextPath, lastTestEnvContex];
		
		Unprotect[$Packages];
		$Packages = DeleteCases[$Packages, lastTestEnvContex];
		Protect[$Packages];
		
		If[OptionValue["RestoreOptions"],
			RestoreOptions[lastTestEnvOptionsId];
		(* else *),
			OptionsUtilities`Private`$SavedOptions =
				DeleteCases[
					OptionsUtilities`Private`$SavedOptions,
					lastTestEnvOptionsId -> _
				];
		];
		
		$TestEnvironments = Most[$TestEnvironments];
		
		If[OptionValue["ClearSystemCache"],
			ClearSystemCache[];
		];
		
		lastTestEnvData
	]
)


End[]


(* ::Section:: *)
(*Public symbols protection*)


(*
	Protect all public symbols in this package and their syntax,
	except variables with names starting with $.
*)
ProtectContextNonVariables["ProtectFunction" -> ProtectSyntax];
ProtectContextNonVariables[];


EndPackage[]
