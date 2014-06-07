(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestTrue[
	True,
	TestID -> "Pass: True"
];

TestTrue[
	IntegerQ[5],
	TestID -> "Pass: 5 is an integer"
];

TestTrue[
	2 + 2,
	TestID -> "Fail: 4"
];


(* Messages *)

TestTrue[
	(Message[Sin::argx, Sin, 2]; True),
	TestID -> "Fail: True is returned, but unexpected message is generated"
];

TestTrue[
	(Message[Sin::argx, Sin, 2]; True),
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: True is returned and expected message is generated"
];


(* Syntax protection *)
TestTrue[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];
