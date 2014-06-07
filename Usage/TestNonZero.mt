(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestNonZero[
	5,
	TestID -> "Pass: 5"
];

TestNonZero[
	2 + 2,
	TestID -> "Pass: 2 + 2"
];

TestNonZero[
	6 - 3 * 2,
	TestID -> "Fail: 6 - 3 * 2"
];


(* Messages *)

TestNonZero[
	Sin[1, 2],
	TestID -> "Fail: non-zero is returned, but message is generated"
];

TestNonZero[
	Sin[1, 2],
	{HoldForm[Message[Sin::argx, HoldForm[Sin], HoldForm[2]]]},
	TestID -> "Pass: non-zero is returned and expected message is generated"
];


(* Syntax protection *)
TestNonZero[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestNonZero, ApplyToInput -> Plus];

TestNonZero[
	{5},
	TestID -> "Pass: 5, with ApplyToInput"
];

TestNonZero[
	{2, 2},
	TestID -> "Pass: 2 + 2, with ApplyToInput"
];

TestNonZero[
	{6, - 3 * 2},
	TestID -> "Fail: 6 - 3 * 2, with ApplyToInput"
];


(* ApplyToInput option messages *)
SetOptions[TestNonZero, ApplyToInput -> Sin];

TestNonZero[
	{1, 2},
	TestID -> "Fail: non-zero is returned, but message is generated, \
with ApplyToInput"
];

TestNonZero[
	{1, 2},
	{Sin::argx},
	TestID -> "Pass: non-zero is returned and expected message is generated, \
with ApplyToInput"
];
