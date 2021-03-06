(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`Package`ThrowCatchTestError`"];


Needs["MUnitExtras`Package`"];


mockTest[arg1_, arg2_] :=
	CatchTestError[
		{arg1, arg2}
		,
		If[arg1 === arg2,
			ThrowTestError["Arguments should not be same"]
		(* else *),
			"No error thrown"
		]
	]


(* ::Section:: *)
(*Tests*)


TestStringMatch[
	Block[
		{
			MUnit`Package`logTestResult,
			MUnit`Package`$TestIndex = 0,
			MUnit`Package`$dynamicTestIndex = 0
		}
		,
		mockTest["arg1", "arg2"]
	]
	,
	"No error thrown"
	,
	TestID -> "mockTest evaluation: don't trigger error"
];


Test[
	Block[
		{
			MUnit`Package`logTestResult,
			MUnit`Package`$TestIndex = 0,
			MUnit`Package`$dynamicTestIndex = 0
		}
		,
		TestResultQ[tr = mockTest["arg", "arg"]]
	]
	,
	True
	,
	TestID -> "mockTest evaluation: trigger error"
];

Test[
	FailureMode[tr],
	"Error",
	TestID -> "TestResultObject: FailureMode"
];
Test[
	ErrorMessage[tr],
	"Arguments should not be same",
	TestID -> "TestResultObject: ErrorMessagees"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
