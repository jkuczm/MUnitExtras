(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`TestN`Basic`"];


Needs["MUnitExtras`Tests`"];
Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* Symbols with numeric values *)
N[a] = 2.;
N[b] = 5.;


(* ::Section:: *)
(*Tests*)


TestCaseOfTest[
	TestN[
		a + 3,
		b,
		TestID -> "tested TestID: Success"
	]
	,
	{
		TestRawInput -> HoldForm[a + 3],
		TestInput -> HoldForm[N[a + 3]],
		ActualOutput -> HoldForm[5.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		TestID -> "tested TestID: Success"
		,
		EquivalenceFunction -> Equal,
		InputWrapper -> N,
		ExpectedWrapper -> N
	}
	,
	TestID -> "Success"
]


TestCaseOfTest[
	TestN[
		a + 2,
		b,
		TestID -> "tested TestID: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[a + 2],
		TestInput -> HoldForm[N[a + 2]],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		TestID -> "tested TestID: Failure"
		,
		EquivalenceFunction -> Equal,
		InputWrapper -> N,
		ExpectedWrapper -> N
	}
	,
	TestID -> "Failure"
]


TestCaseOfTest[
	TestN[
		(Message[Sin::argx, Sin, 2]; a + 3),
		b,
		{HoldForm[Message[Sin::argx, Sin, 2]]},
		TestID -> "tested TestID: Success with messages"
	]
	,
	{
		TestRawInput -> HoldForm[Message[Sin::argx, Sin, 2]; a + 3],
		TestInput -> HoldForm[N[Message[Sin::argx, Sin, 2]; a + 3]],
		ActualOutput -> HoldForm[5.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		ExpectedMessages -> {HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		ActualMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]}
		,
		TestID -> "tested TestID: Success with messages"
		,
		EquivalenceFunction -> Equal,
		InputWrapper -> N,
		ExpectedWrapper -> N
	}
	,
	TestID -> "Success with messages"
]


TestCaseOfTest[
	TestN[
		(Message[Sin::argx, Sin, 2]; a + 3),
		b,
		TestID -> "tested TestID: MessagesFailure"
	]
	,
	{
		FailureMode -> "MessagesFailure"
		,
		TestRawInput -> HoldForm[Message[Sin::argx, Sin, 2]; a + 3],
		TestInput -> HoldForm[N[Message[Sin::argx, Sin, 2]; a + 3]],
		ActualOutput -> HoldForm[5.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		ActualMessages -> {HoldForm[Message[Sin::argx, Sin, 2]]}
		,
		TestID -> "tested TestID: MessagesFailure"
		,
		EquivalenceFunction -> Equal,
		InputWrapper -> N,
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
