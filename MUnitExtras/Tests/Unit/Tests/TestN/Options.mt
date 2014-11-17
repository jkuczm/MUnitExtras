(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`TestN`Options`"]


Needs["MUnitExtras`Tests`"]
Needs["MUnitExtras`MUnit`"]
Needs["MUnitExtras`TestsOfTests`"]


(* Symbols with numeric values *)
N[a] = 2.
N[b] = 5.


(* Alternative numeric function *)
myN[a] ^= 3.
myN[b] ^= 4.
myN[x_?AtomQ] := N[x]
myN[x_] := myN /@ x


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*N option*)


TestCaseOfTest[
	TestN[
		a + 1,
		b,
		N -> myN,
		TestID -> "tested TestID: N option: Success"
	]
	,
	{
		TestRawInput -> HoldForm[a + 1],
		TestInput -> HoldForm[myN[a + 1]],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[myN[b]],
		ExpectedOutput -> HoldForm[4.]
		,
		TestID -> "tested TestID: N option: Success"
		,
		SameTest -> Equal,
		InputWrapper -> myN,
		ExpectedWrapper -> myN
	}
	,
	TestID -> "N option: Success"
]


TestCaseOfTest[
	TestN[
		a + 3,
		b,
		N -> myN,
		TestID -> "tested TestID: N option: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[a + 3],
		TestInput -> HoldForm[myN[a + 3]],
		ActualOutput -> HoldForm[6.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[myN[b]],
		ExpectedOutput -> HoldForm[4.]
		,
		TestID -> "tested TestID: N option: Failure"
		,
		SameTest -> Equal,
		InputWrapper -> myN,
		ExpectedWrapper -> myN
	}
	,
	TestID -> "N option: Failure"
]


(* ::Subsection:: *)
(*InputWrapper option*)


TestCaseOfTest[
	TestN[
		a + 2,
		b,
		InputWrapper -> myN,
		TestID -> "tested TestID: InputWrapper option: Success"
	]
	,
	{
		TestRawInput -> HoldForm[a + 2],
		TestInput -> HoldForm[myN[a + 2]],
		ActualOutput -> HoldForm[5.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		TestID -> "tested TestID: InputWrapper option: Success"
		,
		SameTest -> Equal,
		InputWrapper -> myN,
		ExpectedWrapper -> N
	}
	,
	TestID -> "InputWrapper option: Success"
]


TestCaseOfTest[
	TestN[
		a + 3,
		b,
		InputWrapper -> myN,
		TestID -> "tested TestID: InputWrapper option: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[a + 3],
		TestInput -> HoldForm[myN[a + 3]],
		ActualOutput -> HoldForm[6.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		TestID -> "tested TestID: InputWrapper option: Failure"
		,
		SameTest -> Equal,
		InputWrapper -> myN,
		ExpectedWrapper -> N
	}
	,
	TestID -> "InputWrapper option: Failure"
]


(* ::Subsection:: *)
(*ExpectedWrapper option*)


TestCaseOfTest[
	TestN[
		a + 2,
		b,
		ExpectedWrapper -> myN,
		TestID -> "tested TestID: ExpectedWrapper option: Success"
	]
	,
	{
		TestRawInput -> HoldForm[a + 2],
		TestInput -> HoldForm[N[a + 2]],
		ActualOutput -> HoldForm[4.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[myN[b]],
		ExpectedOutput -> HoldForm[4.]
		,
		TestID -> "tested TestID: ExpectedWrapper option: Success"
		,
		SameTest -> Equal,
		InputWrapper -> N,
		ExpectedWrapper -> myN
	}
	,
	TestID -> "ExpectedWrapper option: Success"
]


TestCaseOfTest[
	TestN[
		a + 3,
		b,
		ExpectedWrapper -> myN,
		TestID -> "tested TestID: ExpectedWrapper option: Failure"
	]
	,
	{
		FailureMode -> "Failure"
		,
		TestRawInput -> HoldForm[a + 3],
		TestInput -> HoldForm[N[a + 3]],
		ActualOutput -> HoldForm[5.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[myN[b]],
		ExpectedOutput -> HoldForm[4.]
		,
		TestID -> "tested TestID: ExpectedWrapper option: Failure"
		,
		SameTest -> Equal,
		InputWrapper -> N,
		ExpectedWrapper -> myN
	}
	,
	TestID -> "ExpectedWrapper option: Failure"
]


(* ::Subsection:: *)
(*ApplyToInput option*)


TestCaseOfTest[
	TestN[
		{a, 3},
		b,
		ApplyToInput -> Plus,
		TestID -> "tested TestID: ApplyToInput option: Success"
	]
	,
	{
		TestRawInput -> HoldForm[{a, 3}],
		TestInput -> HoldForm[N[a + 3]],
		ActualOutput -> HoldForm[5.]
		,
		UnevaluatadRawExpectedOutput -> HoldForm[b],
		UnevaluatadExpectedOutput -> HoldForm[N[b]],
		ExpectedOutput -> HoldForm[5.]
		,
		TestID -> "tested TestID: ApplyToInput option: Success"
		,
		SameTest -> Equal,
		InputWrapper -> N,
		ExpectedWrapper -> N
		,
		ApplyToInput -> Plus
	}
	,
	TestID -> "ApplyToInput option: Success"
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
