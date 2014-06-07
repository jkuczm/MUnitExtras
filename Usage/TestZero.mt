(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestZero[
	0,
	TestID -> "Pass: 0"
];

TestZero[
	3 - 6 / 2,
	TestID -> "Pass: 3 - 6/2"
];

TestZero[
	2 + 2,
	TestID -> "Fail: 2 + 2"
];


(* Messages *)

TestZero[
	(Message[Sin::argx, Sin, 2]; 0),
	TestID -> "Fail: 0 is returned, but message is generated"
];

TestZero[
	(Message[Sin::argx, Sin, 2]; 0),
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: 0 is returned and expected message is generated"
];


(* Syntax protection *)
TestZero[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestZero, ApplyToInput -> Plus];

TestZero[
	{0},
	TestID -> "Pass: 0, with ApplyToInput"
];

TestZero[
	{3, - 6 / 2},
	TestID -> "Pass: 3 - 6/2, with ApplyToInput"
];

TestZero[
	{2, 2},
	TestID -> "Fail: 2 + 2, with ApplyToInput"
];


(* ApplyToInput option messages *)

TestZero[
	{(Message[Sin::argx, Sin, 2]; 2), -2},
	TestID -> "Fail: 0 is returned, but message is generated, \
with ApplyToInput"
];

TestZero[
	{(Message[Sin::argx, Sin, 2]; 2), -2},
	{Sin::argx},
	TestID -> "Pass: 0 is returned and expected message is generated, \
with ApplyToInput"
];
