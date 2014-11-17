(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`ThrowTestError`"]


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
			result = ThrowTestError[]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "no args: testError is returned"
	];
	
	Test[
		result[[1, 1]]
		,
		"ThrowTestError called with incorrect arguments: {}."
		,
		TestID -> "no args: testError message"
	];
]


Test[
	Catch[
		ThrowTestError["some error message"],
		"internalMUnitTestTag"
	]
	,
	"some error message"
	,
	TestID -> "1 string arg: \
given arg is thrown with proper tag"
]


Test[
	Catch[
		ThrowTestError[5],
		"internalMUnitTestTag"
	]
	,
	"5"
	,
	TestID -> "1 non-string arg: \
given arg is converted to string and thrown with proper tag"
]


Module[
	{result}
	,
	TestMatch[
		HoldFunctionsEvaluation[
			{testError}
			,
			result = ThrowTestError["1", "2"]
		]
		,
		HoldComplete[_testError]
		,
		TestID -> "two args: testError is returned"
	];
	
	TestMatch[
		result[[1, 1]]
		,
		"ThrowTestError called with incorrect arguments: {\"1\", \"2\"}."
		,
		TestID -> "two args: testError message"
	];
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
