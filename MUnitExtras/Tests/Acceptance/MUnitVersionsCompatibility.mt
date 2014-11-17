(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Acceptance`MUnitVersionsCompatibility`"]


Needs["MUnitExtras`MUnit`"]
Needs["OptionsUtilities`"] (* SaveOptions, RestoreOptions *)


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*Test*)


(* ::Subsubsection:: *)
(*Explicit option*)


Test[
	2.
	,
	2
	,
	TestID -> "Test: explicit option: SameTest"
	,
	SameTest -> Equal
]


Test[
	2.
	,
	2
	,
	TestID -> "Test: explicit option: EquivalenceFunction"
	,
	EquivalenceFunction -> Equal
]


(* ::Subsubsection:: *)
(*SetOptions*)


SaveOptions[Test]

SetOptions[Test, SameTest -> Equal]

Test[
	2.
	,
	2
	,
	TestID -> "Test: SetOptions: SameTest"
]

RestoreOptions[]


SaveOptions[Test]

SetOptions[Test, EquivalenceFunction -> Equal]

Test[
	2.
	,
	2
	,
	TestID -> "Test: SetOptions: EquivalenceFunction"
]

RestoreOptions[]


(* ::Subsection:: *)
(*TestStringFree*)


(* ::Subsubsection:: *)
(*Explicit option*)


TestStringFree[
	2.
	,
	2
	,
	TestID -> "TestStringFree: explicit option: SameTest"
	,
	SameTest -> Equal
]


TestStringFree[
	2.
	,
	2
	,
	TestID -> "TestStringFree: explicit option: EquivalenceFunction"
	,
	EquivalenceFunction -> Equal
]


(* ::Subsubsection:: *)
(*SetOptions*)


SaveOptions[TestStringFree]

SetOptions[TestStringFree, SameTest -> Equal]

TestStringFree[
	2.
	,
	2
	,
	TestID -> "TestStringFree: SetOptions: SameTest"
]

RestoreOptions[]


SaveOptions[TestStringFree]

SetOptions[TestStringFree, EquivalenceFunction -> Equal]

TestStringFree[
	2.
	,
	2
	,
	TestID -> "TestStringFree: SetOptions: EquivalenceFunction"
]

RestoreOptions[]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
