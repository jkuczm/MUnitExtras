(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`CatchTestError`"]


Needs["EvaluationUtilities`"] (* HoldFunctionsEvaluation *)


Needs["MUnitExtras`Package`"]


PrependTo[$ContextPath, "MUnit`Package`"]


(* ::Section:: *)
(*Tests*)


Module[
	{result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = CatchTestError[]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "no args: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"CatchTestError called with incorrect arguments: {}."
		,
		TestID -> "no args: testError message"
	];
]


Module[
	{result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = CatchTestError["arg"]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "1 arg: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"CatchTestError called with incorrect arguments: {\"arg\"}."
		,
		TestID -> "1 arg: testError message"
	];
]


Module[
	{result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = CatchTestError["arg1", "arg2"]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "2 args: first non-list: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"CatchTestError called with incorrect arguments: {\"arg1\", \"arg2\"}."
		,
		TestID -> "2 args: first non-list: testError message"
	];
]


Test[
	CatchTestError[{"arg1"}, "arg2"]
	,
	"arg2"
	,
	TestID -> "2 args: first list, no throws: \
second argument is returned"
]


Test[
	Catch[
		CatchTestError[{"arg1"}, Throw["some value", "some tag"]],
		_,
		Function[
			{value, tag}
			,
			"value: " <> ToString[value] <>
				", with tag: " <> ToString[tag] <> ", was not caught"
		]
	]
	,
	"value: some value, with tag: some tag, was not caught"
	,
	TestID -> "2 args: first list, value with arbitrary tag thrown: \
value is not caught"
]


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		CatchTestError[
			{"arg1"},
			Throw["error message", "internalMUnitTestTag"]
		]
	]
	,
	HoldComplete @ testError["error message", "arg1"]
	,
	TestID -> "2 args: first list, \
value with \"internalMUnitTestTag\" thrown: \
value is caught and testError with value as error message is returned"
]


Module[
	{result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = CatchTestError[{"arg1"}, "arg2", "arg3"]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "3 args: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"CatchTestError called with incorrect arguments: \
{{\"arg1\"}, \"arg2\", \"arg3\"}."
		,
		TestID -> "3 args: testError message"
	];
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
