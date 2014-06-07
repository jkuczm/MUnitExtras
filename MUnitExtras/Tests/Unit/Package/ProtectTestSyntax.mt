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
				testError[
					ToString @ StringForm[
						General::incorrectTestArgs,
						mockTest,
						MeetLogger`Private`makeString[HoldForm[{args}]]
					]
					,	
					Sequence @@ Cases[HoldComplete[args], OptionsPattern[]]
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
