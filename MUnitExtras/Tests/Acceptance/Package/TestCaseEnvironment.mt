(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`Package`TestCaseEnvironment`"];


Needs["MUnitExtras`Package`"];
Needs["MUnitExtras`MUnit`"];


$TestResultLog = {};

mockLogTestResult[tr_] := AppendTo[$TestResultLog, tr]


AssignTestFeatures[mockTestCase];

mockTestCase[input1_, input2_, expected_, opts:OptionsPattern[]] :=
	TestCaseEnvironment[
		{opts, Options[mockTestCase]}
		,
		If[input1 === "forbiden value",
			ThrowTestError["input1 can't be \"forbiden value\""]
		];
		
		Test[input1, expected, TestFailureMessage -> "test 1 failed"];
		Test[input2, expected, TestFailureMessage -> "test 2 failed"];
	];


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*Success and Failure*)


Block[
	{$TestResultLog = {}}
	,
	Test[
		Block[
			{MUnit`Package`logTestResult = mockLogTestResult}
			,
			mockTestCase[
				1 + 3,
				1 * 3,
				4,
				EquivalenceFunction -> Equal,
				TestFailureMessage -> "test case failure message",
				TestID -> "mockID"
			]
		]
		,
		Null
		,
		TestID -> "Success and Failure: \
mockTestCase evaluation"
	];
	
	Test[
		Length[$TestResultLog],
		2,
		TestID -> "Success and Failure: \
two test results were logged"
	];
	
	Module[
		{tr = $TestResultLog[[1]]}
		,
		Test[
			FailureMode[tr],
			"Success",
			TestID -> "Success and Failure: \
First Test: TestResultObject: FailureMode"
		];
		Test[
			TestID[tr],
			"mockID",
			TestID -> "Success and Failure: \
First Test: TestResultObject: TestID"
			];
		Test[
			EquivalenceFunction[tr],
			Equal,
			TestID -> "Success and Failure: \
First Test: TestResultObject: EquivalenceFunction"
		];
		Test[
			TestFailureMessageGenerator[tr][tr],
			"test case failure message: test 1 failed | 1 + 3 == 4",
			TestID -> "Success and Failure: \
First Test: TestResultObject: TestFailureMessageGenerator evaluation"
		];
	];
	
	Module[
		{tr = $TestResultLog[[2]]}
		,
		Test[
			FailureMode[tr],
			"Failure",
			TestID -> "Success and Failure: \
Second Test: TestResultObject: FailureMode"
		];
		Test[
			TestID[tr],
			"mockID",
			TestID -> "Success and Failure: \
Second Test: TestResultObject: TestID"
		];
		Test[
			EquivalenceFunction[tr],
			Equal,
			TestID -> "Success and Failure: \
Second Test: TestResultObject: EquivalenceFunction"
		];
		Test[
			TestFailureMessageGenerator[tr][tr],
			"test case failure message: test 2 failed | Not true that: 1*3 == 4",
			TestID -> "Success and Failure: \
Second Test: TestResultObject: TestFailureMessageGenerator evaluation"
		];
	];
];


(* ::Subsection:: *)
(*Test case level error*)


Block[
	{$TestResultLog = {}}
	,
	TestStringMatch[
		Block[
			{MUnit`Package`logTestResult = mockLogTestResult}
			,
			SymbolName @ mockTestCase[
				"forbiden value",
				1,
				1,
				EquivalenceFunction -> Equal,
				TestFailureMessage -> "test case failure message",
				TestID -> "mockIDError"
			]
		]
		,
		"TestResultObject*"
		,
		TestID -> "Test case level error: \
mockTestCase evaluation"
	];
	
	Test[
		Length[$TestResultLog],
		1,
		TestID -> "Test case level error: \
one test result was logged"
	];
	
	Module[
		{tr = $TestResultLog[[1]]}
		,
		Test[
			FailureMode[tr],
			"Error",
			TestID -> "Test case level error: \
TestResultObject: FailureMode"
		];
		Test[
			TestID[tr],
			"mockIDError",
			TestID -> "Test case level error: \
TestResultObject: TestID"
			];
		Test[
			ErrorMessage[tr],
			"input1 can't be \"forbiden value\"",
			TestID -> "Test case level error: \
TestResultObject: ErrorMessage"
		];
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
