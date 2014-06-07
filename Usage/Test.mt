(* Mathematica Test File *)

Needs["MUnitExtras`"];


(* ApplyToInput option *)
SetOptions[Test, ApplyToInput -> Plus];

Test[
	{2, 2},
	4,
	TestID -> "Pass: 2 + 2 is 4, with ApplyToInput"
];

Test[
	{2, 2},
	2 + 3,
	TestID -> "Fail: 2 + 2 is 2 + 3, with ApplyToInput"
];

Test[
	{2, 3},
	6,
	TestID -> "Pass: 2 * 3 is 6, with ApplyToInput",
	ApplyToInput -> Times
];


Test[
	{2},
	2,
	TestID -> "Fail: 2. same as 2, with ApplyToInput",
	ApplyToInput -> N
];

Test[
	{2},
	2,
	TestID -> "Pass: 2. equal to 2, with ApplyToInput",
	ApplyToInput -> N,
	EquivalenceFunction -> (TrueQ[Equal[#1, #2]]&)
];


(* ApplyToInput option messages *)

SetOptions[Test, ApplyToInput -> Sin];

Test[
	{1, 2},
	Sin[1, 2],
	TestID -> "Fail: Sin[1, 2] stays unevaluated, but generates message, \
with ApplyToInput"
];

Test[
	{1, 2},
	Sin[1, 2],
	Message[Sin::argx, Sin, 2],
	TestID -> "Pass: Sin[1, 2] stays unevaluated \
and expected message is generated, with ApplyToInput"
];


SetOptions[Test, ApplyToInput -> None];


(* InputWrapper option *)
SetOptions[Test, InputWrapper -> Head];

Test[
	2 + 2,
	Integer,
	TestID -> "Pass: Head of 2 + 2 is Integer, with InputWrapper"
];
Test[
	2 + 2,
	Plus,
	TestID -> "Fail: Head of 2 + 2 is not Plus, with InputWrapper"
];

Test[
	{2, 3},
	List,
	TestID -> "Pass: Head of {2, 3} is List, with InputWrapper"
];


SetOptions[Test, InputWrapper -> N];
Test[
	2,
	2.,
	TestID -> "Pass: N[2] is 2., with InputWrapper"
];
Test[
	2,
	2,
	TestID -> "Fail: N[2] is not 2, with InputWrapper"
];


(* InputWrapper option messages *)

SetOptions[Test, InputWrapper -> N];

Test[
	(Message[Sin::argx, Sin, 2]; 2),
	2.,
	TestID -> "Fail: 2. is returned, but message is generated, \
with InputWrapper"
];

Test[
	(Message[Sin::argx, Sin, 2]; 2),
	2.,
	{HoldForm[Message[Sin::argx, Sin, 2]]},
	TestID -> "Pass: 2. is returned and expected message is generated, \
with InputWrapper"
];


SetOptions[Test, InputWrapper -> None];


(* ApplyToInput and InputWrapper options *)
SetOptions[Test, ApplyToInput -> Plus];
SetOptions[Test, InputWrapper -> Head];

Test[
	{2, 2},
	List,
	TestID -> "Fail: Head of 2 + 2 is not List, \
with ApplyToInput and InputWrapper"
];
Test[
	{2, 2},
	Plus,
	TestID -> "Fail: Head of 2 + 2 is  not Plus, \
with ApplyToInput and InputWrapper"
];
Test[
	{2, 2},
	Integer,
	TestID -> "Pass: Head of 2 + 2 is Integer, \
with ApplyToInput and InputWrapper"
];


SetOptions[Test, ApplyToInput -> None];
SetOptions[Test, InputWrapper -> None];


