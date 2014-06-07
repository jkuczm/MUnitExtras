(* Mathematica Test File *)

Needs["MUnitExtras`"];


(* Symbols with numeric values *)
N[a] = 2.;
N[b] = 5.;


(* Alternative numeric function *)
myN[a] ^= 3.;
myN[b] ^= 4.;
myN[x_?AtomQ] := N[x]
myN[x_] := myN /@ x


TestN[
	2 + 3,
	5,
	TestID -> "Pass: 5 = 5"
];

TestN[
	2 + 2,
	5,
	TestID -> "Fail: 2 + 2 = 5"
];


TestN[
	a + 3,
	b,
	TestID -> "Pass: a + 3 = b."
];


(* Messages *)

TestN[
	(Message[Sin::argx, Sin, 2]; 2 + 3),
	5,
	TestID -> "Fail: 5 is returned, but unexpected message is generated"
];

TestN[
	(Message[Sin::argx, Sin, 2]; 2 + 3),
	5,
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: 5 is returned and expected message is generated"
];


(* Syntax protection *)
TestN[
	1, 2, 3, 4,
	TestID -> "Error: wrong arguments",
	TestErrorAction -> "Continue"
];


(* Non-numeric results *)
TestN[
	c,
	5,
	TestID -> "Error: non-numeric N[input]",
	TestErrorAction -> "Continue"
];
TestN[
	5,
	c,
	TestID -> "Error: non-numeric N[expected]",
	TestErrorAction -> "Continue"
];
TestN[
	c,
	c,
	TestID -> "Error: non-numeric N[input] and N[expected]",
	TestErrorAction -> "Continue"
];


(* N option *)
SetOptions[TestN, N -> myN];

TestN[
	a + 1,
	b,
	TestID -> "Pass: myN[a] + 1 = myN[b]."
];
TestN[
	a + 3,
	b,
	TestID -> "Fail: myN[a] + 3 = myN[b]."
];

SetOptions[TestN, N -> N];


(* InputWrapper option *)
SetOptions[TestN, InputWrapper -> myN];

TestN[
	a + 2,
	b,
	TestID -> "Pass: myN[a] + 2 = N[b]."
];
TestN[
	a + 3,
	b,
	TestID -> "Fail: myN[a] + 3 = N[b]."
];

SetOptions[TestN, InputWrapper -> Automatic];


(* ApplyToInput option *)
SetOptions[TestN, ApplyToInput -> Plus];

TestN[
	{2, 3},
	5,
	TestID -> "Pass: 2 + 3, with ApplyToInput"
];
TestN[
	{2, 2},
	5,
	TestID -> "Fail: 2 + 2, with ApplyToInput"
];

SetOptions[TestN, ApplyToInput -> None];
