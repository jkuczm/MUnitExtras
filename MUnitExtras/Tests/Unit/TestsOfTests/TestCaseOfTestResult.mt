(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TestsOfTests`TestCaseOfTestResult`"]


Needs["MUnitExtras`TestsOfTests`"]


PrependTo[$ContextPath, "MUnit`Package`"]


Needs["EvaluationUtilities`"] (* TraceLog, HoldFunctionsEvaluation *)


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*no args*)


Module[
	{result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = TestCaseOfTestResult[]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "no args: \
TestCaseOfTestResult evaluation: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"TestCaseOfTestResult called with incorrect arguments: {}."
		,
		TestID -> "no args: \
testError message"
	];
]


(* ::Subsection:: *)
(*1 arg*)


Module[
	{result}
	,
	With[
		{tr = Unique["TestResultObject"]}
		,
		TestMatch[
			HoldFunctionsEvaluation[
				{testError}
				,
				result = TestCaseOfTestResult[tr]
			]
			,
			HoldComplete[_testError]
			,
			TestID -> "1 arg: \
TestCaseOfTestResult evaluation: testError is returned"
		];
		
		Test[
			result[[1, 1]]
			,
			"TestCaseOfTestResult called with incorrect arguments: {"
				<> SymbolName[tr] <> "}."
			,
			TestID -> "1 arg: \
testError message"
		];
	]
]


(* ::Subsection:: *)
(*2 args*)


(* ::Subsubsection:: *)
(*second not a list of rules*)


Module[
	{result}
	,
	With[
		{tr = Unique["TestResultObject"]}
		,
		TestMatch[
			HoldFunctionsEvaluation[
				{testError}
				,
				result =
					TestCaseOfTestResult[tr, {FailureMode -> "Success", TestInput}]
			]
			,
			HoldComplete[_testError]
			,
			TestID -> "2 args: second not a list of rules: \
TestCaseOfTestResult evaluation: testError is returned"
		];
		
		Test[
			result[[1, 1]]
			,
			"TestCaseOfTestResult called with incorrect arguments: {"
<> SymbolName[tr] <> ", \
{FailureMode -> \"Success\", TestInput}\
}."
			,
			TestID -> "2 args: second not a list of rules: \
testError message"
		];
	]
]


(* ::Subsubsection:: *)
(*no tests, no messages*)


Module[
	{tr, $Log}
	,
	Test[
		(*TestResultQ @*) Block[
			{logTestResult}
			,
			TraceLog[
				tr = TestCaseOfTestResult["no tests, no messages"],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: no tests, no messages: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log,
		HoldForm[TestsOfTestsEnvironment["no tests, no messages"]],
		SameTest -> MemberQ,
		TestID -> "1 arg: no tests, no messages: \
TestsOfTestsEnvironment was called with proper arguments"
	];

	Test[
		FailureMode[tr],
		"Success",
		TestID -> "1 arg: no tests, no messages: \
TestCaseOfTestResult result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm["no tests, no messages"],
		TestID -> "1 arg: no tests, no messages: \
TestCaseOfTestResult result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: no tests, no messages: \
TestCaseOfTestResult result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*no tests, message*)


Module[
	{tr, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult}
			,
			TraceLog[
				tr = TestCaseOfTestResult[Message[Sin::argx, Sin, 2]],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: no tests, message: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log,
		HoldForm[TestsOfTestsEnvironment[Message[Sin::argx, Sin, 2]]],
		SameTest -> MemberQ,
		TestID -> "1 arg: no tests, message: \
TestsOfTestsEnvironment was called with proper arguments"
	];

	Test[
		FailureMode[tr],
		"MessagesFailure",
		TestID -> "1 arg: no tests, message: \
TestCaseOfTestResult result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Null],
		TestID -> "1 arg: no tests, message: \
TestCaseOfTestResult result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: no tests, message: \
TestCaseOfTestResult result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*tests*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult}
			,
			TraceLog[
				tr =
					TestCaseOfTestResult[
						trInternal =
							Test[True, True, TestID -> "TestID: 1 arg: tests"]
					],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: tests: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log
		,
		HoldForm @ TestsOfTestsEnvironment[
			trInternal = Test[True, True, TestID -> "TestID: 1 arg: tests"]
		]
		,
		SameTest -> MemberQ,
		TestID -> "1 arg: tests: \
TestsOfTestsEnvironment was called with proper arguments"
	];

	Test[
		FailureMode[tr],
		"Success",
		TestID -> "1 arg: tests: \
TestCaseOfTestResult result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "1 arg: tests: \
TestCaseOfTestResult result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: tests: \
TestCaseOfTestResult result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*tests, options*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult}
			,
			TraceLog[
				tr =
					TestCaseOfTestResult[
						trInternal = Test[True, True],
						TestID -> "TestCaseOfTestResult TestID: 1 arg: tests, options"
					]
				,
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: tests, options: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log
		,
		HoldForm @ TestsOfTestsEnvironment[
			trInternal = Test[True, True]
		]
		,
		SameTest -> MemberQ,
		TestID -> "1 arg: tests, options: \
TestsOfTestsEnvironment was called with proper arguments"
	];

	Test[
		FailureMode[tr],
		"Success",
		TestID -> "1 arg: tests, options: \
TestCaseOfTestResult result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "1 arg: tests, options: \
TestCaseOfTestResult result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: tests, options: \
TestCaseOfTestResult result: ExpectedMessages"
	];
	Test[
		TestID[tr],
		"TestCaseOfTestResult TestID: 1 arg: tests, options",
		TestID -> "1 arg: tests, options: \
TestCaseOfTestResult result: TestID"
	];
	
	Test[
		TestID[trInternal],
		0,
		TestID -> "1 arg: tests, options: \
internal Test result: TestID"
	];
]


(* ::Subsection:: *)
(*2 args*)


(* ::Subsubsection:: *)
(*tests, no messages*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult}
			,
			TraceLog[
				tr =
					TestCaseOfTestResult[
						trInternal =
							Test[
								True,
								True,
								TestID -> "TestID: 2 arg: tests, no messages"
							]
						,
						{HoldForm[Message[Sin::argx, Sin, 2]]}
					],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "2 arg: tests, no messages: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log
		,
		HoldForm @ TestsOfTestsEnvironment[
			trInternal =
				Test[True, True, TestID -> "TestID: 2 arg: tests, no messages"]
		]
		,
		SameTest -> MemberQ,
		TestID -> "2 arg: tests, no messages: \
TestsOfTestsEnvironment was called with proper arguments"
	];

	Test[
		FailureMode[tr],
		"MessagesFailure",
		TestID -> "2 arg: tests, no messages: \
TestCaseOfTestResult result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "2 arg: tests, no messages: \
TestCaseOfTestResult result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		TestID -> "2 arg: tests, no messages: \
TestCaseOfTestResult result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*tests, messages*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult}
			,
			TraceLog[
				tr =
					TestCaseOfTestResult[
						Message[Sin::argx, Sin, 2];
						trInternal =
							Test[
								True,
								True,
								TestID -> "TestID: 2 arg: tests, messages"
							]
						,
						{HoldForm[Message[Sin::argx, Sin, 2]]}
					],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "2 arg: tests, messages: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log
		,
		HoldForm @ TestsOfTestsEnvironment[
			Message[Sin::argx, Sin, 2];
			trInternal =
				Test[True, True, TestID -> "TestID: 2 arg: tests, messages"]
		]
		,
		SameTest -> MemberQ,
		TestID -> "2 arg: tests, messages: \
TestsOfTestsEnvironment was called with proper arguments"
	];

	Test[
		FailureMode[tr],
		"Success",
		TestID -> "2 arg: tests, messages: \
TestCaseOfTestResult result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "2 arg: tests, messages: \
TestCaseOfTestResult result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		TestID -> "2 arg: tests, messages: \
TestCaseOfTestResult result: ExpectedMessages"
	];
]


(* ::Subsection:: *)
(*3 args*)


Module[
	{$Log, result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			TraceLog[
				result =
					TestCaseOfTestResult["arg1", {Message[Sin::argx, Sin, 2]}, "arg3"]
				,
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "3 args: \
TestCaseOfTestResult evaluation: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"TestCaseOfTestResult called with incorrect arguments: \
{\"arg1\", {Message[Sin::argx, Sin, 2]}, \"arg3\"}."
		,
		TestID -> "3 args: \
testError message"
	];
	
	Test[
		$Log,
		HoldForm[_TestsOfTestsEnvironment],
		SameTest -> (!MemberQ[##]&),
		TestID -> "3 args: \
TestsOfTestsEnvironment was not called"
	];
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
