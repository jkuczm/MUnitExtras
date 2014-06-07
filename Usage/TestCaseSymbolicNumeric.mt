(* Mathematica Test File *)

Needs["MUnitExtras`"];


(* Assign numerical values *)
SeedRandom[0]
(N[#] = RandomReal[])& /@ {a, b, c}


TestCaseSymbolicNumeric[
	Simplify[a b + a c],
	a (b + c),
	TestID -> "Pass: symbolic and numeric; Simplify"
];

TestCaseSymbolicNumeric[
	Simplify[a b + a c],
	a b + a c,
	TestID -> "Symbolic Fail; Numeric Pass; \
Simplify: wrong symbolic expectation"
];

TestCaseSymbolicNumeric[
	Plus[a, b, c],
	a + b + c,
	TestID -> "Symbolic Pass; Numeric Fail; \
sum of three non-zero terms is not equal numerically to first one"
];

TestCaseSymbolicNumeric[
	Plus[a, b, c],
	a,
	TestID -> "Fail: symbolic and numeric; \
sum of three non-zero terms is not equal to first one"
];


TestCaseSymbolicNumeric[
	Simplify[a b + a c],
	a (b + c),
	TestID -> "Symbolic Pass; Numeric Fail; \
Simplify, custom input numeric function",
	InputWrapperN -> (2 N[##]&)
];


TestCaseSymbolicNumeric[
	Plus[a, 0, 0],
	a,
	TestID -> "Error: argument extraction failed",
	SubexpressionPosition -> {5},
	TestErrorAction -> "Continue"
];


TestCaseSymbolicNumeric[
	1, 2, 3, 4,
	TestID -> "Error: wrong syntax",
	TestErrorAction -> "Continue"
];
