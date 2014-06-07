(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`Test`DefaultOptions`"];


Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* ::Section:: *)
(*Tests*)


TestCaseOfTest[
	Test[
		2 + 2,
		1 + 3,
		TestID -> "tested TestID: Success"
	]
	,
	{
		TestRawInput -> HoldForm[2 + 2],
		TestInput -> HoldForm[2 + 2],
		ActualOutput -> HoldForm[4]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[1 + 3],
		UnevaluatadExpectedOutput -> HoldForm[1 + 3],
		ExpectedOutput -> HoldForm[4]
		,
		TestID -> "tested TestID: Success"
	}
	,
	TestID -> "Success"
]


TestCaseOfTest[
	Test[
		2 + 2,
		1 + 4,
		TestID -> "tested TestID: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[2 + 2],
		TestInput -> HoldForm[2 + 2],
		ActualOutput -> HoldForm[4]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[1 + 4],
		UnevaluatadExpectedOutput -> HoldForm[1 + 4],
		ExpectedOutput -> HoldForm[5]
		,
		TestID -> "tested TestID: Failure"
	}
	,
	TestID -> "Failure"
]


TestCaseOfTest[
	Test[
		Sin[1, 2] + 1 + 2,
		3 + Sin[1, 2],
		Message[Sin::argx, Sin, 2],
		TestID -> "tested TestID: Success with messages"
	]
	,
	{
		TestRawInput -> HoldForm[Sin[1, 2] + 1 + 2],
		TestInput -> HoldForm[Sin[1, 2] + 1 + 2],
		ActualOutput -> HoldForm[3 + Sin[1, 2]]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[3 + Sin[1, 2]],
		UnevaluatadExpectedOutput -> HoldForm[3 + Sin[1, 2]],
		ExpectedOutput -> HoldForm[3 + Sin[1, 2]]
		,
		ExpectedMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]},
		ActualMessages ->
			{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]}
		,
		TestID -> "tested TestID: Success with messages"
	}
	,
	TestID -> "Success with messages"
]


TestCaseOfTest[
	Test[
		Sin[1, 2] + 1 + 2,
		3 + Sin[1, 2],
		TestID -> "tested TestID: MessagesFailure"
	]
	,
	{
		FailureMode -> "MessagesFailure"
		,
		TestRawInput -> HoldForm[Sin[1, 2] + 1 + 2],
		TestInput -> HoldForm[Sin[1, 2] + 1 + 2],
		ActualOutput -> HoldForm[3 + Sin[1, 2]]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[3 + Sin[1, 2]],
		UnevaluatadExpectedOutput -> HoldForm[3 + Sin[1, 2]],
		ExpectedOutput -> HoldForm[3 + Sin[1, 2]]
		,
		ActualMessages ->
			{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]}
		,
		TestID -> "tested TestID: MessagesFailure"
	}
	,
	TestID -> "MessagesFailure"
]


TestCaseOfTestError[
	Test[
		1,
		2,
		3,
		4,
		5,
		TestID -> "tested TestID: Error"
	]
	,
	{
		TestID -> "tested TestID: Error",
		ErrorMessage -> "Incorrect arguments: \
{1, 2, 3, 4, 5, TestID -> tested TestID: Error}"
	}
	,
	TestID -> "Error"
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
