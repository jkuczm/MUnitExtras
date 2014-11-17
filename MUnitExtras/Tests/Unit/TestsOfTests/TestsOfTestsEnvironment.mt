(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TestsOfTests`TestsOfTestsEnvironment`"]


Needs["EvaluationUtilities`"] (* HoldFunctionsEvaluation *)


Needs["MUnitExtras`TestsOfTests`"]


PrependTo[$ContextPath, "MUnit`Package`"]


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*no args*)


Block[
	{$TestsOfTestsLog = {}}
	,
	Module[
		{result}
		,
		TestMatch[
			HoldFunctionsEvaluation[
				{testError}
				,
				result = TestsOfTestsEnvironment[]
			]
			,
			HoldComplete[_testError]
			,
			TestID -> "no args: \
TestsOfTestsEnvironment evaluation: testError is returned"
		];
		
		Test[
			result[[1, 1]]
			,
			"TestsOfTestsEnvironment called with incorrect arguments: {}."
			,
			TestID -> "no args: \
testError message"
		];
	
		Test[
			$TestsOfTestsLog,
			{},
			TestID -> "no args: \
nothing was logged in $TestsOfTestsLog"
		];
	]
]


(* ::Subsection:: *)
(*1 arg*)


(* ::Subsubsection:: *)
(*no tests*)


Block[
	{$TestsOfTestsLog = {}}
	,
	Test[
		TestsOfTestsEnvironment["no tests"],
		"no tests"
		,
		TestID -> "1 arg: no tests: \
TestsOfTestsEnvironment evaluation"
	];
	
	Test[
		$TestsOfTestsLog,
		{},
		TestID -> "1 arg: no tests: \
nothing was logged in $TestsOfTestsLog"
	];
]


(* ::Subsubsection:: *)
(*1 test result*)


Module[
	{tr}
	,
	Block[
		{$TestsOfTestsLog = {}}
		,
		Test[
			TestResultQ @ TestsOfTestsEnvironment[
				tr =
					Test[
						True,
						True,
						TestID -> "TestID: 1 arg: 1 test result"
					]
			]
			,
			True
			,
			TestID -> "1 arg: 1 test result: \
TestsOfTestsEnvironment evaluation"
		];
		
		Test[
			$TestsOfTestsLog,
			{tr},
			TestID -> "1 arg: 1 test result: \
proper test results were logged in $TestsOfTestsLog"
		];
	]
]


(* ::Subsubsection:: *)
(*2 test results*)


Module[
	{tr1, tr2}
	,
	Block[
		{$TestsOfTestsLog = {}}
		,
		Test[
			TestsOfTestsEnvironment[
				tr1 =
					Test[
						True,
						True,
						TestID -> "TestID Success: 1 arg: 2 test results"
					];
				tr2 =
					Test[
						False,
						True,
						TestID -> "TestID Failure: 1 arg: 2 test results"
					];
			]
			,
			Null
			,
			TestID -> "1 arg: 2 test results: \
TestsOfTestsEnvironment evaluation"
		];
		
		Test[
			$TestsOfTestsLog,
			{tr1, tr2},
			TestID -> "1 arg: 2 test results: \
proper test results were logged in $TestsOfTestsLog"
		];
	]
]


(* ::Subsubsection:: *)
(*3 test results*)


Module[
	{tr1, tr2, tr3}
	,
	Block[
		{$TestsOfTestsLog = {}}
		,
		Test[
			TestsOfTestsEnvironment[
				tr1 =
					Test[
						True,
						True,
						TestID -> "TestID Success: 1 arg: 3 test results"
					];
				tr2 =
					Test[
						False,
						True,
						TestID -> "TestID Failure: 1 arg: 3 test results"
					];
				tr3 =
					testError[
						"Some error message",
						TestID -> "TestID Error: 1 arg: 3 test results"
					];
			]
			,
			Null
			,
			TestID -> "1 arg: 3 test results: \
TestsOfTestsEnvironment evaluation"
		];
		
		Test[
			$TestsOfTestsLog,
			{tr1, tr2, tr3},
			TestID -> "1 arg: 3 test results: \
proper test results were logged in $TestsOfTestsLog"
		];
	]
]


(* ::Subsection:: *)
(*2 args*)


Block[
	{$TestsOfTestsLog = {}}
	,
	Module[
		{result}
		,
		TestMatch[
			MUnit`Package`$lexicalTestIndex -= 2;
			HoldFunctionsEvaluation[
				{testError}
				,
				result = TestsOfTestsEnvironment[
					Test[
						True,
						True,
						TestID -> "TestID first arg: 2 args"
					]
					,
					Test[
						False,
						True,
						TestID -> "TestID second arg: 2 args"
					]
				]
			]
			,
			HoldComplete[_testError]
			,
			TestID -> "2 args: \
TestsOfTestsEnvironment evaluation: testError is returned"
		];
		
		Test[
			result[[1, 1]]
			,
			"TestsOfTestsEnvironment called with incorrect arguments: \
{\
Test[True, True, TestID -> \"TestID first arg: 2 args\"], \
Test[False, True, TestID -> \"TestID second arg: 2 args\"]\
}."
			,
			TestID -> "2 args: \
testError message"
		];
		
		Test[
			$TestsOfTestsLog,
			{},
			TestID -> "2 args: \
nothing was logged in $TestsOfTestsLog"
		];
	]
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
