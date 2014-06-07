(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`Test`ApplyToInput`"];


Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* ::Section:: *)
(*Tests*)


TestCaseOfTest[
	Test[
		{2, 2},
		4,
		ApplyToInput -> Plus,
		TestID -> "tested TestID: Success"
	]
	,
	{
		TestRawInput -> HoldForm[{2, 2}],
		TestInput -> HoldForm[2 + 2],
		ActualOutput -> HoldForm[4]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[4],
		UnevaluatadExpectedOutput -> HoldForm[4],
		ExpectedOutput -> HoldForm[4]
		,
		TestID -> "tested TestID: Success"
		,
		ApplyToInput -> Plus
	}
	,
	TestID -> "Success"
]


TestCaseOfTest[
	Test[
		{1, 2},
		Sin[1, 2],
		Message[Sin::argx, Sin, 2],
		ApplyToInput -> Sin,
		TestID -> "tested TestID: Success with messages"
	]
	,
	{
		TestRawInput -> HoldForm[{1, 2}],
		TestInput -> HoldForm[Sin[1, 2]],
		ActualOutput -> HoldForm[Sin[1, 2]]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[Sin[1, 2]],
		UnevaluatadExpectedOutput -> HoldForm[Sin[1, 2]],
		ExpectedOutput -> HoldForm[Sin[1, 2]]
		,
		ExpectedMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]},
		ActualMessages ->
			{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]}
		,
		TestID -> "tested TestID: Success with messages"
		,
		ApplyToInput -> Sin
	}
	,
	TestID -> "Success with messages"
]


TestCaseOfTest[
	Test[
		{2, 3},
		5,
		ApplyToInput -> Times,
		TestID -> "tested TestID: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[{2, 3}],
		TestInput -> HoldForm[2*3],
		ActualOutput -> HoldForm[6]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[5],
		UnevaluatadExpectedOutput -> HoldForm[5],
		ExpectedOutput -> HoldForm[5]
		,
		TestID -> "tested TestID: Failure"
		,
		ApplyToInput -> Times
	}
	,
	TestID -> "Failure"
]


TestCaseOfTest[
	Test[
		{1, 2},
		Sin[1, 2],
		ApplyToInput -> Sin,
		TestID -> "tested TestID: MessagesFailure"
	]
	,
	{
		FailureMode -> "MessagesFailure"
		,
		TestRawInput -> HoldForm[{1, 2}],
		TestInput -> HoldForm[Sin[1, 2]],
		ActualOutput -> HoldForm[Sin[1, 2]]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[Sin[1, 2]],
		UnevaluatadExpectedOutput -> HoldForm[Sin[1, 2]],
		ExpectedOutput -> HoldForm[Sin[1, 2]]
		,
		ActualMessages ->
			{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]}
		,
		TestID -> "tested TestID: MessagesFailure"
		,
		ApplyToInput -> Sin
	}
	,
	TestID -> "MessagesFailure"
]


TestCaseOfTest[
	Test[
		Times[2, 3],
		5,
		ApplyToInput -> Plus,
		TestID -> "tested TestID: Non-list"
	]
	,
	{
		TestRawInput -> HoldForm[2*3],
		TestInput -> HoldForm[2 + 3],
		ActualOutput -> HoldForm[5]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[5],
		UnevaluatadExpectedOutput -> HoldForm[5],
		ExpectedOutput -> HoldForm[5]
		,
		TestID -> "tested TestID: Non-list"
		,
		ApplyToInput -> Plus
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
