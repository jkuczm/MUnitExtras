(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`Package`ProtectTestSyntax`"];


Needs["MUnitExtras`Package`"];


(* Mock functions *)
Remove[mockTest];
SetAttributes[mockTest, HoldAllComplete];


(* ::Section:: *)
(*Tests*)


TestMatch[
	MUnit`Package`$lexicalTestIndex -= 2;
	mockTest["arg1", "arg2", TestID -> "mockTestID"]
	,
	HoldPattern[mockTest["arg1", "arg2", TestID -> "mockTestID"]]
	,
	TestID -> "mockTest evaluation: before test syntax protection"
];


ProtectTestSyntax[mockTest];


Test[
	MUnit`Package`$lexicalTestIndex--;
	Block[
		{
			MUnit`Package`logTestResult,
			MUnit`Package`$TestIndex = 0,
			MUnit`Package`$dynamicTestIndex = 0
		}
		,
		TestResultQ[tr = mockTest["arg1", "arg2", TestID -> "mockTestID"]]
	]
	,
	True
	,
	TestID -> "mockTest evaluation: after test syntax protection"
];

Test[
	FailureMode[tr],
	"Error",
	TestID -> "TestResultObject: FailureMode"
];
Test[
	ErrorMessage[tr],
	"mockTest called with incorrect arguments: \
{\"arg1\", \"arg2\", TestID -> \"mockTestID\"}.",
	TestID -> "TestResultObject: ErrorMessagees"
];
Test[
	TestID[tr],
	"mockTestID",
	TestID -> "TestResultObject: TestID"
];


Test[
	Block[
		{
			MUnit`Package`logTestResult,
			MUnit`Package`$TestIndex = 0,
			MUnit`Package`$dynamicTestIndex = 0
		}
		,
		TestResultQ[mockTest[Message[Sin::argx, Sin, 2]]]
	]
	,
	True
	,
	TestID -> "mockTest evaluation with message generating argument: \
message is not generated"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
