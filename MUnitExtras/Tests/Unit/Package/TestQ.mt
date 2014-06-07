(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`TestQ`"];


Needs["MUnitExtras`Package`"];

(* Mock functions *)
Remove[nonTest, someTest1, someTest2];


(* ::Section:: *)
(*Tests*)


Block[
	{MUnitExtras`Package`Private`$TestingFunctions = {someTest1, someTest2}}
	,
	
	Test[
		TestQ[someTest1]
		,
		True
		,
		TestID -> "Function in $TestingFunctions"
	];
	Test[
		TestQ[nonTest]
		,
		False
		,
		TestID -> "Function not in $TestingFunctions"
	];
	Test[
		TestQ["not a symbol"]
		,
		False
		,
		TestID -> "Not a symbol given"
	];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
