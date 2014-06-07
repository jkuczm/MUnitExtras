(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`ThrowTestError`"];


Needs["EvaluationUtilities`"]; (* HoldFunctionsEvaluation *)


Needs["MUnitExtras`Package`"];


PrependTo[$ContextPath, "MUnit`Package`"]


(* ::Section:: *)
(*Tests*)


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		ThrowTestError[]
	]
	,
	HoldComplete @ testError[
		"ThrowTestError called with incorrect arguments: {}."
	]
	,
	TestID -> "no args: \
testError informing about incorrect arguments is returned"
];


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
];


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
];


Test[
	HoldFunctionsEvaluation[
		{testError}
		,
		ThrowTestError["1", "2"]
	]
	,
	HoldComplete @ testError[
		"ThrowTestError called with incorrect arguments: {\"1\", \"2\"}."
	]
	,
	TestID -> "two args: \
testError informing about incorrect arguments is returned"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
