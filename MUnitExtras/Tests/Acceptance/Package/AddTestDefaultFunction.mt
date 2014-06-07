(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`Package`AddTestDefaultFunction`"];


Needs["MUnitExtras`Package`"];


(* Mock functions *)
SetAttributes[mockTestOld, HoldFirst]
Options[mockTestOld] = {"mockTestOldOption" -> "mockTestOldOptionValue"}


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*AddTestDefaultFunction with 2 args*)


Module[
	{mockTest}
	,
	AddTestDefaultFunction[mockTest, "defaultExpected"];
	
	Test[
		TestQ[mockTest],
		True,
		TestID -> "2 args: \
mockTest is recognized as testing function"
	];


	Test[
		Attributes[mockTest],
		Attributes[Test],
		TestID -> "2 args: \
mockTest attributes same as Test attributes"
	];
	Test[
		Options[mockTest],
		Options[Test],
		TestID -> "2 args: \
mockTest options same as Test options"
	];
	
	
	Module[
		{tr}
		,
		TestStringMatch[
			Block[
				{MUnit`Package`logTestResult}
				,
				SymbolName[tr = mockTest["defaultExpected"]]
			]
			,
			"TestResultObject*"
			,
			TestID -> "2 args: \
mockTest evaluation (Success)"
		];
		Test[
			FailureMode[tr],
			"Success",
			TestID -> "2 args: \
TestResultObject (Success): FailureMode"
		];
	];
	
	
	Module[
		{tr}
		,
		TestStringMatch[
			Block[
				{MUnit`Package`logTestResult}
				,
				SymbolName[tr = mockTest["notExpected"]]
			]
			,
			"TestResultObject*"
			,
			TestID -> "2 args: \
mockTest evaluation (Failure)"
		];
		Test[
			FailureMode[tr],
			"Failure",
			TestID -> "2 args: \
TestResultObject (Failure): FailureMode"
		];
	];
	
	
	Module[
		{tr}
		,
		TestStringMatch[
			Block[
				{MUnit`Package`logTestResult}
				,
				SymbolName[tr = mockTest[1, 2, 3]]
			]
			,
			"TestResultObject*"
			,
			TestID -> "2 args: \
mockTest evaluation (incorrect args)"
		];
		Test[
			FailureMode[tr],
			"Error",
			TestID -> "2 args: \
TestResultObject (incorrect args): FailureMode"
		];
		Test[
			ErrorMessage[tr]
			,
			SymbolName[mockTest] <>
				" called with incorrect arguments: {1, 2, 3}."
			,
			TestID -> "2 args: \
TestResultObject (incorrect args): ErrorMessagees"
		];
	];
];


(* ::Subsection:: *)
(*AddTestDefaultFunction with 3 args*)


Module[
	{mockTest}
	,
	AddTestDefaultFunction[mockTest, "defaultExpected", mockTestOld];
	
	Test[
		TestQ[mockTest],
		True,
		TestID -> "3 args: \
mockTest is recognized as testing function"
	];


	Test[
		Attributes[mockTest],
		{HoldFirst},
		TestID -> "3 args: \
mockTest attributes same as mockTestOld attributes"
	];
	Test[
		Options[mockTest],
		{"mockTestOldOption" -> "mockTestOldOptionValue"},
		TestID -> "3 args: \
mockTest options same as mockTestOld options"
	];
	
	
	TestMatch[
		mockTest["mockTestArg"]
		,
		HoldPattern @ mockTestOld[
			"mockTestArg",
			"defaultExpected",
			{},
			{"mockTestOldOption" -> "mockTestOldOptionValue"}
		]
		,
		TestID -> "3 args: \
mockTest evaluation (correct args)"
	];
	
	
	Module[
		{tr}
		,
		TestStringMatch[
			Block[
				{MUnit`Package`logTestResult}
				,
				SymbolName[tr = mockTest[1, 2, 3]]
			]
			,
			"TestResultObject*"
			,
			TestID -> "3 args: \
mockTest evaluation (incorrect args)"
		];
		Test[
			FailureMode[tr],
			"Error",
			TestID -> "3 args: \
TestResultObject (incorrect args): FailureMode"
		];
		Test[
			ErrorMessage[tr]
			,
			SymbolName[mockTest] <>
				" called with incorrect arguments: {1, 2, 3}."
			,
			TestID -> "3 args: \
TestResultObject (incorrect args): ErrorMessagees"
		];
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
