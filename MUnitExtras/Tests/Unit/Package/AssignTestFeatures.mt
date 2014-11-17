(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`AssignTestFeatures`"];


Needs["EvaluationUtilities`"]; (* TraceLog *)
Needs["OptionsUtilities`"]; (* DeleteOptionDuplicates, CopyFeatures *)


Needs["MUnitExtras`Package`"];


optsCopyFeatures = Options[CopyFeatures]


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*AssignTestFeatures with 1 symbol*)


Module[
	{mockTest, $Log}
	,
	Block[
		{MUnitExtras`Package`Private`$TestingFunctions = {mockTestOld1}}
		,
		Test[
			TraceLog[
				AssignTestFeatures[mockTest],
				_CopyFeatures | _ProtectTestSyntax -> $Log
			]
			,
			Null
			,
			TestID -> "1 symbol: \
AssignTestFeatures evaluation: Null returned, no messages are generated"
		];
		
		Test[
			MUnitExtras`Package`Private`$TestingFunctions,
			{mockTestOld1 , mockTest},
			TestID -> "1 symbol: \
$TestingFunctions list have appended mockTest"
		];
		
		Test[
			$Log
			,
			HoldForm[CopyFeatures[{Test}, mockTest, opts]] /.
				opts -> optsCopyFeatures
			,
			SameTest -> MemberQ,
			TestID -> "1 symbol: \
CopyFeatures function was called with proper arguments"
		];
		Test[
			$Log,
			HoldForm[ProtectTestSyntax[mockTest]],
			SameTest -> MemberQ,
			TestID -> "1 symbol: \
ProtectTestSyntax function was called with proper arguments"
		];
	];
];


(* ::Subsection:: *)
(*AssignTestFeatures with 2 symbols*)


Module[
	{mockTest, $Log}
	,
	Block[
		{MUnitExtras`Package`Private`$TestingFunctions = {mockTestOld1}}
		,
		Test[
			TraceLog[
				AssignTestFeatures[mockTest, mockTestOld2],
				_CopyFeatures | _ProtectTestSyntax -> $Log
			]
			,
			Null
			,
			TestID -> "2 symbols: \
AssignTestFeatures evaluation: Null returned, no messages are generated"
		];
		
		Test[
			MUnitExtras`Package`Private`$TestingFunctions,
			{mockTestOld1 , mockTest},
			TestID -> "2 symbols: \
$TestingFunctions list have appended mockTest"
		];
		
		Test[
			$Log
			,
			HoldForm[CopyFeatures[{mockTestOld2}, mockTest, opts]] /.
				opts -> optsCopyFeatures
			,
			SameTest -> MemberQ,
			TestID -> "2 symbols: \
CopyFeatures function was called with proper arguments"
		];
		Test[
			$Log,
			HoldForm[ProtectTestSyntax[mockTest]],
			SameTest -> MemberQ,
			TestID -> "2 symbols: \
ProtectTestSyntax function was called with proper arguments"
		];
	];
];


(* ::Subsection:: *)
(*AssignTestFeatures with 1 symbol, list of 2 symbols*)


Module[
	{mockTest, $Log}
	,
	Block[
		{MUnitExtras`Package`Private`$TestingFunctions = {mockTestOld1}}
		,
		Test[
			TraceLog[
				AssignTestFeatures[mockTest, {mockTestOld1, mockTestOld2}],
				_CopyFeatures | _ProtectTestSyntax -> $Log
			]
			,
			Null
			,
			TestID -> "1 symbol, list of 2 symbols: \
AssignTestFeatures evaluation: Null returned, no messages are generated"
		];
		
		Test[
			MUnitExtras`Package`Private`$TestingFunctions,
			{mockTestOld1 , mockTest},
			TestID -> "1 symbol, list of 2 symbols: \
$TestingFunctions list have appended mockTest"
		];
		
		Test[
			$Log
			,
			HoldForm @ CopyFeatures[
				{mockTestOld1, mockTestOld2}, mockTest, opts
			] /. opts -> optsCopyFeatures
			,
			SameTest -> MemberQ,
			TestID -> "1 symbol, list of 2 symbols: \
CopyFeatures function was called with proper arguments"
		];
		Test[
			$Log,
			HoldForm[ProtectTestSyntax[mockTest]],
			SameTest -> MemberQ,
			TestID -> "1 symbol, list of 2 symbols: \
ProtectTestSyntax function was called with proper arguments"
		];
	];
];


(* ::Subsection:: *)
(*AssignTestFeatures with 1 symbol and options*)


Module[
	{mockTest, $Log}
	,
	Block[
		{MUnitExtras`Package`Private`$TestingFunctions = {mockTestOld1}}
		,
		Test[
			TraceLog[
				AssignTestFeatures[
					mockTest,
					"ExcludeOptions" -> {"optName"},
					"ExcludeAttributes" -> {"attrName"},
					"DeleteOptionDuplicates" -> "TorF"
				]
				,
				_CopyFeatures | _ProtectTestSyntax -> $Log
			]
			,
			Null
			,
			TestID -> "1 symbol and options: \
AssignTestFeatures evaluation: Null returned, no messages are generated"
		];
		
		Test[
			MUnitExtras`Package`Private`$TestingFunctions,
			{mockTestOld1 , mockTest},
			TestID -> "1 symbol and options: \
$TestingFunctions list have appended mockTest"
		];
		
		Test[
			$Log
			,
			HoldForm @ CopyFeatures[
				{Test},
				mockTest,
				{
					"ExcludeOptions" -> {"optName"},
					"ExcludeAttributes" -> {"attrName"},
					"DeleteOptionDuplicates" -> "TorF"
				}
			]
			,
			SameTest -> MemberQ,
			TestID -> "1 symbol and options: \
CopyFeatures function was called with proper arguments"
		];
		Test[
			$Log,
			HoldForm[ProtectTestSyntax[mockTest]],
			SameTest -> MemberQ,
			TestID -> "1 symbol and options: \
ProtectTestSyntax function was called with proper arguments"
		];
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
