(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`GetTestingFunctions`"];


Needs["MUnitExtras`Package`"];

(* Mock functions *)
Remove[nonTest, someTest1, someTest2];


(* ::Section:: *)
(*Tests*)


Block[
	{MUnitExtras`Package`Private`$TestingFunctions = {someTest1, someTest2}}
	,
	
	Test[
		GetTestingFunctions[]
		,
		{someTest1, someTest2}
		,
		TestID -> "no args"
	];
];

TestMatch[
	GetTestingFunctions["arg"]
	,
	HoldPattern[GetTestingFunctions["arg"]]
	,
	TestID -> "1 arg"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
