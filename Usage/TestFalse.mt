(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestFalse[
	False,
	TestID -> "Pass: False"
];

TestFalse[
	IntegerQ["la"],
	TestID -> "Pass: string is not an integer"
];

TestFalse[
	2 + 2,
	TestID -> "Fail: 4"
];


(* Messages *)

TestFalse[
	(Message[Sin::argx, Sin, 2]; False),
	TestID -> "Fail: False is returned, but unexpected message is generated"
];

TestFalse[
	(Message[Sin::argx, Sin, 2]; False),
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: False is returned and expected message is generated"
];


(* Syntax protection *)
TestFalse[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];
