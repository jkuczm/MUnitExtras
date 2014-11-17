(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`Package`MakeString`"]


Needs["MUnitExtras`Package`"]


(* ::Section:: *)
(*Tests*)


Test[
	MakeString[someHead1[arg1, arg2]]
	,
	"someHead1[arg1, arg2]"
	,
	TestID -> "arbitrary expression"
]


Test[
	MakeString[HoldForm[someHead2[arg3, arg4, arg5]]]
	,
	"someHead2[arg3, arg4, arg5]"
	,
	TestID -> "arbitrary expression"
]


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context. *)
Unprotect["`*"]
Quiet[Remove["`*"], {Remove::rmnsm}]


End[]
