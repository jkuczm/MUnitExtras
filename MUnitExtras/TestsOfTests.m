(* ::Package:: *)

BeginPackage["MUnitExtras`TestsOfTests`"]


(* ::Section:: *)
(*Public*)


$TestsOfTestsLog::usage =
"\
$TestsOfTestsLog is a list of test results logged by \
MUnitExtras`TestsOfTests`LogTestResult."


TestsOfTestsEnvironment::usage =
"\
TestsOfTestsEnvironment[expr] \
evaluates expr in Block in which test results are logged to $TestsOfTestsLog \
instead of standard log."


TestOfTests::usage =
"\
TestOfTests[input] \
tests whether input evaluates to TestResult and no messages are generated. \
Evaluation of input is performed inside Block with localized \
MUnit`Package`logTestResult variable, so that no results of tests performed \
inside input are logged.\

TestOfTests[input, messages] \
tests whether input evaluates to TestResult and the given messages are \
generated. Evaluation of input is performed inside Block with localized \
MUnit`Package`logTestResult variable, so that no results of tests performed \
inside input are logged."


TestCaseOfTestResult::usage =
"\
TestCaseOfTestResult[tr, {sel1 -> val1, sel2 -> val1, ...}] \
tests whether tr is a TestResult object. \
Then tests that all selectors of tr have default values, except given seli \
which are tested against coresponding vali."


TestCaseOfErrorTestResult::usage =
"\
TestCaseOfErrorTestResult[tr, {sel1 -> val1, sel2 -> val1, ...}] \
tests whether tr is a TestResult object. \
Then tests that all selectors of tr have default values for error test result,
except given seli which are tested against coresponding vali."


TestCaseOfTest::usage =
"\
TestCaseOfTest[input, {sel1 -> val1, sel2 -> val1, ...}] \
tests whether input evaluates to TestResult and no messages are generated. \
Then tests that all selectors of obtained test result have default values, \
except given seli which are tested against coresponding vali. \
input is evaluated in such way that no results of tests performed inside \
input are logged to standard test result logs. \

TestCaseOfTest[input, {sel1 -> val1, sel2 -> val1, ...}, messages] \
assumes that evaluation of input generates given messages."


TestCaseOfTestError::usage =
"\
TestCaseOfTestError[input, {sel1 -> val1, sel2 -> val1, ...}] \
tests whether input evaluates to TestResult and no messages are generated. \
Then tests that all selectors of obtained test result have default values for \
error test result, except given seli which are tested against coresponding \
vali. input is evaluated in such way that no results of tests performed \
inside input are logged to standard test result logs. \

TestCaseOfTestError[input, {sel1 -> val1, sel2 -> val1, ...}, messages] \
assumes that evaluation of input generates given messages."


(* Unprotect all public symbols in this package. *)
Unprotect["`*"];


(* ::Section:: *)
(*Private*)


Begin["`Private`"]


(* ::Subsection:: *)
(*Imports*)


Needs["MUnit`"]
Needs["MUnitExtras`Package`"]
Needs["MUnitExtras`MUnit`"]


Needs["ProtectionUtilities`"] (* ProtectContextNonVariables *)
Needs["OptionsUtilities`"] (* PrependToOptions, DelegateOptions *)


(* ::Subsection:: *)
(*$TestResultLog*)


$TestsOfTestsLog = {};


(* ::Subsection:: *)
(*TestsOfTestsEnvironment*)


SetAttributes[TestsOfTestsEnvironment, HoldAll]

TestsOfTestsEnvironment[expr_] :=
	Block[
		{MUnit`Package`logTestResult = AppendTo[$TestsOfTestsLog, #]&}
		,
		expr
	]

ProtectTestSyntax[TestsOfTestsEnvironment]


(* ::Subsection:: *)
(*TestOfTests*)


AssignTestFeatures[TestOfTests, TestMatch];


TestOfTests[
	input_,
	Shortest[messages_:{}],
	opts:OptionsPattern[]
] :=
	With[
		{options = DelegateOptions[opts, TestOfTests, TestMatch]}
		,
		TestMatch[
			TestsOfTestsEnvironment[input],
			_,
			messages,
			options
		]
	]


(* ::Subsection:: *)
(*TestCaseOfTestResult*)


TestCaseOfTestResult::unknownSelectors =
"TestCaseOfTestResult: Unknown selectors: `1`. \
They were given in set of selectors with non-default expected values: `2`, \
but are not in set of AllSelectors: `3`."


AssignTestFeatures[TestCaseOfTestResult];

PrependToOptions[TestCaseOfTestResult,
	"AllSelectors" -> {
		(* MUnit` selectors *)
		
		FailureMode -> "Success",
		TestInput -> None,
		ExpectedOutput -> None,
		ActualOutput -> None,
		ExpectedMessages -> {},
		ActualMessages -> {},
		ErrorMessage -> "",
		TestID -> 0,
		TestIndex -> 1,
		AllTestIndex -> 0,
		(* TestInputSetFunction selector is set but it has no "real" value. *)
		ExpectedOutputSetFunction -> Set,
		EquivalenceFunction -> SameQ,
		MessagesEquivalenceFunction -> $DefaultMessagesEquivalenceFunction,
		ExpectedMessagesWrapper ->
			MUnit`Test`Private`$DefaultExpectedMessagesWrapper,
		TestFailureMessage -> "",
		TestFailureAction -> "Continue",
		TestErrorAction -> "Abort",
		(*TestTimeUsed -> something grater than zero,
		TestMemoryUsed -> some integer,*)
		TestTags -> {},
		(*TestSource -> "",*)
		
		
		(* MUnitExtras` selectors *)
		
		TestRawInput -> None,
		UnevaluatadRawExpectedOutput -> None,
		UnevaluatadExpectedOutput -> None,
		ApplyToInput -> None,
		ApplyToExpected -> None,
		InputWrapper -> None,
		ExpectedWrapper -> None,
		TestFailureMessageGenerator -> $DefaultTestFailureMessageGenerator
	}
]


TestCaseOfTestResult[
	tr_,
	nonDefaultSelectors:{Repeated[(_Rule | _RuleDelayed), {0, Infinity}]},
	opts:OptionsPattern[]
] :=
	TestCaseEnvironment[
		{opts, Options[TestCaseOfTestResult]}
		,
		With[
			{
				nonDefaultSelectorNames = First /@ nonDefaultSelectors,
				allSelectorNames = First /@ OptionValue["AllSelectors"]
			}
			,
			If[Complement[nonDefaultSelectorNames, allSelectorNames] =!= {},
				ThrowTestError @ StringForm[
					TestCaseOfTestResult::unknownSelectors
					,
					Complement[nonDefaultSelectorNames, allSelectorNames],
					nonDefaultSelectorNames,
					allSelectorNames
				]
			];
		];
		
		Test[
			tr,
			_Symbol,
			EquivalenceFunction -> MatchQ,
			TestFailureMessage -> "input did not evaluate to a symbol"
		];
		Test[
			SymbolName[tr],
			"TestResultObject*",
			EquivalenceFunction -> StringMatchQ,
			TestFailureMessage -> "input did not evaluate to a test result"
		];
		
		
		(* Test test result object selectors. *)
		Test[
			#1[tr],
			#2,
			TestFailureMessage -> ToString[#1]
		]& @@@ (
			OptionValue["AllSelectors"] /.
				((First[#] -> _) -> (#)& /@ nonDefaultSelectors)
		);
		,
		"CommonOptionsFor" -> {Test}
	]


(* ::Subsection:: *)
(*TestCaseOfErrorTestResult*)


AssignTestFeatures[TestCaseOfErrorTestResult, TestCaseOfTestResult];

SetOptions[TestCaseOfErrorTestResult,
	"AllSelectors" ->
		OptionValue[TestCaseOfTestResult, "AllSelectors"] /.
			(
				(First[#] -> _) -> (#)& /@ {
					(* MUnit` selectors *)
					FailureMode -> "Error",
					TestInput -> $Error,
					ExpectedOutput -> $Error,
					ActualOutput -> $Error,
					ExpectedMessages -> $Error,
					ActualMessages -> $Error
					,
					(* MUnitExtras` selectors *)
					TestRawInput -> $Error,
					UnevaluatadRawExpectedOutput -> $Error,
					UnevaluatadExpectedOutput -> $Error
				}
			)
]


TestCaseOfErrorTestResult[
	tr_,
	nonDefaultSelectors:{Repeated[(_Rule | _RuleDelayed), {0, Infinity}]},
	opts:OptionsPattern[]
] :=
	With[
		{
			delegatedOptions =
				DelegateOptions[
					opts, TestCaseOfErrorTestResult, TestCaseOfTestResult
				]
		}
		,
		TestCaseOfTestResult[tr, nonDefaultSelectors, delegatedOptions]
	]


(* ::Subsection:: *)
(*TestCaseOfTest*)


AssignTestFeatures[TestCaseOfTest, TestCaseOfTestResult];


TestCaseOfTest[
	input_,
	nonDefaultSelectors_,
	Shortest[messages_:{}],
	opts:OptionsPattern[]
] :=
	Block[
		{$TestsOfTestsLog = {}}
		,
		Module[
			{tr}
			,
			(*
				Don't use TestCaseEnvironment cause it would change default
				options of tests given as input and we don't want that.
			*)
			With[
				{
					testOfTestsOptions =
						FilterRules[
							DelegateOptions[opts, TestCaseOfTest, TestOfTests],
							Except[EquivalenceFunction]
						]
					,
					testOptions =
						DelegateOptions[opts, TestCaseOfTest, Test]
					,
					testCaseOfTestResultOptions =
						DelegateOptions[
							opts, TestCaseOfTest, TestCaseOfTestResult
						]
				}
				,
				TestOfTests[
					tr = TestsOfTestsEnvironment[input],
					messages,
					TestFailureMessage -> "Test evaluation",
					testOfTestsOptions
				];
				
				
				Test[
					Length[$TestsOfTestsLog],
					1,
					TestFailureMessage ->
						"logged different number of test results than one",
					testOptions
				];
				Test[
					Last[$TestsOfTestsLog],
					tr,
					TestFailureMessage ->
						"logged test result is differen than returned one",
					testOptions
				];
				
				
				TestCaseOfTestResult[
					tr,
					nonDefaultSelectors,
					TestFailureMessage -> "Test result object",
					testCaseOfTestResultOptions
				];
			];
		];
	]


(* ::Subsection:: *)
(*TestCaseOfTestError*)


AssignTestFeatures[TestCaseOfTestError, TestCaseOfErrorTestResult];


TestCaseOfTestError[
	input_,
	nonDefaultSelectors_,
	Shortest[messages_:{}],
	opts:OptionsPattern[]
] :=
	With[
		{
			delegatedOptions =
				DelegateOptions[opts, TestCaseOfTestError, TestCaseOfTest]
		}
		,
		TestCaseOfTest[input, nonDefaultSelectors, messages, delegatedOptions]
	]


End[]


(* ::Section:: *)
(*Public symbols protection*)


ProtectContextNonVariables[];


EndPackage[]
