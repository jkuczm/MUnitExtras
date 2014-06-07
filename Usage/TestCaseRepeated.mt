(* Mathematica Test File *)

Needs["MUnitExtras`"];


TestCaseRepeated[
	Test[
		2 + 2,
		4,
		TestID -> "Test not performed due to error in test case"
	]
	,	
	TestID -> "Error: RepeatFor option not set",
	TestErrorAction -> "Continue"
];
TestCaseRepeated[
	Test[
		2 + 2,
		4,
		TestID -> "Test not performed due to error in test case"
	]
	,	
	TestID -> "Error: wrong value of RepeatFor option",
	TestErrorAction -> "Continue",
	RepeatFor -> {
		a -> b,
		c
	}
];



TestCaseRepeated[
	Test[
		a + 2,
		b + 1,
		TestID -> "Pass: 2+2=3+1, -1+2=0+1"
	]
	,
	RepeatFor -> {
		{a -> 2, b -> 3},
		{a -> -1, b -> 0}
	}
];
TestCaseRepeated[
	Test[
		a + 2,
		b + 1
	]
	,
	RepeatFor -> {
		{a -> 2, b -> 3},
		{a -> -1, b -> 0}
	},
	TestID -> "Pass: (TestID passing)"
];

TestCaseRepeated[
	Test[
		f[2, 3],
		5,
		TestID -> "2+3=5 Pass, 2*3=5 Fail"
	]
	,
	RepeatFor -> {
		f -> Plus,
		f -> Times
	}
];

TestCaseRepeated[
	Test[
		f[a, b],
		7,
		TestID -> "Fail: 2+3=7, 4*2=7"
	]
	,
	RepeatFor -> {
		{f -> Plus, a -> 2, b -> 3},
		{f -> Times, a -> 4, b -> 2}
	}
];

TestCaseRepeated[
	Test[
		f[a, b],
		7,
		TestID -> "Fail: 2+3=7, 4*2=7 (explicit failure message)",
		TestFailureMessage -> "MyTestFailureMessage"
	]
	,
	RepeatFor -> {
		{f -> Plus, a -> 2, b -> 3},
		{f -> Times, a -> 4, b -> 2}
	},
	TestFailureMessage -> "MyTestCaseFailureMessage"
];


TestCaseRepeated[
	TestCaseMultipleFunctions[
		{a, b},
		7,
		TestID -> "Fail: test case inside (explicit failure message)",
		Test -> Test,
		ApplyToInput -> {Plus, Times}
	];
	,
	RepeatFor -> {
		{a -> 2, b -> 3},
		{a -> 4, b -> 2}
	},
	TestFailureMessage -> "MyTestCaseFailureMessage"
];

TestCaseRepeated[
	testFunction[
		Message[Sin::argx, Sin, 2],
		{HoldForm[Message[Sin::argx, Sin, 2]]},
		TestID -> "message: TestNull: Pass, TestZero: Fail"
	];
	
	testFunction[
		2 - 2,
		TestID -> "2-2: TestNull: Fail, TestZero: Pass"
	];
	,
	RepeatFor -> {
		testFunction -> TestNull,
		testFunction -> TestZero
	}
];

TestCaseRepeated[
	TestCaseRepeated[
		Test[
			a + 2,
			b + 1,
			TestID -> "Nested, explicit RepeatFor option: \
2+2=3+1 Pass, 2+2=0+1 Fail, -1+2=3+1 Fail, -1+2=0+1 Pass"
		]
		,
		RepeatFor -> {
			b -> 3,
			b -> 0
		}
	]
	,
	RepeatFor -> {
		a -> 2,
		a -> -1
	}
];

TestCaseRepeated[
	SetOptions[
		TestCaseRepeated
		,
		RepeatFor -> {
			b -> 3,
			b -> 0
		}
	];
	
	TestCaseRepeated[
		Test[
			a + 2,
			b + 1,
			TestID -> "Nested, default RepeatFor option set in body: \
2+2=3+1 Pass, 2+2=0+1 Fail, -1+2=3+1 Fail, -1+2=0+1 Pass"
		]
	]
	,
	RepeatFor -> {
		a -> 2,
		a -> -1
	}
];
