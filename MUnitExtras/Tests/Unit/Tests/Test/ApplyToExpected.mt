(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`Test`ApplyToExpected`"];


Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* ::Section:: *)
(*Tests*)


TestCaseOfTest[
	Test[
		4,
		{2, 2},
		ApplyToExpected -> Plus,
		TestID -> "tested TestID: Success"
	]
	,
	{
		TestRawInput -> HoldForm[4],
		TestInput -> HoldForm[4],
		ActualOutput -> HoldForm[4]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{2, 2}],
		UnevaluatadExpectedOutput -> HoldForm[2 + 2],
		ExpectedOutput -> HoldForm[4]
		,
		TestID -> "tested TestID: Success"
		,
		ApplyToExpected -> Plus
	}
	,
	TestID -> "Success"
]


TestCaseOfTest[
	Test[
		Sin[1, 2],
		{1, 2},
		Message[Sin::argx, Sin, 2],
		ApplyToExpected -> Sin,
		TestID -> "tested TestID: Success with messages"
	]
	,
	{
		TestRawInput -> HoldForm[Sin[1, 2]],
		TestInput -> HoldForm[Sin[1, 2]],
		ActualOutput -> HoldForm[Sin[1, 2]]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{1, 2}],
		UnevaluatadExpectedOutput -> HoldForm[Sin[1, 2]],
		ExpectedOutput -> HoldForm[Sin[1, 2]]
		,
		ExpectedMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]},
		ActualMessages ->
			{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]}
		,
		TestID -> "tested TestID: Success with messages"
		,
		ApplyToExpected -> Sin
	}
	,
	TestID -> "Success with messages"
]


TestCaseOfTest[
	Test[
		5,
		{2, 3},
		ApplyToExpected -> Times,
		TestID -> "tested TestID: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[5],
		TestInput -> HoldForm[5],
		ActualOutput -> HoldForm[5]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{2, 3}],
		UnevaluatadExpectedOutput -> HoldForm[2*3],
		ExpectedOutput -> HoldForm[6]
		,
		TestID -> "tested TestID: Failure"
		,
		ApplyToExpected -> Times
	}
	,
	TestID -> "Failure"
]


TestCaseOfTest[
	Test[
		Sin[1, 2],
		{1, 2},
		ApplyToExpected -> Sin,
		TestID -> "tested TestID: MessagesFailure"
	]
	,
	{
		FailureMode -> "MessagesFailure"
		,
		TestRawInput -> HoldForm[Sin[1, 2]],
		TestInput -> HoldForm[Sin[1, 2]],
		ActualOutput -> HoldForm[Sin[1, 2]]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{1, 2}],
		UnevaluatadExpectedOutput -> HoldForm[Sin[1, 2]],
		ExpectedOutput -> HoldForm[Sin[1, 2]]
		,
		ActualMessages ->
			{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]}
		,
		TestID -> "tested TestID: MessagesFailure"
		,
		ApplyToExpected -> Sin
	}
	,
	TestID -> "MessagesFailure"
]


TestCaseOfTest[
	Test[
		5,
		Times[2, 3],
		ApplyToExpected -> Plus,
		TestID -> "tested TestID: Non-list"
	]
	,
	{
		TestRawInput -> HoldForm[5],
		TestInput -> HoldForm[5],
		ActualOutput -> HoldForm[5]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[2*3],
		UnevaluatadExpectedOutput -> HoldForm[2 + 3],
		ExpectedOutput -> HoldForm[5]
		,
		TestID -> "tested TestID: Non-list"
		,
		ApplyToExpected -> Plus
	}
	,
	TestID -> "Non-list"
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
