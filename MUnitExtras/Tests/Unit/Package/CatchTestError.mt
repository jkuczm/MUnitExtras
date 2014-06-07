(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`CatchTestError`"];


Needs["EvaluationUtilities`"]; (* HoldFunctionsEvaluation *)


Needs["MUnitExtras`Package`"];


PrependTo[$ContextPath, "MUnit`Package`"]


(* ::Section:: *)
(*Tests*)


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		CatchTestError[]
	]
	,
	HoldComplete @ testError[
		"CatchTestError called with incorrect arguments: {}."
	]
	,
	TestID -> "no args: \
testError informing about incorrect arguments is returned"
];


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		CatchTestError["arg"]
	]
	,
	HoldComplete @ testError[
		"CatchTestError called with incorrect arguments: {\"arg\"}."
	]
	,
	TestID -> "1 arg: \
testError informing about incorrect arguments is returned"
];


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		CatchTestError["arg1", "arg2"]
	]
	,
	HoldComplete @ testError[
		"CatchTestError called with incorrect arguments: {\"arg1\", \"arg2\"}."
	]
	,
	TestID -> "2 args: first non-list: \
testError informing about incorrect arguments is returned"
];


Test[
	CatchTestError[{"arg1"}, "arg2"]
	,
	"arg2"
	,
	TestID -> "2 args: first list, no throws: \
second argument is returned"
];


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
];


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
];


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		CatchTestError[{"arg1"}, "arg2", "arg3"]
	]
	,
	HoldComplete @ testError[
		"CatchTestError called with incorrect arguments: \
{{\"arg1\"}, \"arg2\", \"arg3\"}."
	]
	,
	TestID -> "3 args: \
testError informing about incorrect arguments is returned"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
