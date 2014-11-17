(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`TestCaseEnvironment`"]


Needs["MUnitExtras`Package`"]
Needs["MUnitExtras`MUnit`"]


PrependTo[$ContextPath, "MUnit`Package`"]


Needs["EvaluationUtilities`"] (* HoldFunctionsEvaluation *)
Needs["StringUtilities`"] (* StringJoinBy *)


optionsOriginalTest = Options[Test]
optionsOriginalTestMatch = Options[TestMatch]


TFMGReplaceRule[
	message_:"",
	messageGenerator_:MUnitExtras`MUnit`Private`DefaultFailureMessageGenerator,
	separator_:": "
] :=
	(TestFailureMessageGenerator -> _) ->
		(TestFailureMessageGenerator ->
			(StringUtilities`StringJoinBy[
				message,
				messageGenerator[#1],
				{"Separator" -> separator}
			]&)
		)


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
			result = TestCaseEnvironment[]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "no args: \
TestCaseEnvironment evaluation: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"TestCaseEnvironment called with incorrect arguments: {}."
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
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = TestCaseEnvironment[{}]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "1 arg: \
TestCaseEnvironment evaluation: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"TestCaseEnvironment called with incorrect arguments: {{}}."
		,
		TestID -> "1 arg: \
testError message"
	];
]


(* ::Subsection:: *)
(*2 args*)


(* ::Subsubsection:: *)
(*nothing passed*)


Module[
	{optionsInsideTest, optionsInsideTestMatch}
	,
	Test[
		TestCaseEnvironment[
			{}
			,
			optionsInsideTest = Options[Test];
			optionsInsideTestMatch = Options[TestMatch];
		]
		,
		Null
		,
		TestID -> "2 args: nothing passed: \
TestCaseEnvironment evaluation"
	];
	Test[
		optionsInsideTest,
		optionsOriginalTest /. TFMGReplaceRule[]
		,
		TestID -> "2 args: nothing passed: \
Test options inside"
	];
	Test[
		optionsInsideTestMatch,
		optionsOriginalTestMatch /. TFMGReplaceRule[],
		TestID -> "2 args: nothing passed: \
TestMatch options inside"
	];
	Test[
		Options[Test],
		optionsOriginalTest,
		TestID -> "2 args: nothing passed: \
Test options are unchanged outside TestCaseEnvironment"
	];
	Test[
		Options[TestMatch],
		optionsOriginalTestMatch,
		TestID -> "2 args: nothing passed: \
TestMatch options are unchanged outside TestCaseEnvironment"
	];
]


(* ::Subsubsection:: *)
(*non-option passed*)


Module[
	{optionsInsideTest, optionsInsideTestMatch, result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = TestCaseEnvironment[
				{"non-option"}
				,
				optionsInsideTest = Options[Test];
				optionsInsideTestMatch = Options[TestMatch];
			]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "2 args: non-option passed: \
TestCaseEnvironment evaluation: testError is returned"
	];
	Test[
		result[[1, 1]]
		,
		"TestCaseEnvironment called with incorrect arguments: \
{\
{\"non-option\"}, " <>
SymbolName[Unevaluated[optionsInsideTest]] <> " = Options[Test]; " <>
SymbolName[Unevaluated[optionsInsideTestMatch]] <> " = Options[TestMatch]; \
}."
		,
		TestID -> "2 args: non-option passed: \
testError message"
	];
	TestMatch[
		optionsInsideTest,
		HoldPattern[optionsInsideTest],
		TestID -> "2 args: non-option passed: \
Test options inside"
	];
	TestMatch[
		optionsInsideTestMatch,
		HoldPattern[optionsInsideTestMatch],
		TestID -> "2 args: non-option passed: \
TestMatch options inside"
	];
	Test[
		Options[Test],
		optionsOriginalTest,
		TestID -> "2 args: non-option passed: \
Test options are unchanged outside TestCaseEnvironment"
	];
	Test[
		Options[TestMatch],
		optionsOriginalTestMatch,
		TestID -> "2 args: non-option passed: \
TestMatch options are unchanged outside TestCaseEnvironment"
	];
]


(* ::Subsubsection:: *)
(*options passed*)


Module[
	{optionsInsideTest, optionsInsideTestMatch}
	,
	Test[
		MUnit`Package`$lexicalTestIndex--;
		TestCaseEnvironment[
			{
				TestID -> "mockID",
				SameTestVersioned -> Equal,
				TestFailureMessage -> "mockTestFailureMessage"
			}
			,
			optionsInsideTest = Options[Test];
			optionsInsideTestMatch = Options[TestMatch];
		]
		,
		Null
		,
		TestID -> "2 args: options passed: \
TestCaseEnvironment evaluation"
	];
	Test[
		MUnit`Package`$lexicalTestIndex -= 2;
		optionsInsideTest
		,
		optionsOriginalTest /. {
			TFMGReplaceRule["mockTestFailureMessage"],
			(TestID -> _) -> (TestID -> "mockID"),
			(SameTestVersioned -> _) -> (SameTestVersioned -> Equal),
			(TestFailureMessage -> _) ->
				(TestFailureMessage -> "mockTestFailureMessage")
		}
		,
		TestID -> "2 args: options passed: \
Test options inside"
	];
	Test[
		MUnit`Package`$lexicalTestIndex -= 2;
		optionsInsideTestMatch
		,
		optionsOriginalTestMatch /. {
			TFMGReplaceRule["mockTestFailureMessage"],
			(TestID -> _) -> (TestID -> "mockID"),
			(SameTestVersioned -> _) -> (SameTestVersioned -> Equal),
			(TestFailureMessage -> _) ->
				(TestFailureMessage -> "mockTestFailureMessage")
		}
		,
		TestID -> "2 args: options passed: \
TestMatch options inside"
	];
	Test[
		Options[Test],
		optionsOriginalTest,
		TestID -> "2 args: options passed: \
Test options are unchanged outside TestCaseEnvironment"
	];
	Test[
		Options[TestMatch],
		optionsOriginalTestMatch,
		TestID -> "2 args: options passed: \
TestMatch options are unchanged outside TestCaseEnvironment"
	];
]


(* ::Subsubsection:: *)
(*test error thrown*)


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		TestCaseEnvironment[
			{}
			,
			Throw["some error message", "internalMUnitTestTag"];
		]
	]
	,
	HoldComplete[testError["some error message"]]
	,
	TestID -> "2 args: test error thrown: \
TestCaseEnvironment evaluation: \
testError with thrown message is returned"
]


(* ::Subsection:: *)
(*2 args, non-default "CommonOptionsFor"*)


(* ::Subsubsection:: *)
(*options passed*)


Module[
	{optionsInsideTest, optionsInsideTestMatch}
	,
	Test[
		MUnit`Package`$lexicalTestIndex--;
		TestCaseEnvironment[
			{
				TestID -> "mockID",
				SameTestVersioned -> Equal,
				TestFailureMessage -> "mockTestFailureMessage"
			}
			,
			optionsInsideTest = Options[Test];
			optionsInsideTestMatch = Options[TestMatch];
			,
			"CommonOptionsFor" -> {TestMatch}
		]
		,
		Null
		,
		TestID -> "2 args, non-default \"CommonOptionsFor\": options passed: \
TestCaseEnvironment evaluation"
	];
	Test[
		optionsInsideTest,
		optionsOriginalTest,
		TestID -> "2 args, non-default \"CommonOptionsFor\": options passed: \
Test options inside"
	];
	Test[
		MUnit`Package`$lexicalTestIndex -= 2;
		optionsInsideTestMatch
		,
		optionsOriginalTestMatch /. {
			TFMGReplaceRule["mockTestFailureMessage"],
			(TestID -> _) -> (TestID -> "mockID"),
			(SameTestVersioned -> _) -> (SameTestVersioned -> Equal),
			(TestFailureMessage -> _) ->
				(TestFailureMessage -> "mockTestFailureMessage")
		}
		,
		TestID -> "2 args, non-default \"CommonOptionsFor\": options passed: \
TestMatch options inside"
	];
	Test[
		Options[Test],
		optionsOriginalTest,
		TestID -> "2 args, non-default \"CommonOptionsFor\": options passed: \
Test options are unchanged outside TestCaseEnvironment"
	];
	Test[
		Options[TestMatch],
		optionsOriginalTestMatch,
		TestID -> "2 args, non-default \"CommonOptionsFor\": options passed: \
TestMatch options are unchanged outside TestCaseEnvironment"
	];
]


(* ::Subsection:: *)
(*3 args*)


Module[
	{optionsInsideTest, optionsInsideTestMatch, result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = TestCaseEnvironment[
				{}
				,
				optionsInsideTest = Options[Test];
				optionsInsideTestMatch = Options[TestMatch];
				,
				Null
			]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "3 args: \
TestCaseEnvironment evaluation: testError is returned"
	];
	Test[
		result[[1, 1]]
		,
		"TestCaseEnvironment called with incorrect arguments: \
{\
{}, " <>
SymbolName[Unevaluated[optionsInsideTest]] <> " = Options[Test]; " <>
SymbolName[Unevaluated[optionsInsideTestMatch]] <> " = Options[TestMatch]; , \
Null\
}."
		,
		TestID -> "3 args: \
testError message"
	];
	TestMatch[
		optionsInsideTest,
		HoldPattern[optionsInsideTest],
		TestID -> "3 args: \
Test options inside"
	];
	TestMatch[
		optionsInsideTestMatch,
		HoldPattern[optionsInsideTestMatch],
		TestID -> "3 args: \
TestMatch options inside"
	];
	Test[
		Options[Test],
		optionsOriginalTest,
		TestID -> "3 args: \
Test options are unchanged outside TestCaseEnvironment"
	];
	Test[
		Options[TestMatch],
		optionsOriginalTestMatch,
		TestID -> "3 args: \
TestMatch options are unchanged outside TestCaseEnvironment"
	];
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
