(* ::Package:: *)

BeginPackage["MUnitExtras`Tests`"]


(* ::Section:: *)
(*Public*)


TestN::usage =
"\
TestN[input, expected] \
tests whether numerical value of input is equal to numerical value of \
expected and that no messages are generated.\

TestN[input, expected, messages] \
tests whether numerical value of input is equal to numerical value of \
expected and that given messages are generated."


TestDefault::usage =
"\
TestDefault[input] \
tests whether input evaluates to value of ExpectedOutput option and no \
messages are generated.\

TestDefault[input, messages] \
tests whether input evaluates to value of ExpectedOutput option and given \
messages are generated."


TestTrue::usage =
"\
TestTrue[input] \
tests whether input evaluates to True and no messages are generated.\

TestTrue[input, messages] \
tests whether input evaluates to True and given messages are generated."


TestFalse::usage =
"\
TestFalse[input] \
tests whether input evaluates to False and no messages are generated.\

TestFalse[input, messages] \
tests whether input evaluates to False and given messages are generated."


TestNull::usage =
"\
TestNull[input] \
tests whether input evaluates to Null and no messages are generated.\

TestNull[input, messages] \
tests whether input evaluates to Null and given messages are generated."


TestFailed::usage =
"\
TestFailed[input] \
tests whether input evaluates to $Failed and no messages are generated.\

TestFailed[input, messages] \
tests whether input evaluates to $Failed and given messages are generated."


TestZero::usage =
"\
TestZero[input] \
tests whether input evaluates to 0 and no messages are generated.\

TestZero[input, messages] \
tests whether input evaluates to 0 and given messages are generated."


TestNonZero::usage =
"\
TestNonZero[input] \
tests whether input evaluates to anything different than 0 and no messages \
are generated.\

TestNonZero[input, messages] \
tests whether input evaluates to anything different than 0 and given messages \
are generated."


TestUnchanged::usage =
"\
TestUnchanged[input] \
tests whether evaluation of input doesn't change it and that no messages are \
generated.\

TestUnchanged[input, messages] \
tests whether evaluation of input doesn't change it and that given messages \
are generated."


TestUnchangedHead::usage =
"\
TestUnchangedHead[input] \
tests whether evaluation of input doesn't change its head and that no \
messages are generated.\

TestUnchangedHead[input, messages] \
tests whether evaluation of input doesn't change its head and that given \
messages are generated."


TestSubexpression::usage =
"\
TestSubexpression[input] \
tests whether evaluation of input returns first element of unevaluated input \
expression and does not generate any messages.\

TestSubexpression[input, messages] \
tests whether evaluation of input returns first element of unevaluated input \
expression and generates given messages."


SubexpressionPosition::usage =
"\
SubexpressionPosition \
is an option to TestSubexpression that specifies position of subexpression \
in unevaluated input that is expected to be returned by input evaluation.\

The position specifications that can be set as SubexpressionPosition option \
value should have the same form as those returned by Position, and used in \
functions such as Extract, MapAt and ReplacePart."


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


Needs["MUnitExtras`MUnit`"]
Needs["MUnitExtras`Package`"]


Needs["MessagesUtilities`"] (* CollectMessages *)
Needs["ProtectionUtilities`"] (* ProtectContextNonVariables *)
Needs["OptionsUtilities`"] (* PrependToOptions, DelegateOptions *)
Needs["StringUtilities`"] (* StringJoinBy *)


(* ::Subsection:: *)
(*TestN*)


AssignTestFeatures[TestN]

PrependToOptions[TestN, N -> N]

SetOptions[TestN,
	InputWrapper -> Automatic,
	ExpectedWrapper -> Automatic,
	SameTestVersioned -> Equal
]


TestN[input_, expected_, Shortest[messages_:{}], opts:OptionsPattern[]] :=
	CatchTestError[
		{input, messages, opts}
		,
		Module[
			{
				inputWrapper =
					If[OptionValue[InputWrapper] === Automatic,
						OptionValue[N]
					(* else *),
						OptionValue[InputWrapper]
					]
				,
				expectedWrapper =
					If[OptionValue[ExpectedWrapper] === Automatic,
						OptionValue[N]
					(* else *),
						OptionValue[ExpectedWrapper]
					]
				,
				applyToInput = OptionValue[ApplyToInput],
				applyToExpected = OptionValue[ApplyToExpected]
				,
				holdPreprocessedInput,
				holdPreprocessedExpected,
				inputN,
				expectedN,
				nonNs = {}
			}
			,
			holdPreprocessedInput =
				MUnitExtras`MUnit`Private`ApplyAndWrapInsideHold[
					HoldComplete[input],
					applyToInput,
					inputWrapper
				];
			holdPreprocessedExpected =
				MUnitExtras`MUnit`Private`ApplyAndWrapInsideHold[
					HoldComplete[expected],
					applyToExpected,
					expectedWrapper
				];
			Quiet[
				MUnit`Test`Private`MUnitCheckAll[
					inputN = ReleaseHold[holdPreprocessedInput];
					expectedN = ReleaseHold[holdPreprocessedExpected];
					,
					opts
				];
			];
			
			If[! NumberQ[#2],
				AppendTo[
					nonNs,
					ToString @ StringForm[
						General::notNumber,
						#1,
						MakeString[#2]
					]
				]
			]& @@@
				{
					{
						"Input: " <>
							MakeString[HoldForm @@ holdPreprocessedInput]
						,
						inputN
					},
					{
						"Expected: " <>
							MakeString[HoldForm @@ holdPreprocessedExpected]
						,
						expectedN
					}
				};
			
			If[nonNs =!= {},
				ThrowTestError[StringJoinBy[nonNs]]
			];
			
			With[
				{
					options =
						DelegateOptions[
							InputWrapper -> inputWrapper,
							ExpectedWrapper -> expectedWrapper,
							opts,
							TestN,
							Test
						]
				}
				,
				Test[input, expected, messages, options]
			]		
		]
	]


(* ::Subsection:: *)
(*TestDefault*)


AssignTestFeatures[TestDefault]

PrependToOptions[TestDefault, ExpectedOutput -> RequiredOptionIsNotSet]


TestDefault[input_, Shortest[messages_:{}], opts:OptionsPattern[]] :=
	CatchTestError[
		{input, messages, opts}
		,
		CheckRequiredOptions[TestDefault, {opts}, ExpectedOutput];
		
		With[
			{
				options = DelegateOptions[opts, TestDefault, Test],
				expectedOutput = OptionValue[ExpectedOutput]
			}
			,
			Test[input, expectedOutput, messages, options]
		]
	]


(* ::Subsection:: *)
(*TestTrue*)


AddTestDefaultFunction[TestTrue, True]


(* ::Subsection:: *)
(*TestFals*)


AddTestDefaultFunction[TestFalse, False]


(* ::Subsection:: *)
(*TestNull*)


AddTestDefaultFunction[TestNull, Null]


(* ::Subsection:: *)
(*TestFailed*)


AddTestDefaultFunction[TestFailed, $Failed]


(* ::Subsection:: *)
(*TestZero*)


AddTestDefaultFunction[TestZero, 0]


(* ::Subsection:: *)
(*TestNonZero*)


AddTestDefaultFunction[TestNonZero, 0]

SetOptions[TestNonZero, SameTestVersioned -> UnsameQ]


(* ::Subsection:: *)
(*TestUnchanged*)


AssignTestFeatures[TestUnchanged, TestMatch]


TestUnchanged[input_, Shortest[messages_:{}], opts:OptionsPattern[]] :=
	With[
		{
			options = DelegateOptions[opts, TestUnchanged, TestMatch],
			expected =
				If[OptionValue[ApplyToInput] === None,
					HoldPattern[input]
				(* else *),
					OptionValue[ApplyToInput] @@@ HoldPattern[input]
				]
		}
		,
		TestMatch[input, expected, messages, options]
	]


(* ::Subsection:: *)
(*TestUnchangedHead*)


AssignTestFeatures[TestUnchangedHead]

SetOptions[TestUnchangedHead, InputWrapper -> Head]


TestUnchangedHead[input_, Shortest[messages_:{}], opts:OptionsPattern[]] :=
	With[
		{
			options = DelegateOptions[opts, TestUnchangedHead, Test],
			expected =
				If[OptionValue[ApplyToInput] === None,
					Hold[input][[1, 0]]
				(* else *),
					OptionValue[ApplyToInput]
				]
		}
		,
		Test[input, expected, messages, options]
	]


(* ::Subsection:: *)
(*TestSubexpression*)


AssignTestFeatures[TestSubexpression]

PrependToOptions[TestSubexpression, SubexpressionPosition -> 1]


TestSubexpression[input_, Shortest[messages_:{}], opts:OptionsPattern[]] :=
	CatchTestError[
		{input, messages, opts}
		,
		Module[
			{
				pos = OptionValue[SubexpressionPosition],
				extractionResult,
				extractionMessages
			}
			,
			Quiet @ Check[
				{extractionResult, extractionMessages} =
					CollectMessages[Extract[Unevaluated[input], pos]]
				,
				ThrowTestError @ StringForm[
					General::argExtractionFailed,
					pos,
					MakeString[HoldForm[input]],
					MakeString /@ HoldForm @@@ extractionMessages[[1;;-1,1;;1]]
				]
			];
			With[
				{
					expected = extractionResult,
					options =
						DelegateOptions[
							opts,
							TestSubexpression,
							Test
						]
				}
				,
				Test[input, expected, messages, options]
			]
		]
	]


End[]


(* ::Section:: *)
(*Public symbols protection*)


ProtectContextNonVariables[];


EndPackage[]
