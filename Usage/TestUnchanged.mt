(* Mathematica Test File *)

Needs["MUnitExtras`"];


Remove[f];
f::testMessage = "Test message for symbol f."
f[x_] := x;
f[_, _, _] := "Never happens" /; (Message[f::testMessage]; False);


TestUnchanged[
	f[],
	TestID -> "Pass: no args"
];

TestUnchanged[
	f[1, 2],
	TestID -> "Pass: 2 args"
];

TestUnchanged[
	f[5],
	TestID -> "Fail: 1 arg"
];


(* Messages *)

TestUnchanged[
	f[1, 2, 3],
	TestID -> "Fail: f remains unevaluated, \
but unexpected message is generated"
];

TestUnchanged[
	f[1, 2, 3],
	{HoldForm[Message[f::testMessage]]},
	TestID -> "Pass: f remains unevaluated and expected message is generated"
];


(* Syntax protection *)
TestUnchanged[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestUnchanged, ApplyToInput -> f];


TestUnchanged[
	{},
	TestID -> "Pass: no args, with ApplyToInput"
];

TestUnchanged[
	{1, 2},
	TestID -> "Pass: 2 args, with ApplyToInput"
];

TestUnchanged[
	{5},
	TestID -> "Fail: 1 arg, with ApplyToInput"
];


(* ApplyToInput option messages *)
TestUnchanged[
	{1, 2, 3},
	TestID -> "Fail: f remains unevaluated, \
but unexpected message is generated, with ApplyToInput"
];

TestUnchanged[
	{1, 2, 3},
	{HoldForm[Message[f::testMessage]]},
	TestID -> "Pass: f remains unevaluated and expected message is generated, \
with ApplyToInput"
];
