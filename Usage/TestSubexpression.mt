(* Mathematica Test File *)

Needs["MUnitExtras`"];


Remove[f];
f::testMessage = "Test message for symbol f."
f[x_] := x;
f[x_, y_] := x + y;
f[_, {y_, _}] := y;
f[x_, _, _] := x /; (Message[f::testMessage]; True);


TestSubexpression[
	f[2],
	TestID -> "Pass: first argument 2 is returned"
];

TestSubexpression[
	f[1, 2],
	TestID -> "Fail: sum of arguments instead of first argument is returned"
];


TestSubexpression[
	f[1, {2, 3}],
	TestID -> "Pass: complicated argument position",
	SubexpressionPosition -> {2, 1}
];


(* Messages *)

TestSubexpression[
	f[1, 2, 3],
	TestID -> "Fail: first argument is returned, but message is generated"
];

TestSubexpression[
	f[1, 2, 3],
	{HoldForm[Message[f::testMessage]]},
	TestID -> "Pass: first argument is returned \
and expected message is generated"
];



TestSubexpression[
	f[1, 2],
	TestID -> "Error: argument extraction failed",
	SubexpressionPosition -> {5},
	TestErrorAction -> "Continue"
];


(* Syntax protection *)
TestSubexpression[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestSubexpression, ApplyToInput -> f];

TestSubexpression[
	{2},
	TestID -> "Pass: first argument 2 is returned, with ApplyToInput"
];

TestSubexpression[
	{1, 2},
	TestID -> "Fail: sum of arguments instead of first argument is returned, \
with ApplyToInput"
];
