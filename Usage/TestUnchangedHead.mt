(* Mathematica Test File *)

Needs["MUnitExtras`"];


Remove[f];
f::testMessage = "Test message for symbol f."
SetAttributes[f, Orderless];
f[x_] := x;
f[x_, x_, x_] := f[x, x] /; (Message[f::testMessage]; True);


TestUnchangedHead[
	f[],
	TestID -> "Pass: no args"
];

TestUnchangedHead[
	f[2, 1],
	TestID -> "Pass: 2 args in reversed order, \
evaluation changes order of arguments, but head remains unchanged"
];

TestUnchangedHead[
	f[5],
	TestID -> "Fail: 1 arg"
];


(* Messages *)

TestUnchangedHead[
	f[1, 1, 1],
	TestID -> "Fail: head remains unchanged, \
but unexpected message is generated"
];

TestUnchangedHead[
	f[1, 1, 1],
	{HoldForm[Message[f::testMessage]]},
	TestID -> "Pass: head remains unchanged and expected message is generated"
];


(* Syntax protection *)
TestUnchangedHead[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestUnchangedHead, ApplyToInput -> f];

TestUnchangedHead[
	{},
	TestID -> "Pass: no args, with ApplyToInput"
];

TestUnchangedHead[
	{2, 1},
	TestID -> "Pass: 2 args in reversed order, \
evaluation changes order of arguments, but head remains unchanged, \
with ApplyToInput"
];

TestUnchangedHead[
	{5},
	TestID -> "Fail: 1 arg, with ApplyToInput"
];


(* ApplyToInput option messages *)
TestUnchangedHead[
	{1, 1, 1},
	TestID -> "Fail: head remains unchanged, \
but unexpected message is generated, with ApplyToInput"
];

TestUnchangedHead[
	{1, 1, 1},
	{HoldForm[Message[f::testMessage]]},
	TestID -> "Pass: head remains unchanged \
and expected message is generated, with ApplyToInput"
];
