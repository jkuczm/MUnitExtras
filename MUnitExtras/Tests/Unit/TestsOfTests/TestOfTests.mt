(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TestsOfTests`TestOfTests`"]


Needs["MUnitExtras`TestsOfTests`"]


PrependTo[$ContextPath, "MUnit`Package`"]


Needs["EvaluationUtilities`"] (* TraceLog, HoldFunctionsEvaluation *)


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*no args*)


Module[
	{$Log, result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = TraceLog[
				TestOfTests[],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "no args: \
TestOfTests evaluation: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"TestOfTests called with incorrect arguments: {}."
		,
		TestID -> "no args: \
testError message"
	];
	
	Test[
		$Log,
		HoldForm[_TestsOfTestsEnvironment],
		SameTest -> (!MemberQ[##]&),
		TestID -> "no args: \
TestsOfTestsEnvironment was not called"
	];
]


(* ::Subsection:: *)
(*1 arg*)


(* ::Subsubsection:: *)
(*no tests, no messages*)


Module[
	{tr, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult, $TestIndex = 0, $dynamicTestIndex = 0}
			,
			TraceLog[
				tr = TestOfTests["no tests, no messages"],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: no tests, no messages: \
TestOfTests evaluation"
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
TestOfTests result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm["no tests, no messages"],
		TestID -> "1 arg: no tests, no messages: \
TestOfTests result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: no tests, no messages: \
TestOfTests result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*no tests, message*)


Module[
	{tr, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult, $TestIndex = 0, $dynamicTestIndex = 0}
			,
			TraceLog[
				tr = TestOfTests[Message[Sin::argx, Sin, 2]],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: no tests, message: \
TestOfTests evaluation"
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
TestOfTests result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Null],
		TestID -> "1 arg: no tests, message: \
TestOfTests result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: no tests, message: \
TestOfTests result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*tests*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult, $TestIndex = 0, $dynamicTestIndex = 0}
			,
			TraceLog[
				tr =
					TestOfTests[
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
TestOfTests evaluation"
	];
	
	Test[
		MUnit`Package`$lexicalTestIndex--;
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
TestOfTests result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "1 arg: tests: \
TestOfTests result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: tests: \
TestOfTests result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*tests, options*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		MUnit`Package`$lexicalTestIndex--;
		TestResultQ @ Block[
			{logTestResult, $TestIndex = 0, $dynamicTestIndex = 0}
			,
			TraceLog[
				tr =
					TestOfTests[
						trInternal =
							Test[True, True, TestID -> "fake internal test"]
						,
						TestID -> "TestOfTests TestID: 1 arg: tests, options"
					]
				,
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		True
		,
		TestID -> "1 arg: tests, options: \
TestOfTests evaluation"
	];
	
	Test[
		MUnit`Package`$lexicalTestIndex--;
		$Log
		,
		HoldForm @ TestsOfTestsEnvironment[
			trInternal = Test[True, True, TestID -> "fake internal test"]
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
TestOfTests result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "1 arg: tests, options: \
TestOfTests result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{},
		TestID -> "1 arg: tests, options: \
TestOfTests result: ExpectedMessages"
	];
	Test[
		TestID[tr],
		"TestOfTests TestID: 1 arg: tests, options",
		TestID -> "1 arg: tests, options: \
TestOfTests result: TestID"
	];
	
	Test[
		TestID[trInternal],
		"fake internal test",
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
			{logTestResult, $TestIndex = 0, $dynamicTestIndex = 0}
			,
			TraceLog[
				tr =
					TestOfTests[
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
TestOfTests evaluation"
	];
	
	Test[
		MUnit`Package`$lexicalTestIndex--;
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
TestOfTests result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "2 arg: tests, no messages: \
TestOfTests result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		TestID -> "2 arg: tests, no messages: \
TestOfTests result: ExpectedMessages"
	];
]


(* ::Subsubsection:: *)
(*tests, messages*)


Module[
	{tr, trInternal, $Log}
	,
	Test[
		TestResultQ @ Block[
			{logTestResult, $TestIndex = 0, $dynamicTestIndex = 0}
			,
			TraceLog[
				tr =
					TestOfTests[
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
TestOfTests evaluation"
	];
	
	Test[
		MUnit`Package`$lexicalTestIndex--;
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
TestOfTests result: FailureMode"
	];
	Test[
		ActualOutput[tr],
		HoldForm[Evaluate[trInternal]],
		TestID -> "2 arg: tests, messages: \
TestOfTests result: ActualOutput"
	];
	Test[
		ExpectedMessages[tr],
		{HoldForm[HoldForm[Message[Sin::argx, Sin, 2]]]},
		TestID -> "2 arg: tests, messages: \
TestOfTests result: ExpectedMessages"
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
			result = TraceLog[
				TestOfTests["arg1", {Message[Sin::argx, Sin, 2]}, "arg3"],
				_TestsOfTestsEnvironment -> $Log
			]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "3 args: \
TestOfTests evaluation: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"TestOfTests called with incorrect arguments: \
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
