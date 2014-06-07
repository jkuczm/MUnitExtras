(* ::Package:: *)

BeginPackage["MUnitExtras`MeetLogger`"]


(* ::Section:: *)
(*Private*)


Begin["`Private`"]


(* ::Subsection:: *)
(*Imports*)


Needs["MeetLogger`"]

Needs["MUnit`"]
Needs["JLink`"]


Needs["MUnitExtras`MUnit`"]
	

(* ::Section:: *)
(*MeetLogger`Private` modifications*)


(*
	Code changed in MeetLogger`Private` context is marked with
	BEGIN/END CHANGED CODE
*)
Begin["MeetLogger`Private`"]


BuildTestFailure[tr_?TestResultQ] :=
	Module[{expected, actual},
		UseJVM[MEET`$WorkbenchJavaVM,
			expected = makeString[ExpectedOutput[tr]];
			actual = makeString[ActualOutput[tr]];
			JavaNew[
				"com.wolfram.eclipse.testing.results.TestFailure",
				Null,
				ToString[TestID[tr]],
				expected,
				actual,
(* BEGIN CHANGED CODE *)
				ToString[TestFailureMessageGenerator[tr][tr]]
(* END CHANGED CODE *)
			]
		]
	]


BuildTestMessageFailure[tr_?TestResultQ] :=
	Module[{expectedMessages,actualMessages},
		UseJVM[MEET`$WorkbenchJavaVM,
			expectedMessages = ToString[ExpectedMessages[tr]];
			actualMessages = ToString[ActualMessages[tr]];
			JavaNew[
				"com.wolfram.eclipse.testing.results.MessageFailure",
				Null,
				ToString[TestID[tr]],
				expectedMessages,
				actualMessages,
(* BEGIN CHANGED CODE *)
				ToString[TestFailureMessageGenerator[tr][tr]]
(* END CHANGED CODE *)
			]
		]
	]


End[]


End[]


EndPackage[]
