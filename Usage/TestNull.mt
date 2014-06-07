(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestNull[
	Null,
	TestID -> "Pass: Null"
];

TestNull[
	Print["Lorem ipsum"],
	TestID -> "Pass: Print"
];

TestNull[
	2 + 2,
	TestID -> "Fail: 4"
];


(* Messages *)

TestNull[
	Message[Sin::argx, Sin, 2],
	TestID -> "Fail: Null is returned, but unexpected message is generated"
];

TestNull[
	Message[Sin::argx, Sin, 2],
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: Null is returned and expected message is generated"
];


(* Syntax protection *)
TestNull[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
TestNull[
	{"Lorem ipsum"},
	TestID -> "Pass: Print returns Null, with ApplyToInput",
	ApplyToInput -> Print
];

TestNull[
	{2, 2},
	TestID -> "Fail: 4, with ApplyToInput",
	ApplyToInput -> Plus
];


(* ApplyToInput option messages *)
SetOptions[TestNull, ApplyToInput -> Message];

TestNull[
	{Sin::argx, Sin, 2},
	TestID -> "Fail: Null is returned, but unexpected message is generated, \
with ApplyToInput"
];

TestNull[
	{Sin::argx, Sin, 2},
	{Sin::argx},
	TestID -> "Pass: Null is returned and expected message is generated, \
with ApplyToInput"
];
