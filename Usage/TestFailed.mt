(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestFailed[
	$Failed,
	TestID -> "Pass: $Failed"
];

TestFailed[
	2 + 2,
	TestID -> "Fail: 4"
];


(* Messages *)

TestFailed[
	Get["non-existing_file.foo"],
	TestID -> "Fail: $Failed is returned, but unexpected message is generated"
];

TestFailed[
	Get["non-existing_file.foo"],
	Get::noopen,
	TestID -> "Pass: $Failed is returned and expected message is generated"
];


(* Syntax protection *)
TestFailed[
	1, 2, 3,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* ApplyToInput option *)
SetOptions[TestFailed, ApplyToInput -> Identity];

TestFailed[
	{$Failed},
	TestID -> "Pass: $Failed, with ApplyToInput"
];

TestFailed[
	{2 + 2},
	TestID -> "Fail: 4, with ApplyToInput"
];


(* ApplyToInput option messages *)
SetOptions[TestFailed, ApplyToInput -> Get];

TestFailed[
	{"non-existing_file.foo"},
	TestID ->
		"Fail: $Failed is returned, but unexpected message is generated, \
with ApplyToInput"
];

TestFailed[
	{"non-existing_file.foo"},
	{HoldForm[Message[Get::noopen, HoldForm["non-existing_file.foo"]]]},
	TestID ->
		"Pass: $Failed is returned and expected message is generated, \
with ApplyToInput"
];
