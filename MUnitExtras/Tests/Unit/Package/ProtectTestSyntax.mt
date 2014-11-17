(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`ProtectTestSyntax`"];


Needs["PatternUtilities`"]; (* HoldAllSubpatterns *)


Needs["MUnitExtras`Package`"];


PrependTo[$ContextPath, "MUnit`Package`"]


(* Mock functions *)
Remove[mockTest];


(* ::Section:: *)
(*Tests*)


Test[
	ProtectTestSyntax[mockTest],
	Null,
	TestID -> "ProtectTestSyntax evaluation"
];


TestMatch[
	DownValues[mockTest]
	,
	{
		HoldAllSubpatterns[
			HoldPattern[mockTest[args___]] :>
				With[
					{
						msg =
							ToString @ StringForm[
								General::incorrectTestArgs,
								mockTest,
								MakeString[HoldForm[{args}]]
							]
						,
						opts = Cases[HoldComplete[args], OptionsPattern[]]
						
					}
					,
					testError[msg, opts]
				]
		]
	}
	,
	TestID -> "After protection: \
mockTest has \"Incorrect arguments\" definition \
calling testError with proper message"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
