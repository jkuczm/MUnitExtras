(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TestEnvironment`EndTestEnvironment`"];


Needs["MUnitExtras`TestEnvironment`"];


Needs["OptionsUtilities`"]; (* SaveOptions *)


(* ::Subsection:: *)
(*Definitions*)


symOptDefault = {"symOpt" -> "symOptValueDefault"};

symOptChanged = {"symOpt" -> "symOptValueChanged"};


optionsId;

testEnvContext = "TestEnvironment`UniqueTestEnvName`";

contextOptIdRule = testEnvContext -> optionsId;


(* Mock package *)
BeginPackage["MyPackage`"];
Options[sym] =
	TestEnvironment`TestEnvironment`EndTestEnvironment`symOptDefault;
sym[] = "symValue";
EndPackage[];


original$Context = $Context;
original$ContextPath = $ContextPath;
original$Packages = $Packages;


SetUp[] := (
	BeginPackage[testEnvContext, {"MyPackage`"}];
	
	SaveOptions[sym, "UniqueIdentifier" -> optionsId];
	
	SetOptions[sym, symOptChanged];
	
	Evaluate[Symbol[testEnvContext <> "testSym"]] = "testSymValue";
)


TearDown[] :=
	With[
		{symStringForm = testEnvContext <> "*"}
		,
		Unprotect[symStringForm];
		Quiet[Remove[symStringForm], {Remove::rmnsm}];
		
		SetOptions[sym, symOptDefault];
		
		While[
			And[
				$Context =!= original$Context,
				$Context =!= "Global`"
			],
			Quiet[Remove["`*"], {Remove::rmnsm}];
			Quiet[EndPackage[], {EndPackage::noctx}];
		]
	]


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*No arguments*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments =
			{contextOptIdRule}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	SetUp[];
	
	
	Test[
		EndTestEnvironment[]
		,
		contextOptIdRule
		,
		TestID -> "No args: \
EndTestEnvironment evaluation: \
Rule with proper context and optionsId returned, \
no messages generated."
	];
	
	
	Test[
		$Context
		,
		original$Context
		,
		TestID -> "No args: \
Active context returned to original one."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "No args: \
$ContextPath returned to original one."
	];
	Test[
		$Packages
		,
		original$Packages
		,
		TestID -> "No args: \
$Packages returned to original one."
	];
	Test[
		Contexts[testEnvContext]
		,
		{}
		,
		TestID -> "No args: \
context of test environment is no longer in contexts list."
	];
	
	
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "No args: \
rule returned by EndTestEnvironment was removed from $TestEnvironments."
	];
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "No args: \
options, identified by id from rule returned by EndTestEnvironment, \
were removed from $SavedOptions."
	];
	
	
	Test[
		Names[testEnvContext <> "*"]
		,
		{}
		,
		TestID -> "No args: \
all symbols from test environment context were removed."
	];
	
	
	Test[
		Options[MyPackage`sym]
		,
		symOptDefault
		,
		TestID -> "No args: \
options of symbol from mock package were restored to default values."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*No arguments, Protected symbol*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments =
			{contextOptIdRule}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	SetUp[];
	
	With[
		{testSymName = testEnvContext <> "testSym"}
		,
		Protect[testSymName];
	];
	
	
	Test[
		EndTestEnvironment[]
		,
		contextOptIdRule
		,
		TestID -> "No args, Protected symbol: \
EndTestEnvironment evaluation: \
Rule with proper context and optionsId returned, \
no messages generated."
	];
	
	
	Test[
		$Context
		,
		original$Context
		,
		TestID -> "No args, Protected symbol: \
Active context returned to original one."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "No args, Protected symbol: \
$ContextPath returned to original one."
	];
	Test[
		$Packages
		,
		original$Packages
		,
		TestID -> "No args, Protected symbol: \
$Packages returned to original one."
	];
	Test[
		Contexts[testEnvContext]
		,
		{}
		,
		TestID -> "No args, Protected symbol: \
context of test environment is no longer in contexts list."
	];
	
	
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "No args, Protected symbol: \
rule returned by EndTestEnvironment was removed from $TestEnvironments."
	];
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "No args, Protected symbol: \
options, identified by id from rule returned by EndTestEnvironment, \
were removed from $SavedOptions."
	];
	
	
	Test[
		Names[testEnvContext <> "*"]
		,
		{}
		,
		TestID -> "No args, Protected symbol: \
all symbols from test environment context were removed."
	];
	
	
	Test[
		Options[MyPackage`sym]
		,
		symOptDefault
		,
		TestID -> "No args, Protected symbol: \
options of symbol from mock package were restored to default values."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*"RemoveSymbols" -> False*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments =
			{contextOptIdRule}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	SetUp[];
	
	
	Test[
		EndTestEnvironment["RemoveSymbols" -> False]
		,
		contextOptIdRule
		,
		TestID -> "\"RemoveSymbols\" -> False: \
EndTestEnvironment evaluation: \
Rule with proper context and optionsId returned, \
no messages generated."
	];
	
	
	Test[
		$Context
		,
		original$Context
		,
		TestID -> "\"RemoveSymbols\" -> False: \
Active context returned to original one."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "\"RemoveSymbols\" -> False: \
$ContextPath returned to original one."
	];
	Test[
		$Packages
		,
		original$Packages
		,
		TestID -> "\"RemoveSymbols\" -> False: \
$Packages returned to original one."
	];
	Test[
		Contexts[testEnvContext]
		,
		{testEnvContext}
		,
		TestID -> "\"RemoveSymbols\" -> False: \
context of test environment is still in contexts list."
	];
	
	
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "\"RemoveSymbols\" -> False: \
rule returned by EndTestEnvironment was removed from $TestEnvironments."
	];
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "\"RemoveSymbols\" -> False: \
options, identified by id from rule returned by EndTestEnvironment, \
were removed from $SavedOptions."
	];
	
	
	Test[
		Names[testEnvContext <> "*"]
		,
		{testEnvContext <> "testSym"}
		,
		TestID -> "\"RemoveSymbols\" -> False: \
all symbols from test environment are present."
	];
	
	
	Test[
		Options[MyPackage`sym]
		,
		symOptDefault
		,
		TestID -> "\"RemoveSymbols\" -> False: \
options of symbol from mock package were restored to default values."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*"RestoreOptions" -> False*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments =
			{contextOptIdRule}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	SetUp[];
	
	
	Test[
		EndTestEnvironment["RestoreOptions" -> False]
		,
		contextOptIdRule
		,
		TestID -> "\"RestoreOptions\" -> False: \
EndTestEnvironment evaluation: \
Rule with proper context and optionsId returned, \
no messages generated."
	];
	
	
	Test[
		$Context
		,
		original$Context
		,
		TestID -> "\"RestoreOptions\" -> False: \
Active context returned to original one."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "\"RestoreOptions\" -> False: \
$ContextPath returned to original one."
	];
	Test[
		$Packages
		,
		original$Packages
		,
		TestID -> "\"RestoreOptions\" -> False: \
$Packages returned to original one."
	];
	Test[
		Contexts[testEnvContext]
		,
		{}
		,
		TestID -> "\"RestoreOptions\" -> False: \
context of test environment is no longer in contexts list."
	];
	
	
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "\"RestoreOptions\" -> False: \
rule returned by EndTestEnvironment was removed from $TestEnvironments."
	];
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "\"RestoreOptions\" -> False: \
options, identified by id from rule returned by EndTestEnvironment, \
were removed from $SavedOptions."
	];
	
	
	Test[
		Names[testEnvContext <> "*"]
		,
		{}
		,
		TestID -> "\"RestoreOptions\" -> False: \
all symbols from test environment context were removed."
	];
	
	
	Test[
		Options[MyPackage`sym]
		,
		symOptChanged
		,
		TestID -> "\"RestoreOptions\" -> False: \
options of symbol from mock package remain with values set in test env."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*Empty $TestEnvironments (no matching BeginTestEnvironment)*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{context, contextPath, packages}
	,
	
	
	SetUp[];
	context = $Context;
	contextPath = $ContextPath;
	packages = $Packages;
	
	
	Test[
		EndTestEnvironment[]
		,
		$Failed
		,
		{EndTestEnvironment::noTestEnv}
		,
		TestID -> "Empty $TestEnvironments: \
EndTestEnvironment evaluation: \
$Failed returned, \
warning message generated."
	];
	
	
	Test[
		$Context
		,
		context
		,
		TestID -> "Empty $TestEnvironments: \
Active context remain unchanged."
	];
	Test[
		$ContextPath
		,
		contextPath
		,
		TestID -> "Empty $TestEnvironments: \
$ContextPath remain unchanged."
	];
	Test[
		$Packages
		,
		packages
		,
		TestID -> "Empty $TestEnvironments: \
$Packages remain unchanged."
	];
	Test[
		Contexts[testEnvContext]
		,
		{testEnvContext}
		,
		TestID -> "Empty $TestEnvironments: \
context of test environment is still in contexts list."
	];
	
	
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "Empty $TestEnvironments: \
$TestEnvironments remain empty."
	];
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{optionsId -> {sym -> symOptDefault}}
		,
		TestID -> "Empty $TestEnvironments: \
$SavedOptions is unchanged."
	];
	
	
	Test[
		Names[testEnvContext <> "*"]
		,
		{"testSym"}
		,
		TestID -> "Empty $TestEnvironments: \
all symbols from test environment are present."
	];
	
	
	Test[
		Options[MyPackage`sym]
		,
		symOptChanged
		,
		TestID -> "Empty $TestEnvironments: \
options of symbol from mock package remain with values set in test env."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Wrong syntax*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments =
			{contextOptIdRule}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{context, contextPath, packages}
	,
	
	
	SetUp[];
	context = $Context;
	contextPath = $ContextPath;
	packages = $Packages;
	
	
	TestMatch[
		EndTestEnvironment["unacceptableArgument"]
		,
		HoldPattern[EndTestEnvironment["unacceptableArgument"]]
		,
		{EndTestEnvironment::wrongSyntax}
		,
		TestID -> "Wrong syntax: \
EndTestEnvironment evaluation: \
unevaluated form returned, \
warning message generated."
	];
	
	
	Test[
		$Context
		,
		context
		,
		TestID -> "Wrong syntax: \
Active context remain unchanged."
	];
	Test[
		$ContextPath
		,
		contextPath
		,
		TestID -> "Wrong syntax: \
$ContextPath remain unchanged."
	];
	Test[
		$Packages
		,
		packages
		,
		TestID -> "Wrong syntax: \
$Packages remain unchanged."
	];
	Test[
		Contexts[testEnvContext]
		,
		{testEnvContext}
		,
		TestID -> "Wrong syntax: \
context of test environment is still in contexts list."
	];
	
	
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{contextOptIdRule}
		,
		TestID -> "Wrong syntax: \
$TestEnvironments remain unchanged."
	];
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{optionsId -> {sym -> symOptDefault}}
		,
		TestID -> "Wrong syntax: \
$SavedOptions is unchanged."
	];
	
	
	Test[
		Names[testEnvContext <> "*"]
		,
		{"testSym"}
		,
		TestID -> "Wrong syntax: \
all symbols from test environment are present."
	];
	
	
	Test[
		Options[MyPackage`sym]
		,
		symOptChanged
		,
		TestID -> "Wrong syntax: \
options of symbol from mock package remain with values set in test env."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Removed testing functions clearing*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments =
			{contextOptIdRule}
		,
		OptionsUtilities`Private`$SavedOptions = {},
		MUnitExtras`Package`Private`$TestingFunctions
	}
	,
	
	
	SetUp[];
	
	MUnitExtras`Package`Private`$TestingFunctions =
		{Test, customTest};
	
	Remove[customTest];
	
	Test[
		EndTestEnvironment[]
		,
		contextOptIdRule
		,
		TestID -> "Removed testing functions clearing: \
EndTestEnvironment evaluation: \
Rule with proper context and optionsId returned, \
no messages generated."
	];
	
	
	Test[
		MUnitExtras`Package`Private`$TestingFunctions
		,
		{Test}
		,
		TestID -> "Removed testing functions clearing: \
Removed symbol was removed from testing functions list."
	];
	
	TearDown[];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context and in mock package. *)
Unprotect["`*", "MyPackage`*"];
Quiet[Remove["`*", "MyPackage`*"], {Remove::rmnsm}];


End[];
