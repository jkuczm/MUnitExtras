(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`Test`ApplyToExpected$ExpectedWrapper`"];


Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* ::Section:: *)
(*Tests*)


TestCaseOfTest[
	Test[
		Integer,
		{2, 2},
		ApplyToExpected -> Plus,
		ExpectedWrapper -> Head,
		TestID -> "tested TestID: Success"
	]
	,
	{
		TestRawInput -> HoldForm[Integer],
		TestInput -> HoldForm[Integer],
		ActualOutput -> HoldForm[Integer]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{2, 2}],
		UnevaluatadExpectedOutput -> HoldForm[Head[2 + 2]],
		ExpectedOutput -> HoldForm[Integer]
		,
		TestID -> "tested TestID: Success"
		,
		ApplyToExpected -> Plus,
		ExpectedWrapper -> Head
	}
	,
	TestID -> "Success"
]


TestCaseOfTest[
	Test[
		(Message[Sin::argx, Sin, 2]; 4.),
		{2, 2},
		{HoldForm[Message[Sin::argx, Sin, 2]]},
		ApplyToExpected -> Plus,
		ExpectedWrapper -> N,
		TestID -> "tested TestID: Success with messages"
	]
	,
	{
		TestRawInput -> HoldForm[(Message[Sin::argx, Sin, 2]; 4.)],
		TestInput -> HoldForm[(Message[Sin::argx, Sin, 2]; 4.)],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{2, 2}],
		UnevaluatadExpectedOutput -> HoldForm[N[2 + 2]],
		ExpectedOutput -> HoldForm[4.]
		,
		ExpectedMessages -> {HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		ActualMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]}
		,
		TestID -> "tested TestID: Success with messages"
		,
		ApplyToExpected -> Plus,
		ExpectedWrapper -> N
	}
	,
	TestID -> "Success with messages"
]


TestCaseOfTest[
	Test[
		Plus,
		{2, 2},
		ApplyToExpected -> Plus,
		ExpectedWrapper -> Head,
		TestID -> "tested TestID: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[Plus],
		TestInput -> HoldForm[Plus],
		ActualOutput -> HoldForm[Plus]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{2, 2}],
		UnevaluatadExpectedOutput -> HoldForm[Head[2 + 2]],
		ExpectedOutput -> HoldForm[Integer]
		,
		TestID -> "tested TestID: Failure"
		,
		ApplyToExpected -> Plus,
		ExpectedWrapper -> Head
	}
	,
	TestID -> "Failure"
]


TestCaseOfTest[
	Test[
		(Message[Sin::argx, Sin, 2]; 4.),
		{2, 2},
		ApplyToExpected -> Plus,
		ExpectedWrapper -> N,
		TestID -> "tested TestID: MessagesFailure"
	]
	,
	{
		FailureMode -> "MessagesFailure"
		,
		TestRawInput -> HoldForm[Message[Sin::argx, Sin, 2]; 4.],
		TestInput -> HoldForm[Message[Sin::argx, Sin, 2]; 4.],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[{2, 2}],
		UnevaluatadExpectedOutput -> HoldForm[N[2 + 2]],
		ExpectedOutput -> HoldForm[4.]
		,
		ActualMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]}
		,
		TestID -> "tested TestID: MessagesFailure"
		,
		ApplyToExpected -> Plus,
		ExpectedWrapper -> N
	}
	,
	TestID -> "MessagesFailure"
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
