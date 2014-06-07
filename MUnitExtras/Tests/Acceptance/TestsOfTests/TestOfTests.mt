(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`TestsOfTests`TestOfTests`"];


Needs["MUnitExtras`Package`"];
Needs["MUnitExtras`TestsOfTests`"];


Needs["OptionsUtilities`"]; (* DelegateOptions *)


AssignTestFeatures[mockTest];

mockTest[opts:OptionsPattern[]] :=
	With[
		{options = DelegateOptions[opts, mockTest, Test]}
		,
		Test[False, True, options]
	]


(* ::Section:: *)
(*Tests*)


Block[
	{$TestsOfTestsLog = {}}
	,
	
	TestOfTests[
		tr = mockTest[TestID -> "mockTestID"],
		TestID -> "mockTest evaluation"
	];

	Test[
		Length[$TestsOfTestsLog],
		1,
		TestID -> "one test result was logged"
	];
	
	Test[
		Last[$TestsOfTestsLog],
		tr,
		TestID -> "logged test result is same as returned one"
	];
	
	Test[
		TestID[tr],
		"mockTestID",
		TestID ->
			"test result has TestID of test performed inside TestOfTests"
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
