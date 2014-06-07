(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["TestEnvironment`TestEnvironment`BeginTestEnvironment`"];


Needs["MUnitExtras`"];


(* ::Subsection:: *)
(*Definitions*)


(* Mock package *)
BeginPackage["MyPackage`"];
Options[func] = {"funcOpt" -> "funcOptValue"};
func[] = "funcValue";
sym = "symValue";
EndPackage[];


original$Context = $Context;
original$ContextPath = $ContextPath;
original$Packages = $Packages;


mUnitExtrasSubPackages = {
	"MUnitExtras`TestEnvironment`",
	"MUnitExtras`MUnit`",
	"MUnitExtras`Tests`",
	"MUnitExtras`TestCases`"
};


mUnitSavedOptionsPatt =
	(# -> _)& /@
		Select[Cases[Symbol /@ Names["MUnit`*"], _Symbol], Options[#] =!= {}&];
	
mUnitExtrasSavedOptionsPatt =
	(# -> _)& /@
		Select[
			Cases[
				Symbol /@ Flatten[Names[# <>"*"]& /@ mUnitExtrasSubPackages],
				_Symbol
			]
			,
			Options[#] =!= {}&
		];


TearDown[] :=
	While[
		And[
			$Context =!= original$Context,
			$Context =!= "Global`"
		],
		Quiet[Remove["`*"], {Remove::rmnsm}];
		Quiet[EndPackage[], {EndPackage::noctx}];
	]


(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*No arguments*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{testEnvData, contextName}
	,
	
	
	TestMatch[
		testEnvData = BeginTestEnvironment[]
		,
		_String -> _Symbol
		,
		TestID -> "No args: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "No args: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	contextName = First[testEnvData];
	
	Test[
		First[StringSplit[contextName, "`"]]
		,
		"TestEnvironment"
		,
		TestID -> "No args: \
BeginTestEnvironment returned subcontext of \"TestEnvironment`\""
	];
	Test[
		$Context
		,
		contextName
		,
		TestID -> "No args: \
Active context is one returned by BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		Flatten[{contextName, mUnitExtrasSubPackages, "MUnit`", "System`"}]
		,
		TestID -> "No args: \
$ContextPath contains only context returned by BeginTestEnvironment, \
MUnitExtras`, MUnit` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] ->
				Sort[Join[mUnitSavedOptionsPatt, mUnitExtrasSavedOptionsPatt]]
		}
		,
		TestID -> "No args: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Needed contexts list*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{testEnvData, contextName}
	,
	
	
	TestMatch[
		testEnvData = BeginTestEnvironment[{"MyPackage`"}]
		,
		_String -> _Symbol
		,
		TestID -> "List with MyPackage` context: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "List with MyPackage` context: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	contextName = First[testEnvData];
	
	Test[
		First[StringSplit[contextName, "`"]]
		,
		"TestEnvironment"
		,
		TestID -> "List with MyPackage` context: \
BeginTestEnvironment returned subcontext of \"TestEnvironment`\""
	];
	Test[
		$Context
		,
		contextName
		,
		TestID -> "List with MyPackage` context: \
Active context is one returned by BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		Flatten[
			{
				contextName, "MyPackage`", mUnitExtrasSubPackages, "MUnit`",
				"System`"
			}
		]
		,
		TestID -> "List with MyPackage` context: \
$ContextPath contains only context returned by BeginTestEnvironment, \
MyPackage`, MUnitExtras`, MUnit` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] ->
				Sort[
					Join[
						{MyPackage`func -> _},
						mUnitSavedOptionsPatt,
						mUnitExtrasSavedOptionsPatt
					]
				]
		}
		,
		TestID -> "List with MyPackage` context: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Explicit context name*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{testEnvData}
	,
	
	
	TestMatch[
		testEnvData = BeginTestEnvironment["MyTestEnvName`"]
		,
		_String -> _Symbol
		,
		TestID -> "Test environment context name: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "Test environment context name: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	Test[
		First[testEnvData]
		,
		"MyTestEnvName`"
		,
		TestID -> "Test environment context name: \
BeginTestEnvironment returned given context"
	];
	Test[
		$Context
		,
		"MyTestEnvName`"
		,
		TestID -> "Test environment context name: \
Active context is one given to BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		Flatten[
			{"MyTestEnvName`", mUnitExtrasSubPackages, "MUnit`", "System`"}
		]
		,
		TestID -> "Test environment context name: \
$ContextPath contains only context given to BeginTestEnvironment, \
MUnitExtras`, MUnit` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] ->
				Sort[Join[mUnitSavedOptionsPatt, mUnitExtrasSavedOptionsPatt]]
		}
		,
		TestID -> "Test environment context name: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Explicit context name and needed contexts list*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{testEnvData}
	,
	
	
	TestMatch[
		testEnvData = BeginTestEnvironment["MyTestEnvName`", {"MyPackage`"}]
		,
		_String -> _Symbol
		,
		TestID -> "Test environment context name, list with one context: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "Test environment context name, list with one context: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	Test[
		First[testEnvData]
		,
		"MyTestEnvName`"
		,
		TestID -> "Test environment context name, list with one context: \
BeginTestEnvironment returned given context"
	];
	Test[
		$Context
		,
		"MyTestEnvName`"
		,
		TestID -> "Test environment context name, list with one context: \
Active context is one returned by BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		Flatten[
			{
				"MyTestEnvName`", "MyPackage`", mUnitExtrasSubPackages,
				"MUnit`", "System`"
			}
		]
		,
		TestID -> "Test environment context name, list with one context: \
$ContextPath contains only context returned by BeginTestEnvironment, \
MyPackage`, MUnitExtras`, MUnit` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] ->
				Sort[
					Join[
						{MyPackage`func -> _},
						mUnitSavedOptionsPatt,
						mUnitExtrasSavedOptionsPatt
					]
				]
		}
		,
		TestID -> "Test environment context name, list with one context: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Explicit "SaveOptionsForSymbols" option*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{
		testEnvData, contextName,
		sym1, sym2
	}
	,
	Options[sym1] = {"sym1Opt" -> "sym1OptValue"};
	
	
	TestMatch[
		testEnvData =
			BeginTestEnvironment["SaveOptionsForSymbols" -> {sym1, sym2}]
		,
		_String -> _Symbol
		,
		TestID -> "Explicit \"SaveOptionsForSymbols\" option: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "Explicit \"SaveOptionsForSymbols\" option: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	contextName = First[testEnvData];
	
	Test[
		First[StringSplit[contextName, "`"]]
		,
		"TestEnvironment"
		,
		TestID -> "Explicit \"SaveOptionsForSymbols\" option: \
BeginTestEnvironment returned subcontext of \"TestEnvironment`\""
	];
	Test[
		$Context
		,
		contextName
		,
		TestID -> "Explicit \"SaveOptionsForSymbols\" option: \
Active context is one returned by BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		Flatten[{contextName, mUnitExtrasSubPackages, "MUnit`", "System`"}]
		,
		TestID -> "Explicit \"SaveOptionsForSymbols\" option: \
$ContextPath contains only context returned by BeginTestEnvironment, \
MUnitExtras`, MUnit` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] -> {sym1 -> _}
		}
		,
		TestID -> "Explicit \"SaveOptionsForSymbols\" option: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Wrong value of "SaveOptionsForSymbols" option *)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	Test[
		BeginTestEnvironment[
			"SaveOptionsForSymbols" ->
				"SaveOptionsForSymbolsOptionWrongValue"
		]
		,
		$Failed
		,
		{BeginTestEnvironment::unknownOptionValue}
		,
		TestID -> "\"SaveOptionsForSymbols\" option wrong value: \
$Failed returned, \
warning messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "\"SaveOptionsForSymbols\" option wrong value: \
$TestEnvironments remained an empty list."
	];
	
	
	Test[
		$Context
		,
		"TestEnvironment`TestEnvironment`BeginTestEnvironment`"
		,
		TestID -> "\"SaveOptionsForSymbols\" option wrong value: \
Active context was not changed."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "\"SaveOptionsForSymbols\" option wrong value: \
$ContextPath was not changed."
	];
	
	
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "\"SaveOptionsForSymbols\" option wrong value: \
no options were saved."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*Explicit "BasicNeeds" option*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{testEnvData, contextName}
	,
	
	
	TestMatch[
		testEnvData = BeginTestEnvironment["BasicNeeds" -> {"MyPackage`"}]
		,
		_String -> _Symbol
		,
		TestID -> "Explicit \"BasicNeeds\" -> {\"MyPackage`\"}: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "Explicit \"BasicNeeds\" -> {\"MyPackage`\"}: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	contextName = First[testEnvData];
	
	Test[
		First[StringSplit[contextName, "`"]]
		,
		"TestEnvironment"
		,
		TestID -> "Explicit \"BasicNeeds\" -> {\"MyPackage`\"}: \
BeginTestEnvironment returned subcontext of \"TestEnvironment`\""
	];
	Test[
		$Context
		,
		contextName
		,
		TestID -> "Explicit \"BasicNeeds\" -> {\"MyPackage`\"}: \
Active context is one returned by BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		{contextName, "MyPackage`", "System`"}
		,
		TestID -> "Explicit \"BasicNeeds\" -> {\"MyPackage`\"}: \
$ContextPath contains only context returned by BeginTestEnvironment, \
MyPackage` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] -> {MyPackage`func -> _}
		}
		,
		TestID -> "Explicit \"BasicNeeds\" -> {\"MyPackage`\"}: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Explicit list of needed contexts and explicit "BasicNeeds" option *)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
Module[
	{testEnvData, contextName}
	,
	
	
	TestMatch[
		testEnvData =
			BeginTestEnvironment[{"MyPackage`"}, "BasicNeeds" -> {"MUnit`"}]
		,
		_String -> _Symbol
		,
		TestID -> "{\"MyPackage`\"}, \"BasicNeeds\" -> {\"MUnit`\"}: \
BeginTestEnvironment evaluation: Rule returned, \
no messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{testEnvData}
		,
		TestID -> "{\"MyPackage`\"}, \"BasicNeeds\" -> {\"MUnit`\"}: \
$TestEnvironments contains only data returned by BeginTestEnvironment."
	];
	
	
	contextName = First[testEnvData];
	
	Test[
		First[StringSplit[contextName, "`"]]
		,
		"TestEnvironment"
		,
		TestID -> "{\"MyPackage`\"}, \"BasicNeeds\" -> {\"MUnit`\"}: \
BeginTestEnvironment returned subcontext of \"TestEnvironment`\""
	];
	Test[
		$Context
		,
		contextName
		,
		TestID -> "{\"MyPackage`\"}, \"BasicNeeds\" -> {\"MUnit`\"}: \
Active context is one returned by BeginTestEnvironment."
	];
	Test[
		$ContextPath
		,
		{contextName, "MyPackage`", "MUnit`", "System`"}
		,
		TestID -> "{\"MyPackage`\"}, \"BasicNeeds\" -> {\"MUnit`\"}: \
$ContextPath contains only context returned by BeginTestEnvironment, \
MyPackage`, MUnit` and System`."
	];
	
	
	TestMatch[
		OptionsUtilities`Private`$SavedOptions
		,
		{
			Last[testEnvData] ->
				Sort[Append[mUnitSavedOptionsPatt, MyPackage`func -> _]]
		}
		,
		TestID -> "{\"MyPackage`\"}, \"BasicNeeds\" -> {\"MUnit`\"}: \
$SavedOptions has one entry identified by id returned by BeginTestEnvironment \
with options for proper symbols."
	];
	
	
	TearDown[];
];
];


(* ::Subsection:: *)
(*Wrong value of "BasicNeeds" option *)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	Test[
		BeginTestEnvironment["BasicNeeds" -> "BasicNeedsOptionWrongValue"]
		,
		$Failed
		,
		{BeginTestEnvironment::unknownOptionValue}
		,
		TestID -> "\"BasicNeeds\" option wrong value: \
$Failed returned, \
warning messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "\"BasicNeeds\" option wrong value: \
$TestEnvironments remained an empty list."
	];
	
	
	Test[
		$Context
		,
		"TestEnvironment`TestEnvironment`BeginTestEnvironment`"
		,
		TestID -> "\"BasicNeeds\" option wrong value: \
Active context was not changed."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "\"BasicNeeds\" option wrong value: \
$ContextPath was not changed."
	];
	
	
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "\"BasicNeeds\" option wrong value: \
no options were saved."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*Wrong syntax*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	TestMatch[
		BeginTestEnvironment[{}, "someString"]
		,
		HoldPattern[BeginTestEnvironment[{}, "someString"]]
		,
		{BeginTestEnvironment::wrongSyntax}
		,
		TestID -> "Wrong syntax: \
unevaluated form returned, \
warning messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "Wrong syntax: \
$TestEnvironments remained an empty list."
	];
	
	
	Test[
		$Context
		,
		"TestEnvironment`TestEnvironment`BeginTestEnvironment`"
		,
		TestID -> "Wrong syntax: \
Active context was not changed."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "Wrong syntax: \
$ContextPath was not changed."
	];
	
	
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "Wrong syntax: \
no options were saved."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*String not representing valid context*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	TestMatch[
		BeginTestEnvironment["non-context"]
		,
		$Failed
		,
		{BeginPackage::cxt}
		,
		TestID -> "non-context string as first arg: \
$Failed returned, \
warning messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "non-context string as first arg: \
$TestEnvironments remained an empty list."
	];
	
	
	Test[
		$Context
		,
		"TestEnvironment`TestEnvironment`BeginTestEnvironment`"
		,
		TestID -> "non-context string as first arg: \
Active context was not changed."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "non-context string as first arg: \
$ContextPath was not changed."
	];
	
	
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "non-context string as first arg: \
no options were saved."
	];
	
	
	TearDown[];
];


(* ::Subsection:: *)
(*List with string not representing valid context*)


Block[
	{
		$Context = original$Context,
		$ContextPath = original$ContextPath,
		$Packages = original$Packages
		,
		MUnitExtras`TestEnvironment`Private`$TestEnvironments = {}
		,
		OptionsUtilities`Private`$SavedOptions = {}
	}
	,
	
	
	TestMatch[
		BeginTestEnvironment[{"non-context"}]
		,
		$Failed
		,
		{BeginPackage::cxls}
		,
		TestID -> "non-context string in list: \
$Failed returned, \
warning messages generated"
	];
	Test[
		MUnitExtras`TestEnvironment`Private`$TestEnvironments
		,
		{}
		,
		TestID -> "non-context string in list: \
$TestEnvironments remained an empty list."
	];
	
	
	Test[
		$Context
		,
		"TestEnvironment`TestEnvironment`BeginTestEnvironment`"
		,
		TestID -> "non-context string in list: \
Active context was not changed."
	];
	Test[
		$ContextPath
		,
		original$ContextPath
		,
		TestID -> "Wrong syntax: \
$ContextPath was not changed."
	];
	
	
	Test[
		OptionsUtilities`Private`$SavedOptions
		,
		{}
		,
		TestID -> "non-context string in list: \
no options were saved."
	];
	
	
	TearDown[];
];


(* ::Section:: *)
(*TearDown*)


(* Remove all symbols defined in current context and in mock package. *)
Unprotect["`*", "MyPackage`*"];
Quiet[Remove["`*", "MyPackage`*"], {Remove::rmnsm}];


End[];
