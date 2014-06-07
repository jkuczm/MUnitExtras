(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestCaseMultipleFunctions[
	{2, 2},
	4,
	TestID -> "Error: ApplyToInput and ApplyToOutput are not lists",
	TestErrorAction -> "Continue",
	ApplyToInput -> Plus,
	ApplyToExpected -> Times
];

TestCaseMultipleFunctions[
	{2, 2},
	4,
	TestID ->
		"Error: ApplyToInput and ApplyToOutput are lists with different \
lengths"
	,
	TestErrorAction -> "Continue",
	ApplyToInput -> {Plus, Times},
	ApplyToExpected -> {Times}
];


SetOptions[TestCaseMultipleFunctions, {
	ApplyToInput -> {Plus, Times},
	ApplyToExpected -> None
}];

TestCaseMultipleFunctions[
	{2, 2},
	4,
	TestID -> "Pass: 2+2=4, 2*2=4"
];

TestCaseMultipleFunctions[
	{2, 3},
	5,
	TestID -> "2+3=5 Pass, 2*3=5 Fail"
];

TestCaseMultipleFunctions[
	{2, 3},
	6,
	TestID -> "2+3=6 Fail, 2*3=6 Pass"
];

TestCaseMultipleFunctions[
	{2, 3},
	7,
	TestID -> "Fail: 2+3=7, 2*3=7"
];


SetOptions[TestCaseMultipleFunctions, {
	ApplyToInput -> None,
	ApplyToExpected -> {Plus, Times}
}];

TestCaseMultipleFunctions[
	4,
	{2, 2},
	TestID -> "Pass: 4=2+2, 4=2*2"
];

TestCaseMultipleFunctions[
	5,
	{2, 3},
	TestID -> "5=2+3 Pass, 5=2*3 Fail"
];

TestCaseMultipleFunctions[
	6,
	{2, 3},
	TestID -> "6=2+3 Fail, 6=2*3 Pass"
];

TestCaseMultipleFunctions[
	7,
	{2, 3},
	TestID -> "Fail: 7=2+3, 7=2*3"
];


SetOptions[TestCaseMultipleFunctions, {
	ApplyToInput -> {Plus, Times},
	ApplyToExpected -> {Times, Plus}
}];

TestCaseMultipleFunctions[
	{2, 2},
	{2, 2},
	TestID -> "Pass: 2+2=2*2, 2*2=2+2"
];

TestCaseMultipleFunctions[
	{2, 3},
	{2, 3},
	TestID -> "Fail: 2+3=2*3, 2*3=2+3"
];
