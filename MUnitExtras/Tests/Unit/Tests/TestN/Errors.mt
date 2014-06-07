(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Tests`TestN`Errors`"];


Needs["MUnitExtras`Tests`"];
Needs["MUnitExtras`MUnit`"];
Needs["MUnitExtras`TestsOfTests`"];


(* ::Section:: *)
(*Tests*)


TestCaseOfTestError[
	TestN[
		1,
		2,
		3,
		4,
		5,
		TestID -> "tested TestID: Error: Incorrect arguments"
	]
	,
	{
		TestID -> "tested TestID: Error: Incorrect arguments",
		ErrorMessage -> "TestN called with incorrect arguments: \
{1, 2, 3, 4, 5, TestID -> \"tested TestID: Error: Incorrect arguments\"}."
	}
	,
	TestID -> "Error: Incorrect arguments"
]


TestCaseOfTestError[
	TestN[
		c,
		5,
		TestID -> "tested TestID: Error: non-numeric N[input]"
	]
	,
	{
		TestID -> "tested TestID: Error: non-numeric N[input]",
		ErrorMessage -> "Input: N[c] evaluated to: c which is not a number."
	}
	,
	TestID -> "Error: non-numeric N[input]"
]


TestCaseOfTestError[
	TestN[
		5,
		c,
		TestID -> "tested TestID: Error: non-numeric N[expected]"
	]
	,
	{
		TestID -> "tested TestID: Error: non-numeric N[expected]",
		ErrorMessage -> "Expected: N[c] evaluated to: c which is not a number."
	}
	,
	TestID -> "Error: non-numeric N[expected]"
]


TestCaseOfTestError[
	TestN[
		c,
		c,
		TestID -> "tested TestID: Error: non-numeric N[input] and N[expected]"
	]
	,
	{
		TestID -> "tested TestID: Error: non-numeric N[input] and N[expected]",
		ErrorMessage -> "Input: N[c] evaluated to: c which is not a number. \
Expected: N[c] evaluated to: c which is not a number."
	}
	,
	TestID -> "Error: non-numeric N[input] and N[expected]"
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
