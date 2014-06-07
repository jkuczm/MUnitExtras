(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TestsOfTests`TestCaseOfTestResult`"];


Needs["MUnitExtras`TestsOfTests`"];


PrependTo[$ContextPath, "MUnit`Package`"]


Needs["EvaluationUtilities`"]; (* TraceLog, HoldFunctionsEvaluation *)


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*no args*)


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		TestCaseOfTestResult[]
	]
	,
	HoldComplete @ testError[
		"TestCaseOfTestResult called with incorrect arguments: {}."
	]
	,
	TestID -> "no args: \
TestCaseOfTestResult evaluation: \
testError informing about incorrect arguments is returned"
];


(* ::Subsection:: *)
(*1 arg*)


With[
	{tr = Unique["TestResultObject"]}
	,
	Test[
		HoldFunctionsEvaluation[
			{testError}
			,
			TestCaseOfTestResult[tr]
		]
		,
		With[
			{
				errorMsg =
					"TestCaseOfTestResult called with incorrect arguments: {"
					<> SymbolName[tr] <> "}."
			}
			,
			HoldComplete @ testError[errorMsg]
		]
		,
		TestID -> "1 arg: \
TestCaseOfTestResult evaluation: \
testError informing about incorrect arguments is returned"
	];
];


(* ::Subsection:: *)
(*2 args*)


(* ::Subsubsection:: *)
(*second not a list of rules*)


With[
	{tr = Unique["TestResultObject"]}
	,
	Test[
		HoldFunctionsEvaluation[
			{testError}
			,
			TestCaseOfTestResult[tr, {FailureMode -> "Success", TestInput}]
		]
		,
		With[
			{
				errorMsg =
					"TestCaseOfTestResult called with incorrect arguments: {"
<> SymbolName[tr] <> ", \
{FailureMode -> \"Success\", TestInput}\
}."
			}
			,
			HoldComplete @ testError[errorMsg]
		]
		,
		TestID -> "2 args: second not a list of rules: \
TestCaseOfTestResult evaluation: \
testError informing about incorrect arguments is returned"
	];
];


(* ::Subsubsection:: *)
(*no tests, no messages*)


Module[
	{tr, $Log}
	,
	TestStringMatch[
		SymbolName @ Block[
			{logTestResult}
			,
			TraceLog[
				tr = TestCaseOfTestResult["no tests, no messages"],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		"TestResultObject*"
		,
		TestID -> "1 arg: no tests, no messages: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log,
		HoldForm[TestsOfTestsEnvironment["no tests, no messages"]],
		EquivalenceFunction -> MemberQ,
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
];


(* ::Subsubsection:: *)
(*no tests, message*)


Module[
	{tr, $Log}
	,
	TestStringMatch[
		SymbolName @ Block[
			{logTestResult}
			,
			TraceLog[
				tr = TestCaseOfTestResult[Message[Sin::argx, Sin, 2]],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		"TestResultObject*"
		,
		TestID -> "1 arg: no tests, message: \
TestCaseOfTestResult evaluation"
	];
	
	Test[
		$Log,
		HoldForm[TestsOfTestsEnvironment[Message[Sin::argx, Sin, 2]]],
		EquivalenceFunction -> MemberQ,
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
];


(* ::Subsubsection:: *)
(*tests*)


Module[
	{tr, trInternal, $Log}
	,
	TestStringMatch[
		SymbolName @ Block[
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
		"TestResultObject*"
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
		EquivalenceFunction -> MemberQ,
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
];


(* ::Subsubsection:: *)
(*tests, options*)


Module[
	{tr, trInternal, $Log}
	,
	TestStringMatch[
		SymbolName @ Block[
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
		"TestResultObject*"
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
		EquivalenceFunction -> MemberQ,
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
];


(* ::Subsection:: *)
(*2 args*)


(* ::Subsubsection:: *)
(*tests, no messages*)


Module[
	{tr, trInternal, $Log}
	,
	TestStringMatch[
		SymbolName @ Block[
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
		"TestResultObject*"
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
		EquivalenceFunction -> MemberQ,
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
];


(* ::Subsubsection:: *)
(*tests, messages*)


Module[
	{tr, trInternal, $Log}
	,
	TestStringMatch[
		SymbolName @ Block[
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
		"TestResultObject*"
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
		EquivalenceFunction -> MemberQ,
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
];


(* ::Subsection:: *)
(*3 args*)


Module[
	{$Log}
	,
	Test[
		HoldFunctionsEvaluation[
			{testError}
			,
			TraceLog[
				TestCaseOfTestResult["arg1", {Message[Sin::argx, Sin, 2]}, "arg3"],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		HoldComplete @ testError[
			"TestCaseOfTestResult called with incorrect arguments: \
{\"arg1\", {Message[Sin::argx, Sin, 2]}, \"arg3\"}."
		]
		,
		TestID -> "3 args: \
TestCaseOfTestResult evaluation: \
testError informing about incorrect arguments is returned"
	];
	
	Test[
		$Log,
		HoldForm[_TestsOfTestsEnvironment],
		EquivalenceFunction -> (!MemberQ[##]&),
		TestID -> "3 args: \
TestsOfTestsEnvironment was not called"
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
