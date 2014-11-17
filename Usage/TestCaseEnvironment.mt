(* Mathematica Test File *)

Needs["MUnitExtras`"];
Needs["MUnitExtras`Package`"];


Options[TestCaseMy] = {
	TestID -> 0,
	TestFailureMessage -> ""
};
TestCaseMy[input_, opts:OptionsPattern[]] :=
	TestCaseEnvironment[
		{opts}
		,
		TestMatch[
			input,
			HoldPattern[_ + _],
			TestFailureMessage -> "Analytic"
		];
		
		Test[
			N[input],
			4,
			SameTest -> Equal,
			TestFailureMessage -> "Numeric"
		];
	];


N[a] = 1;
N[b] = 3;

TestCaseMy[
	a + b,
	TestID -> "Pass: a + b = 4"
]


N[a] = 4;

TestCaseMy[
	a + b,
	TestID -> "Pass analytic, Fail numeric"
]

TestCaseMy[
	a,
	TestID -> "Fail analytic, Pass numeric"
]

TestCaseMy[
	b,
	TestID -> "Fail analytic, Fail numeric"
]

TestCaseMy[
	b,
	TestID -> "Fail analytic, Fail numeric, with test case failure message",
	TestFailureMessage -> "test case failure message"
]
