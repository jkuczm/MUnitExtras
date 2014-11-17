(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`Package`AssignTestFeatures`"];


Needs["MUnitExtras`Package`"];


(* Mock functions *)
SetAttributes[mockTestOld1, HoldFirst]
Options[mockTestOld1] = {"mockTestOld1Option" -> "mockTestOld1OptionValue"}

SetAttributes[mockTestOld2, HoldRest]
Options[mockTestOld2] = {"mockTestOld2Option" -> "mockTestOld2OptionValue"}


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*AssignTestFeatures with 1 symbol*)


Module[
	{mockTest, tr}
	,
	AssignTestFeatures[mockTest];
	
	Test[
		TestQ[mockTest],
		True,
		TestID -> "1 symbol: \
mockTest is recognized as testing function"
	];


	Test[
		Attributes[mockTest],
		Attributes[Test],
		TestID -> "1 symbol: \
mockTest attributes same as Test attributes"
	];
	Test[
		Options[mockTest],
		Options[Test],
		TestID -> "1 symbol: \
mockTest options same as Test options"
	];
	
	
	Test[
		Block[
			{
				MUnit`Package`logTestResult,
				MUnit`Package`$TestIndex = 0,
				MUnit`Package`$dynamicTestIndex = 0
			}
			,
			TestResultQ[tr = mockTest["arg1", "arg2"]]
		]
		,
		True
		,
		TestID -> "1 symbol: \
mockTest evaluation"
	];
	
	Test[
		FailureMode[tr],
		"Error",
		TestID -> "1 symbol: \
TestResultObject: FailureMode"
	];
	Test[
		ErrorMessage[tr]
		,
		SymbolName[mockTest] <>
			" called with incorrect arguments: {\"arg1\", \"arg2\"}."
		,
		TestID -> "1 symbol: \
TestResultObject: ErrorMessagees"
	];
];


(* ::Subsection:: *)
(*AssignTestFeatures with 2 symbols*)


Module[
	{mockTest, tr}
	,
	AssignTestFeatures[mockTest, mockTestOld2];
	
	Test[
		TestQ[mockTest],
		True,
		TestID -> "2 symbols: \
mockTest is recognized as testing function"
	];


	Test[
		Attributes[mockTest],
		{HoldRest},
		TestID -> "2 symbols: \
mockTest attributes same as mockTestOld2 attributes"
	];
	Test[
		Options[mockTest],
		{"mockTestOld2Option" -> "mockTestOld2OptionValue"},
		TestID -> "2 symbols: \
mockTest options same as mockTestOld2 options"
	];
	
	
	Test[
		Block[
			{
				MUnit`Package`logTestResult,
				MUnit`Package`$TestIndex = 0,
				MUnit`Package`$dynamicTestIndex = 0
			}
			,
			TestResultQ[tr = mockTest["arg1", "arg2"]]
		]
		,
		True
		,
		TestID -> "2 symbols: \
mockTest evaluation"
	];
	
	Test[
		FailureMode[tr],
		"Error",
		TestID -> "2 symbols: \
TestResultObject: FailureMode"
	];
	Test[
		ErrorMessage[tr]
		,
		SymbolName[mockTest] <>
			" called with incorrect arguments: {\"arg1\", \"arg2\"}."
		,
		TestID -> "2 symbols: \
TestResultObject: ErrorMessagees"
	];
];


(* ::Subsection:: *)
(*AssignTestFeatures with 1 symbol, list of 2 symbols*)


Module[
	{mockTest, tr}
	,
	AssignTestFeatures[mockTest, {mockTestOld1, mockTestOld2}];
	
	Test[
		TestQ[mockTest],
		True,
		TestID -> "1 symbol, list of 2 symbols: \
mockTest is recognized as testing function"
	];


	Test[
		Attributes[mockTest],
		{HoldAll},
		TestID -> "1 symbol, list of 2 symbols: \
mockTest attributes same as mockTestOld1 and mockTestOld2 attributes"
	];
	Test[
		Options[mockTest]
		,
		{
			"mockTestOld1Option" -> "mockTestOld1OptionValue",
			"mockTestOld2Option" -> "mockTestOld2OptionValue"
		}
		,
		TestID -> "1 symbol, list of 2 symbols: \
mockTest options same as mockTestOld1 and mockTestOld2 options"
	];
	
	
	Test[
		Block[
			{
				MUnit`Package`logTestResult,
				MUnit`Package`$TestIndex = 0,
				MUnit`Package`$dynamicTestIndex = 0
			}
			,
			TestResultQ[tr = mockTest["arg1", "arg2"]]
		]
		,
		True
		,
		TestID -> "1 symbol, list of 2 symbols: \
mockTest evaluation"
	];
	
	Test[
		FailureMode[tr],
		"Error",
		TestID -> "1 symbol, list of 2 symbols: \
TestResultObject: FailureMode"
	];
	Test[
		ErrorMessage[tr]
		,
		SymbolName[mockTest] <>
			" called with incorrect arguments: {\"arg1\", \"arg2\"}."
		,
		TestID -> "1 symbol, list of 2 symbols: \
TestResultObject: ErrorMessagees"
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
