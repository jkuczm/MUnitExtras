(* ::Package:: *)

BeginPackage["MUnitExtras`Package`"]


(* ::Section:: *)
(*Public*)


GetTestingFunctions::usage =
"\
GetTestingFunctions[] \
returns list of all functions that perform tests."


TestQ::usage =
"\
TestQ[symbol] \
returns True if symbol represents a function performing any tests, \
returns False otherwise."


ProtectTestSyntax::usage =
"\
ProtectTestSyntax[symbol] \
sets definition with most general arguments pattern returning test error."


AssignTestFeatures::usage =
"\
AssignTestFeatures[testFunc] \
assigns attributes and options of Test to testFunc, sets \
\"Incorrect arguments\" definition for testFunc (i.e. definition with most \
general arguments pattern throwing test error) and appends testFunc to list \
of testing functions.\

AssignTestFeatures[testFunc, baseTestFunc] \
assigns attributes and options of baseTestFunc to testFunc, sets \
\"Incorrect arguments\" definition for testFunc (i.e. definition with most \
general arguments pattern throwing test error) and appends testFunc to list \
of testing functions.\

AssignTestFeatures[testFunc, {baseTestFunc1, baseTestFunc2, ...}] \
assigns attributes and options of all baseTestFunci to testFunc, sets \
\"Incorrect arguments\" definition for testFunc (i.e. definition with most \
general arguments pattern throwing test error) and appends testFunc to list \
of testing functions."


AddTestDefaultFunction::usage =
"\
AddTestDefaultFunction[testFunc, expected] \
assigns Test features to testFunc and sets definition calling Test with \
expected as tests expected output.\

AddTestDefaultFunction[testFunc, expected, baseTestFunc] \
assigns features of baseTestFunc to testFunc and sets definition calling \
baseTestFunc with expected as tests expected output."


ThrowTestError::usage =
"\
ThrowTestError[errorMessage] \
throws errorMessage tagged with \"internalMUnitTestTag\"."


CatchTestError::usage =
"\
CatchTestError[{testArgs}, expr] \
returns error test result object with given testArgs and message thrown with \
\"internalMUnitTestTag\", if nothing was thrown with \"internalMUnitTestTag\" \
returns result of evaluation of expr."


TestCaseEnvironment::usage =
"\
TestCaseEnvironment[{testCaseOptions}, expr] \
evaluates expr inside test section, with default options of all testing \
functions set to testCaseOptions, after evaluation of expr previous default \
options of test functions are restored.\

TestCaseEnvironment[{testCaseOptions}, {testCaseArgs}, expr] \
catches test erros thrown in expr."


RequiredOptionIsNotSet::usage =
"\
RequiredOptionIsNotSet \
is a setting used for certain options. \
Test functions end with error if any of their required options has this value."


CheckRequiredOptions::usage =
"\
CheckRequiredOptions[func, {opts}, reqOptName] or \
CheckRequiredOptions[func, {opts}, {reqOptName1, reqOptName2, ...}] \
if among given opts or default options for func there are options with names \
among reqOptsNamei and value RequiredOptionIsNotSet proper test error message \
is thrown, otherwise Null is returned."


CheckOptionsValues::usage =
"\
CheckOptionsValues[func, {opts}, optName -> patt] or \
CheckOptionsValues[func, {opts}, {optName1 -> patt1, optName2 -> patt2, ...}] \
if among given opts or default options for func there are options with names \
among optNamei and values not matching corresponding patt1 proper test error \
message is thrown, otherwise Null is returned."


(* Unprotect all public symbols in this package. *)
Unprotect["`*"];


(* ::Section:: *)
(*Private*)


Begin["`Private`"]


(* ::Subsection:: *)
(*Private symbols usage*)


$TestingFunctions::usage =
"\
$TestingFunctions is a list of all functions that perform tests."


(* ::Subsection:: *)
(*Messages*)


General::requiredOptionsNotSet =
"Setting of `1` options is required in `2`."

General::wrongOptionValue =
"Value of option `1` doesn't match pattern `2`."

General::incorrectTestArgs =
"`1` called with incorrect arguments: `2`."

General::argExtractionFailed =
"Extraction of argument at position: `1` from `2` generated messages: `3`."

General::notNumber =
"`1` evaluated to: `2` which is not a number."


(* ::Subsection:: *)
(*Imports*)


Needs["MUnit`"]
(* MUnit`Package` contains symbols used internally by MUnit` *)
PrependTo[$ContextPath, "MUnit`Package`"]


Needs["MUnitExtras`MUnit`"]


Needs["ProtectionUtilities`"] (* ProtectContextNonVariables *)
Needs["OptionsUtilities`"] (* DelegateOptions, DeleteOptionDuplicates,
	SaveOptions, RestoreOptions, CopyFeatures *)
Needs["StringUtilities`"] (* StringJoinBy *)


(* ::Subsection:: *)
(*$TestingFunctions*)


$TestingFunctions = {
	(* MUnit`Test` *)
	Test, TestMatch, TestStringMatch, TestFree, TestStringFree,
	(* MUnit`WRI` *)
	ConditionalTest, ExactTest, ExactTestCaveat, NTest, NTestCaveat, OrTest,
	TestCaveat
}


(* ::Subsection:: *)
(*GetTestingFunctions*)


GetTestingFunctions[] := $TestingFunctions


(* ::Subsection:: *)
(*TestQ*)


TestQ[sym_] := MemberQ[$TestingFunctions, sym]


(* ::Subsection:: *)
(*ProtectTestSyntax*)


ProtectTestSyntax[sym_Symbol] := (
	sym[args___] :=
		testError[
			ToString @ StringForm[
				General::incorrectTestArgs,
				sym,
				MeetLogger`Private`makeString[HoldForm[{args}]]
			]
			,
			(*
				Pass only options, other arguments are not used by testError
				and passing them would evaluate them and we don't want that.
			*)
			Sequence @@ Cases[HoldComplete[args], OptionsPattern[]]
		];
)


(* ::Subsection:: *)
(*AssignTestFeatures*)


Options[AssignTestFeatures] = Options[CopyFeatures]


AssignTestFeatures[
	testFunc_Symbol,
	baseTestFunc_Symbol:Test,
	opts:OptionsPattern[]
] :=
	AssignTestFeatures[testFunc, {baseTestFunc}, opts]

AssignTestFeatures[
	testFunc_Symbol,
	baseTestFuncs:{__Symbol},
	opts:OptionsPattern[]
] := (
	CopyFeatures[
		baseTestFuncs,
		testFunc,
		DelegateOptions[opts, AssignTestFeatures, CopyFeatures]
	];
	
	ProtectTestSyntax[testFunc];
	
	AppendTo[$TestingFunctions, testFunc];
)


(* ::Subsection:: *)
(*AddTestDefaultFunction*)


Options[AddTestDefaultFunction] = Options[AssignTestFeatures]


AddTestDefaultFunction[
	testFunc_Symbol,
	expected_,
	baseTestFunc_Symbol:Test,
	opts:OptionsPattern[]
] := (
	AssignTestFeatures[
		testFunc,
		baseTestFunc,
		DelegateOptions[opts, AddTestDefaultFunction, AssignTestFeatures]
	];
	
	testFunc[input_, Shortest[messages_:{}], testOpts:OptionsPattern[]] :=
		With[
			{options = DelegateOptions[testOpts, testFunc, baseTestFunc]}
			,
			baseTestFunc[input, expected, messages, options]
		];
)


(* ::Subsection:: *)
(*ThrowTestError*)


ThrowTestError[value_] := Throw[ToString[value], "internalMUnitTestTag"]


ProtectTestSyntax[ThrowTestError];


(* ::Subsection:: *)
(*CatchTestError*)


SetAttributes[CatchTestError, HoldAll]


CatchTestError[{testArgs___}, expr_] :=
	Catch[
		expr,
		"internalMUnitTestTag",
		Function[{value, tag}, testError[value, testArgs]]
	]


ProtectTestSyntax[CatchTestError];


(* ::Subsection:: *)
(*TestCaseEnvironment*)


SetAttributes[TestCaseEnvironment, HoldRest]


Options[TestCaseEnvironment] =
	Join[
		{
			"CommonOptionsFor" :> $TestingFunctions,
			"Separator" -> ": "
		}
		,
		Options[Test, {TestFailureMessage, TestFailureMessageGenerator}]
	]


TestCaseEnvironment[
	testCaseOptions:{___?OptionQ},
	expr_,
	opts:OptionsPattern[]
] :=
	Module[
		{
			id = SaveOptions[OptionValue["CommonOptionsFor"]]
			,
			testCaseOptionsFilteredForEnv =
				FilterRules[testCaseOptions, Options[TestCaseEnvironment]]
			,
			testCaseOptionsUnique,
			testSectionName,
			result
		}
		,
		testCaseOptionsUnique =
			DeleteOptionDuplicates[
				(*
					By default generate failure messages in form:
					`test case level message`: `test level message`
				*)
				With[
					{
						testFailureMessage =
							OptionValue[
								TestCaseEnvironment,
								testCaseOptionsFilteredForEnv,
								TestFailureMessage
							]
						,
						testFailureMessageGenerator =
							OptionValue[
								TestCaseEnvironment,
								testCaseOptionsFilteredForEnv,
								TestFailureMessageGenerator
							]
						,
						stringJoinByOptions =
							DelegateOptions[
								opts, TestCaseEnvironment, StringJoinBy
							]
					}
					,
					TestFailureMessageGenerator ->
						(StringJoinBy[
							testFailureMessage,
							testFailureMessageGenerator[#],
							stringJoinByOptions
						]&)
				]
				,
				testCaseOptions
			];
		
		SetOptions[#, FilterRules[testCaseOptionsUnique, Options[#]]]& /@
			DeleteDuplicates[OptionValue["CommonOptionsFor"]];
		
		testSectionName =
			If[MemberQ[testCaseOptionsUnique, (Rule|RuleDelayed)[TestID, _]],
				TestID /. testCaseOptionsUnique
			(* else *),
				Unique["TestCase$"]
			];
		
		BeginTestSection[testSectionName];
		
		result =
			CatchTestError[
				testCaseOptions
				,
				expr
			];
		
		EndTestSection[];
		
		RestoreOptions[id];
		
		result
	]


ProtectTestSyntax[TestCaseEnvironment];


(* ::Subsection:: *)
(*CheckRequiredOptions*)


CheckRequiredOptions[
	func_Symbol,
	opts:{___?OptionQ},
	reqOptNames:({(_Symbol | _String)..} | _Symbol | _String)
] :=
	With[
		{
			pos =
				Position[
					OptionValue[func, opts, Flatten[{reqOptNames}]],
					RequiredOptionIsNotSet
				]
		}
		,
		If[pos =!= {},
			ThrowTestError @ StringForm[
				General::requiredOptionsNotSet,
				Extract[Flatten[{reqOptNames}], pos],
				func
			]
		];
	]


(* ::Subsection:: *)
(*CheckOptionsValues*)


CheckOptionsValues[
	func_Symbol,
	opts:{___?OptionQ},
	optPatterns_?OptionQ
] :=
	With[
		{
			nonMatching =
				Last @ Reap[
					With[
						{optValue = OptionValue[func, opts, #1]}
						,
						If[!MatchQ[optValue, #2],
							Sow @ ToString @ StringForm[
								General::wrongOptionValue,
								#1 -> optValue,
								#2
							];
						];
					]& @@@
						Flatten[{optPatterns}];
				]
		}
		,
		If[nonMatching =!= {},
			ThrowTestError[
				StringJoinBy[First[nonMatching]] <> " In " <> ToString[func]
			]
		];
	]


End[]


(* ::Section:: *)
(*Public symbols protection*)


ProtectContextNonVariables[];


EndPackage[]
