(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestCaseSparse[
	{},
	TestID -> "Error: AllTestsArgs option not set",
	TestErrorAction -> "Continue"
];


SetOptions[{Test, TestZero}, ApplyToInput -> FractionalPart]
SetOptions[TestCaseSparse, {
	Test -> Test,
	TestDefault -> TestZero,
	AllTestsArgs -> List /@ List /@ {-1, 0, 1/2, 1, 3/2}
}];


TestCaseSparse[
	{
		{{1/2}, 1/2},
		{{3/2}, 1/2}
	},
	TestID -> "Pass: from -1, 0, 1/2, 1, 3/2 only 1/2 and 3/2 have non-zero \
fractional part"
];


TestCaseSparse[
	{
		{{1/2}, 1/2, TestID -> "Pass: 1/2 non-default own id"},
		{{3/2}, 1/2, TestID -> "Pass: 3/2 non-default own id"}
	},
	TestID -> "Pass: non-default tests with own ids"
];


TestCaseSparse[
	{
		{{1/2}, 1/2},
		{{3/2}, 1/2}
	},
	TestID -> "Pass: default tests with own ids",
	AllTestsArgs -> {
		{{-1}, TestID -> "Pass: -1 defalt id"},
		{{0}, TestID -> "Pass: 0 defalt id"},
		{{1/2}, TestID -> "Not used id"},
		{{1}, TestID -> "Pass: 1 defalt id"},
		{{3/2}, TestID -> "Not used id"}
	}
];


TestCaseSparse[
	{
		{{1/2}, 1/2, TestID -> "Pass: 1/2"},
		{{1}, 1/2, TestID -> "Fail: fractional part of 1 is not 1/2"},
		{{3/2}, 5, TestID -> "Fail: fractional part of 3/2 is not 5"}
	},
	TestID -> "Pass: non-default tests with failures and own ids"
];


TestCaseSparse[
	Hold[
		{{1/2}, 1/2},
		{{3/2}, 1/2}
	],
	TestID -> "Pass: tested inputs and non-default test specifications inside \
Hold"
	,
	AllTestsArgs -> List /@ List /@ Hold[-1, 0, 1/2, 1, 3/2]
];


TestCaseSparse[
	{
		{{1/2}, 1/2},
		{{3/2}, 1/2}
	},
	TestID -> "Pass: tested inputs inside Hold and non-default test \
specifications inside List",
	AllTestsArgs ->
		List /@ List /@ Hold[-1, 0, Rational[1, 2], 1, Rational[3, 2]]
];


TestCaseSparse[
	{
		{{1/2}, 1/2},
		{{1/3}, 1/3}
	}
	,
	TestID -> "Error: one of explicitly given inputs is not in TestedInputs",
	TestErrorAction -> "Continue"
];


(* Syntax protection *)
TestCaseSparse[
	1, 2, 3,
	TestID -> "Error: wrong syntax",
	TestErrorAction -> "Continue"
];
