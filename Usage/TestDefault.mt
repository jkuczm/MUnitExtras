(* Mathematica Test File *)

Needs["MUnitExtras`"];

TestDefault[
	1,
	TestID -> "Error: ExpectedOutput option not set",
	TestErrorAction -> "Continue"
];


SetOptions[TestDefault, ExpectedOutput -> 5];


TestDefault[
	5,
	TestID -> "Pass: 5"
];

TestDefault[
	2 + 3,
	TestID -> "Pass: 2 + 3"
];

TestDefault[
	2 + 2,
	TestID -> "Fail: 4"
];


(* Messages *)

TestDefault[
	(Message[Sin::argx, Sin, 2]; 5),
	TestID -> "Fail: 5 is returned, but unexpected message is generated"
];

TestDefault[
	(Message[Sin::argx, Sin, 2]; 5),
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: 5 is returned and expected message is generated"
];


(* Syntax protection *)
TestDefault[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestDefault, ApplyToInput -> Plus];
SetOptions[TestDefault, ExpectedOutput -> 5];


TestDefault[
	{5},
	TestID -> "Pass: 5, with ApplyToInput"
];

TestDefault[
	{2, 3},
	TestID -> "Pass: 2 + 3, with ApplyToInput"
];

TestDefault[
	{2, 2},
	TestID -> "Fail: 2 + 2, with ApplyToInput"
];
