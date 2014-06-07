(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`AddTestDefaultFunction`"];


Needs["EvaluationUtilities`"]; (* TraceLog *)
Needs["PatternUtilities`"]; (* HoldAllSubpatterns *)
Needs["OptionsUtilities`"]; (* DelegateOptions *)


Needs["MUnitExtras`Package`"];


(* Options of internally called functions *)
optsAssignTestFeatures = Options[AssignTestFeatures]


(* Mock functions *)
Remove[mockTestOld]


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*AddTestDefaultFunction with 2 args*)


Module[
	{mockTest, $Log}
	,
	Test[
		TraceLog[
			AddTestDefaultFunction[mockTest, "defaultExpected"],
			_AssignTestFeatures -> $Log
		]
		,
		Null
		,
		TestID -> "2 args: \
AddTestDefaultFunction evaluation: Null returned, no messages are generated"
	];
		
	Test[
		$Log
		,
		HoldForm[AssignTestFeatures[mockTest, Test, opts]] /.
			opts -> optsAssignTestFeatures
		,
		EquivalenceFunction -> MemberQ,
		TestID -> "2 args: \
AssignTestFeatures function was called with proper arguments"
	];

	Test[
		DownValues[mockTest]
		,
		HoldAllSubpatterns[
			HoldPattern @ mockTest[
				input_, Shortest[messages_:{}], testOpts:OptionsPattern[]
			] :>
				With[
					{options = DelegateOptions[testOpts, mockTest, Test]}
					,
					Test[input, "defaultExpected", messages, options]
				]
		]
		,
		EquivalenceFunction -> MemberQ,
		TestID -> "2 args: \
mockTest has definition calling Test with proper arguments"
	];
];


(* ::Subsection:: *)
(*AddTestDefaultFunction with 3 args*)


Module[
	{mockTest, $Log}
	,
	Test[
		TraceLog[
			AddTestDefaultFunction[mockTest, "defaultExpected", mockTestOld],
			_AssignTestFeatures -> $Log
		]
		,
		Null
		,
		TestID -> "3 args: \
AddTestDefaultFunction evaluation: Null returned, no messages are generated"
	];
		
	Test[
		$Log
		,
		HoldForm[AssignTestFeatures[mockTest, mockTestOld, opts]] /.
			opts -> optsAssignTestFeatures
		,
		EquivalenceFunction -> MemberQ,
		TestID -> "3 args: \
AssignTestFeatures function was called with proper arguments"
	];

	Test[
		DownValues[mockTest]
		,
		HoldAllSubpatterns[
			HoldPattern @ mockTest[
				input_, Shortest[messages_:{}], testOpts:OptionsPattern[]
			] :>
				With[
					{
						options =
							DelegateOptions[testOpts, mockTest, mockTestOld]
					}
					,
					mockTestOld[input, "defaultExpected", messages, options]
				]
		]
		,
		EquivalenceFunction -> MemberQ,
		TestID -> "3 args: \
mockTest has definition calling mockTestOld with proper arguments"
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
