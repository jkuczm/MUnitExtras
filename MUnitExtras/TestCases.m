(* ::Package:: *)

BeginPackage["MUnitExtras`TestCases`"]


(* ::Section:: *)
(*Public*)


TestCaseSymbolicNumeric::usage =
"\
TestCaseSymbolicNumeric[input, expected] \
Performs two tests: tests whether input evaluates to expected; and whether \
numerical value of result of this evaluation is equal to numerical value of \
first element of input."


TestCaseSparse::usage =
"\
TestCaseSparse[{testArgs1, testArgs2, ...}] \
for each element of collection given as AllTestsArgs option, performs a \
test. For testArgsi performs test given as value of Test option with \
arguments testArgsi. For elements from AllTestsArgs option that are not \
given as explicit arguments performs test given as value of TestDefault \
option."


TestCaseMultipleFunctions::usage =
"\
TestCaseMultipleFunctions[testArgs] \
accepts list as ApplyToInput option value and performes tests given as value \
of Test option with given testArgs with ApplyToInput option set to each \
element of said list."


TestCaseRepeated::usage =
"\
TestCaseRepeated[body] \
repeats evaluation of body with applied replacement rules for each set of \
rules given as value of RepeatFor option."


InputWrapperN::usage =
"\
InputWrapperN \
is an option to TestCaseSymbolicNumeric that specifies InputWrapper that will \
be used by numeric test."


ExpectedWrapperN::usage =
"\
ExpectedWrapperN \
is an option to TestCaseSymbolicNumeric that specifies ExpectedWrapper that \
will be used by numeric test."


AllTestsArgs::usage =
"\
AllTestsArgs \
is an option to some TestCases that specifies arguments that will be tested."


RepeatFor::usage =
"\
RepeatFor \
is an option to TestCaseRepeated that specifies sets of replacement rules \
that will be applied to body of test case before its evaluation."


(* Unprotect all public symbols in this package. *)
Unprotect["`*"];


(* ::Section:: *)
(*Private*)


Begin["`Private`"]


(* ::Subsection:: *)
(*Imports*)


Needs["MUnit`"]
(* MUnit`Package` contains symbols used internally by MUnit` *)
PrependTo[$ContextPath, "MUnit`Package`"]


Needs["MUnitExtras`Tests`"]
Needs["MUnitExtras`Package`"]
Needs["MUnitExtras`MUnit`"]


Needs["MessagesUtilities`"] (* CollectMessages *)
Needs["ProtectionUtilities`"] (* ProtectContextNonVariables *)
Needs["OptionsUtilities`"] (* PrependToOptions *)
Needs["StringUtilities`"] (* StringJoinBy *)


(* ::Subsection:: *)
(*TestCaseSymbolicNumeric*)


AssignTestFeatures[TestCaseSymbolicNumeric, {TestSubexpression, TestN}]

PrependToOptions[TestCaseSymbolicNumeric,
	InputWrapperN -> OptionValue[TestN, InputWrapper],
	ExpectedWrapperN -> OptionValue[TestN, ExpectedWrapper]
]


TestCaseSymbolicNumeric[
	input_,
	expected_,
	Shortest[messages_:{}],
	opts:OptionsPattern[]
] :=
	TestCaseEnvironment[
		{
			FilterRules[
				Flatten[{opts, Options[TestCaseSymbolicNumeric]}],
				Except[{ApplyToInput, ApplyToExpected, EquivalenceFunction}]
			]
		}
		,
		
		Module[
			{
				pos = OptionValue[SubexpressionPosition],
				applyToInput = OptionValue[ApplyToInput],
				applyToExpected = OptionValue[ApplyToExpected],
				equivalenceFunction = OptionValue[EquivalenceFunction],
				extractionResult,
				extractionMessages,
				tr
			}
			,
			Quiet @ Check[
				{extractionResult, extractionMessages} =
					CollectMessages[Extract[Unevaluated[input], pos]]
				,
				ThrowTestError @ StringForm[
					General::argExtractionFailed,
					pos,
					MeetLogger`Private`makeString[HoldForm[input]],
					MeetLogger`Private`makeString /@
						HoldForm @@@ extractionMessages[[1;;-1,1;;1]]
				]
			];
			tr = Test[
				input, expected, messages,
				ApplyToInput -> applyToInput,
				ApplyToExpected -> applyToExpected,
				EquivalenceFunction -> equivalenceFunction,
				TestFailureMessage -> "Symbolic"
			];

			With[
				{
					result = First[ActualOutput[tr]],
					expectedN = extractionResult,
					inputWrapper = OptionValue[InputWrapperN],
					expectedWrapper = OptionValue[ExpectedWrapperN]
				}
				,
				TestN[
					result,
					expectedN,
					InputWrapper -> inputWrapper,
					ExpectedWrapper -> expectedWrapper,
					TestFailureMessage -> "Numeric"
				];
			]
		]
		,
		"CommonOptionsFor" -> {Test, TestN}
	]


(* ::Subsection:: *)
(*TestCaseSparse*)


HoldHeldToStringList[hh_] :=
	ToString[List @@ (ToString[#, InputForm] &) /@ Unevaluated @@@ hh]


TestCaseSparse::notInAllTestsArgs =
"TestCaseSparse: set of given inputs with non-default expected values: `1` is \
not a subset of defined AllTestsArgs: `2`. Excessive arguments are: `3`."


AssignTestFeatures[TestCaseSparse]

PrependToOptions[TestCaseSparse,
	AllTestsArgs -> RequiredOptionIsNotSet,
	Test -> Test,
	TestDefault -> TestDefault
]


TestCaseSparse[nonDefault_, opts:OptionsPattern[]] :=
	TestCaseEnvironment[
		{FilterRules[{opts}, Except[{Test, TestDefault}]]}
		,
		CheckRequiredOptions[TestCaseSparse, {opts}, AllTestsArgs];
	
		Module[
			{
				holdAllTestArgs = Hold @@ OptionValue[AllTestsArgs],
				holdHeldTestArgs,
				holdTestedInputs,
				holdHeldTestedInputs
				,
				holdNonDefault = Hold @@ nonDefault,
				holdNonDefaultInputs,
				holdHeldNonDefaultInputs
			}
			,
			(*
				Don't use First /@ testSpecs since it won't work with
				expression with head Hold.
			*)
			holdHeldTestArgs = Hold @@@ holdAllTestArgs;
			holdTestedInputs = holdAllTestArgs[[1;;-1, 1]];
			holdHeldTestedInputs = Hold /@ holdTestedInputs;
			
			holdNonDefaultInputs = holdNonDefault[[1;;-1, 1]];
			holdHeldNonDefaultInputs = Hold /@ holdNonDefaultInputs;
			
			If[
				Complement[
					holdHeldNonDefaultInputs,
					holdHeldTestedInputs,
					(* SameQ is needed to compare held expressions. *)
					SameTest -> SameQ
				] =!= Hold[]
				,
				ThrowTestError @ StringForm[
					TestCaseSparse::notInAllTestsArgs
					,
					HoldHeldToStringList[holdHeldNonDefaultInputs],
					HoldHeldToStringList[holdHeldTestedInputs],
					HoldHeldToStringList[
						Complement[
							holdHeldNonDefaultInputs,
							holdHeldTestedInputs,
							SameTest -> SameQ
						]
					]
				]
			];
			
			ReleaseHold[OptionValue[Test] @@@ holdNonDefault];
			ReleaseHold[
				OptionValue[TestDefault] @@@
					Complement[
						holdHeldTestArgs,
						holdHeldNonDefaultInputs,
						(*
							For default tests use only arguments that don't
							have same first element as first element of one of
							non-default arguments.
						*)
						SameTest -> (SameQ[#1[[1;;1]], ##2]&)
					]
			];
		];
		,
		"CommonOptionsFor" -> {OptionValue[Test], OptionValue[TestDefault]}
	]


(* ::Subsection:: *)
(*TestCaseMultipleFunctions*)


TestCaseMultipleFunctions::differentLengths =
"In TestCaseMultipleFunctions lengths of lists given as ApplyToInput (`1`) \
and ApplyToExpected (`2`) option values should be the same."

TestCaseMultipleFunctions::nonListOptions =
"In TestCaseMultipleFunctions at least one of ApplyToInput, ApplyToExpected \
option values should be non-empty List, but option are: `1`, `2`."


AssignTestFeatures[TestCaseMultipleFunctions]

PrependToOptions[TestCaseMultipleFunctions, Test -> Test]


TestCaseMultipleFunctions[Shortest[testArgs___], opts:OptionsPattern[]] :=
	TestCaseEnvironment[
		{
			FilterRules[{opts}, Except[{Test, ApplyToInput, ApplyToExpected}]]
		}
		,
		Module[
			{
				applyToInput = OptionValue[ApplyToInput],
				applyToExpected = OptionValue[ApplyToExpected],
				applyToInputLen,
				applyToExpectedLen,
				failureMessageFunc
			}
			,
			applyToInputLen = Length[applyToInput];
			applyToExpectedLen = Length[applyToExpected];
			
			Switch[{applyToInput, applyToExpected},
				{{__}, {__}},
					If[applyToInputLen != applyToExpectedLen,
						ThrowTestError @ StringForm[
							TestCaseMultipleFunctions::differentLengths
							,
							applyToInputLen,
							applyToExpectedLen
						]
					];
					
					failureMessageFunc =
						"ApplyToInput: " <> ToString[#1] <>
						", ApplyToExpected: " <> ToString[#2]&;
				,
				{{__}, _},
					applyToExpected =
						ConstantArray[applyToExpected, applyToInputLen];
					
					failureMessageFunc = ToString[#1]&;
				,
				{_, {__}},
					applyToInput =
						ConstantArray[applyToInput, applyToExpectedLen];
					
					failureMessageFunc = ToString[#2]&;
				,
				_,
					ThrowTestError @ StringForm[
						TestCaseMultipleFunctions::nonListOptions
						,
						ApplyToInput -> applyToInput,
						ApplyToExpected -> applyToExpected
					];
			];
		
			MapThread[
				OptionValue[Test][
					testArgs,
					ApplyToInput -> #1,
					ApplyToExpected -> #2,
					TestFailureMessage -> failureMessageFunc[##]
				]&
				,
				{applyToInput, applyToExpected}
			];
		]
		,
		"CommonOptionsFor" -> {OptionValue[Test]}
	]


(* ::Subsection:: *)
(*TestCaseRepeated*)


AssignTestFeatures[TestCaseRepeated]

PrependToOptions[TestCaseRepeated, {
	RepeatFor -> RequiredOptionIsNotSet
}]


TestCaseRepeated[body_, opts:OptionsPattern[]] :=
	With[
		{
			testFailureMessageGenerator =
				OptionValue[TestFailureMessageGenerator]
		}
		,
		TestCaseEnvironment[
			{
				FilterRules[{opts}, {TestID, TestErrorAction}]
			}
			,
			CheckRequiredOptions[TestCaseRepeated, {opts}, RepeatFor];
			CheckOptionsValues[
				TestCaseRepeated,
				{opts},
				RepeatFor ->
					{
						(
							_Rule | _RuleDelayed |
							{Repeated[_Rule | _RuleDelayed, {0, Infinity}]}
						)..
					}
			];
			
			Function[
				rules
				,
				ReleaseHold[
					SetOptions[
						Append[
							MUnitExtras`Package`Private`$TestingFunctions,
							TestCaseEnvironment
						]
						,
						TestFailureMessageGenerator ->
							(StringJoinBy[
								OptionValue[TestFailureMessage],
								ToString[rules],
								testFailureMessageGenerator[#]
								,
								"Separator" -> ": "
							]&)
					];
				
					HoldComplete[body] /. rules
				]
			] /@
				OptionValue[RepeatFor]
		]
	]


End[]


(* ::Section:: *)
(*Public symbols protection*)


ProtectContextNonVariables[];


EndPackage[]
