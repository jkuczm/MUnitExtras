(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`Test`InputWrapper`"];


Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* ::Section:: *)
(*Tests*)


TestCaseOfTest[
	Test[
		2 + 2,
		Integer,
		InputWrapper -> Head,
		TestID -> "tested TestID: Success"
	]
	,
	{
		TestRawInput -> HoldForm[2 + 2],
		TestInput -> HoldForm[Head[2 + 2]],
		ActualOutput -> HoldForm[Integer]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[Integer],
		UnevaluatadExpectedOutput -> HoldForm[Integer],
		ExpectedOutput -> HoldForm[Integer]
		,
		TestID -> "tested TestID: Success"
		,
		InputWrapper -> Head
	}
	,
	TestID -> "Success"
]


TestCaseOfTest[
	Test[
		(Message[Sin::argx, Sin, 2]; 2 + 2),
		4.,
		{HoldForm[Message[Sin::argx, Sin, 2]]},
		InputWrapper -> N,
		TestID -> "tested TestID: Success with messages"
	]
	,
	{
		TestRawInput -> HoldForm[Message[Sin::argx, Sin, 2]; 2 + 2],
		TestInput -> HoldForm[N[Message[Sin::argx, Sin, 2]; 2 + 2]],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[4.],
		UnevaluatadExpectedOutput -> HoldForm[4.],
		ExpectedOutput -> HoldForm[4.]
		,
		ExpectedMessages -> {HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		ActualMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]}
		,
		TestID -> "tested TestID: Success with messages"
		,
		InputWrapper -> N
	}
	,
	TestID -> "Success with messages"
]


TestCaseOfTest[
	Test[
		2 + 2,
		Plus,
		InputWrapper -> Head,
		TestID -> "tested TestID: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[2 + 2],
		TestInput -> HoldForm[Head[2 + 2]],
		ActualOutput -> HoldForm[Integer]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[Plus],
		UnevaluatadExpectedOutput -> HoldForm[Plus],
		ExpectedOutput -> HoldForm[Plus]
		,
		TestID -> "tested TestID: Failure"
		,
		InputWrapper -> Head
	}
	,
	TestID -> "Failure"
]


TestCaseOfTest[
	Test[
		(Message[Sin::argx, Sin, 2]; 2 + 2),
		4.,
		InputWrapper -> N,
		TestID -> "tested TestID: MessagesFailure"
	]
	,
	{
		FailureMode -> "MessagesFailure"
		,
		TestRawInput -> HoldForm[Message[Sin::argx, Sin, 2]; 2 + 2],
		TestInput -> HoldForm[N[Message[Sin::argx, Sin, 2]; 2 + 2]],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[4.],
		UnevaluatadExpectedOutput -> HoldForm[4.],
		ExpectedOutput -> HoldForm[4.]
		,
		ActualMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]}
		,
		TestID -> "tested TestID: MessagesFailure"
		,
		InputWrapper -> N
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
