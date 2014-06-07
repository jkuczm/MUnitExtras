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
	mockTest["arg1", "arg2", TestID -> "mockTestID"],
	HoldPattern[mockTest["arg1", "arg2", TestID -> "mockTestID"]],
	TestID -> "mockTest evaluation: before test syntax protection"
];


ProtectTestSyntax[mockTest];


TestStringMatch[
	Block[
		{MUnit`Package`logTestResult}
		,
		SymbolName[tr = mockTest["arg1", "arg2", TestID -> "mockTestID"]]
	]
	,
	"TestResultObject*"
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


TestStringMatch[
	Block[
		{MUnit`Package`logTestResult}
		,
		SymbolName[mockTest[Message[Sin::argx, Sin, 2]]]
	]
	,
	"TestResultObject*"
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
