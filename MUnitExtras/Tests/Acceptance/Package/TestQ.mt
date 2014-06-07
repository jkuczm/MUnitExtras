(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`Package`TestQ`"];


Needs["MUnitExtras`"];
Needs["MUnitExtras`Package`"];


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*MUnit`Test` tests*)


Test[
	TestQ[Test]
	,
	True
	,
	TestID -> "Test"
];
Test[
	TestQ[TestMatch]
	,
	True
	,
	TestID -> "TestMatch"
];
Test[
	TestQ[TestStringMatch]
	,
	True
	,
	TestID -> "TestStringMatch"
];
Test[
	TestQ[TestFree]
	,
	True
	,
	TestID -> "TestFree"
];
Test[
	TestQ[TestStringFree]
	,
	True
	,
	TestID -> "TestStringFree"
];


(* ::Subsection:: *)
(*MUnit`WRI` tests*)


Test[
	TestQ[ConditionalTest]
	,
	True
	,
	TestID -> "ConditionalTest"
];
Test[
	TestQ[ExactTest]
	,
	True
	,
	TestID -> "ExactTest"
];
Test[
	TestQ[ExactTestCaveat]
	,
	True
	,
	TestID -> "ExactTestCaveat"
];
Test[
	TestQ[NTest]
	,
	True
	,
	TestID -> "NTest"
];
Test[
	TestQ[NTestCaveat]
	,
	True
	,
	TestID -> "NTestCaveat"
];
Test[
	TestQ[OrTest]
	,
	True
	,
	TestID -> "OrTest"
];
Test[
	TestQ[TestCaveat]
	,
	True
	,
	TestID -> "TestCaveat"
];


(* ::Subsection:: *)
(*MUnitExtras`Tests` tests*)


Test[
	TestQ[TestN]
	,
	True
	,
	TestID -> "TestN"
];
Test[
	TestQ[TestDefault]
	,
	True
	,
	TestID -> "TestDefault"
];
Test[
	TestQ[TestNull]
	,
	True
	,
	TestID -> "TestNull"
];
Test[
	TestQ[TestFailed]
	,
	True
	,
	TestID -> "TestFailed"
];
Test[
	TestQ[TestZero]
	,
	True
	,
	TestID -> "TestZero"
];
Test[
	TestQ[TestNonZero]
	,
	True
	,
	TestID -> "TestNonZero"
];
Test[
	TestQ[TestUnchanged]
	,
	True
	,
	TestID -> "TestUnchanged"
];
Test[
	TestQ[TestUnchangedHead]
	,
	True
	,
	TestID -> "TestUnchangedHead"
];
Test[
	TestQ[TestSubexpression]
	,
	True
	,
	TestID -> "TestSubexpression"
];


(* ::Subsection:: *)
(*MUnitExtras`TestCases` test cases*)


Test[
	TestQ[TestCaseSparse]
	,
	True
	,
	TestID -> "TestCaseSparse"
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"];
Quiet[Remove["`*"], {Remove::rmnsm}];


End[];
