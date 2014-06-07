(* Mathematica Test File *)

(* ::Section:: *)
(*SetUp*)


Begin["BeginEndTestEnvironment`"];


Needs["MUnitExtras`TestEnvironment`"];


Needs["OptionsUtilities`"]; (* SaveOptions *)


BeginEndTestEnvironment`func1OptDefault =
	{"func1Opt" -> "func1OptValueDefault"};
BeginEndTestEnvironment`func1Opt1 = {"func1Opt" -> "func1OptValue1"};
BeginEndTestEnvironment`func1Opt2 = {"func1Opt" -> "func1OptValue2"};


(* ::Section:: *)
(*Package definitions*)


(* Start first package. *)
BeginPackage["MyPackage1`"];


(* Define public function with options in first package *)
Options[func1] = BeginEndTestEnvironment`func1OptDefault;
func1[] = "func1ReturnedValue";


(* End first package. *)
EndPackage[];


(* Start second package. *)
BeginPackage["MyPackage2`"];


(* Define public symbol in second package *)
sym2 = "sym2Value"


(* End second package. *)
EndPackage[];


Test[
	func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "After package definitions \
symbol from first package is available by name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "After package definitions \
symbol from second package is available by name."
];


(*****************************************************************************)


(* ::Section:: *)
(*Unit tests for first package*)


(* Start unit tests for first package. *)
BeginEndTestEnvironment`myPackage1TestEnvData =
	BeginTestEnvironment[{"MyPackage1`"}];

(* Define symbol in first test environment. *)
testSym1 = "testSym1Value"


Test[
	func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "Inside test environment for first package \
symbol from first package is available by name."
];


Test[
	Names["sym2"]
	,
	{}
	,
	TestID -> "Inside test environment for first package \
symbol from second package is not available by name."
];
Test[
	MyPackage2`sym2
	,
	"sym2Value"
	,
	TestID -> "Inside test environment for first package \
symbol from second package is available by context`name."
];


Test[
	testSym1
	,
	"testSym1Value"
	,
	TestID -> "Inside test environment for first package \
symbol from first test environment is available by name."
];

(* Set new options for function from first package. *)
SetOptions[func1, BeginEndTestEnvironment`func1Opt1]


Test[
	Options[func1]
	,
	BeginEndTestEnvironment`func1Opt1
	,
	TestID -> "Inside test environment for first package \
function from first package has new option values."
];


(* End unit tests for first package. *)
Test[
	EndTestEnvironment[]
	,
	BeginEndTestEnvironment`myPackage1TestEnvData
	,
	TestID -> "Ending unit tests for first package returns same data as \
begining unit tests for first package."
];


BeginEndTestEnvironment`myPackage1TestEnvContext =
	First[BeginEndTestEnvironment`myPackage1TestEnvData];


(*****************************************************************************)


(* ::Section:: *)
(*After unit tests for first package*)


Test[
	func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "After ending test environment for first package \
symbol from first package is available by name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "After ending test environment for first package \
symbol from second package is available by name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "After ending test environment for first package \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "After ending test environment for first package \
symbol from first test environment is not available by context`name."
];


Test[
	Options[func1]
	,
	BeginEndTestEnvironment`func1OptDefault
	,
	TestID -> "After ending test environment for first package \
function from first package has default option values again."
];


(*****************************************************************************)


(* ::Section:: *)
(*Unit tests for second package*)


(* Start unit tests for second package with given context name. *)
TestMatch[
	BeginEndTestEnvironment`myPackage2TestEnvData =
		BeginTestEnvironment["UnitTests`MyPackage2`", {"MyPackage2`"}]
	,
	"UnitTests`MyPackage2`" -> _Symbol
	,
	TestID -> "Begining unit tests for second package returns given context \
name."
];


(* Define symbol in second test environment. *)
testSym2 = "testSym2Value"


Test[
	Names["func1"]
	,
	{}
	,
	TestID -> "Inside test environment for second package \
symbol from first package is not available by name."
];
Test[
	MyPackage1`func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "Inside test environment for second package \
symbol from first package is available by context`name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "Inside test environment for second package \
symbol from second package is available by name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "Inside test environment for second package \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "Inside test environment for second package \
symbol from first test environment is not available by context`name."
];


Test[
	testSym2
	,
	"testSym2Value"
	,
	TestID -> "Inside test environment for second package \
symbol from second test environment is available by name."
];


(* Save options for function from first package with identifier used by this
	test environment. *)
OptionsUtilities`SaveOptions[
	MyPackage1`func1,
	"UniqueIdentifier" -> Last[BeginEndTestEnvironment`myPackage2TestEnvData]
]


(* Set new options for function from first package. *)
SetOptions[MyPackage1`func1, BeginEndTestEnvironment`func1Opt2]


Test[
	Options[MyPackage1`func1]
	,
	BeginEndTestEnvironment`func1Opt2
	,
	TestID -> "Inside test environment for second package \
function from first package has new option values."
];


(* End unit tests for second package but don't remove symbols. *)
Test[
	EndTestEnvironment["RemoveSymbols" -> False]
	,
	BeginEndTestEnvironment`myPackage2TestEnvData
	,
	TestID -> "Ending unit tests for second package returns same data as \
begining of unit tests for second package."
];


(*****************************************************************************)


(* ::Section:: *)
(*After unit tests for second package*)


Test[
	func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "After ending test environment for second package \
symbol from first package is available by name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "After ending test environment for second package \
symbol from second package is available by name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "After ending test environment for second package \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "After ending test environment for second package \
symbol from first test environment is not available by context`name."
];


Test[
	Names["testSym2"]
	,
	{}
	,
	TestID -> "After ending test environment for second package \
symbol from second test environment is not available by name."
];
Test[
	UnitTests`MyPackage2`testSym2
	,
	"testSym2Value"
	,
	TestID -> "After ending test environment for second package \
symbol from second test environment is available by context`name."
];


Test[
	Options[func1]
	,
	BeginEndTestEnvironment`func1OptDefault
	,
	TestID -> "After ending test environment for second package \
function from first package has default option values again."
];


(*****************************************************************************)


(* ::Section:: *)
(*Unit tests unrelated to two defined packages*)


(* Start unit tests unrelated to two defined packages. *)
BeginEndTestEnvironment`unrelatedTestEnvData = BeginTestEnvironment[];


(* Define symbol in "unrelated" test environment. *)
testSymUnrelated = "testSymUnrelatedValue"


Test[
	Names["func1"]
	,
	{}
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from first package is not available by name."
];
Test[
	MyPackage1`func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from first package is available by context`name."
];


Test[
	Names["sym2"]
	,
	{}
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from second package is not available by name."
];
Test[
	MyPackage2`sym2
	,
	"sym2Value"
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from second package is available by context`name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from first test environment is not available by context`name."
];


Test[
	Names["testSym2"]
	,
	{}
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from second test environment is not available by name."
];
Test[
	UnitTests`MyPackage2`testSym2
	,
	"testSym2Value"
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from second test environment is available by context`name."
];


Test[
	testSymUnrelated
	,
	"testSymUnrelatedValue"
	,
	TestID -> "Inside \"unrelated\" test environment \
symbol from \"unrelated\" test environment is available by name."
];


(* End \"unrelated\" unit tests. *)
Test[
	EndTestEnvironment[]
	,
	BeginEndTestEnvironment`unrelatedTestEnvData
	,
	TestID -> "Ending \"unrelated\" unit tests returns same data as begining \
\"unrelated\" unit tests."
];


BeginEndTestEnvironment`unrelatedTestEnvContext =
	First[BeginEndTestEnvironment`unrelatedTestEnvData];


(*****************************************************************************)


(* ::Section:: *)
(*After unit tests unrelated to two defined packages*)


Test[
	func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from first package is available by name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from second package is available by name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from first test environment is not available by context`name."
];


Test[
	Names["testSym2"]
	,
	{}
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from second test environment is not available by name."
];
Test[
	UnitTests`MyPackage2`testSym2
	,
	"testSym2Value"
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from second test environment is available by context`name."
];


Test[
	Names["testSymUnrelated"]
	,
	{}
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from \"unrelated\" test environment is not available by name."
];
Test[
	Names[
		BeginEndTestEnvironment`unrelatedTestEnvContext <> "testSymUnrelated"
	]
	,
	{}
	,
	TestID -> "After ending \"unrelated\" test environment \
symbol from \"unrelated\" test environment is not available by context`name."
];


(*****************************************************************************)


(* ::Section:: *)
(*Unit tests for second package (second set)*)


(* Start unit tests for second package again, with same context name. *)
TestMatch[
	BeginEndTestEnvironment`myPackage2TestEnv2Data =
		BeginTestEnvironment["UnitTests`MyPackage2`", {"MyPackage2`"}]
	,
	"UnitTests`MyPackage2`" -> _Symbol
	,
	TestID -> "Begining unit tests for second package again returns given \
context name."
];


(* Define symbol in second test environment for second package. *)
testSym2Another = "testSym2AnotherValue"


Test[
	Names["func1"]
	,
	{}
	,
	TestID -> "Inside second test environment for second package \
symbol from first package is not available by name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "Inside second test environment for second package \
symbol from second package is available by name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "Inside second test environment for second package \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "Inside second test environment for second package \
symbol from first test environment is not available by context`name."
];


Test[
	testSym2
	,
	"testSym2Value"
	,
	TestID -> "Inside second test environment for second package \
symbol from second test environment is available by name."
];


Test[
	Names["testSymUnrelated"]
	,
	{}
	,
	TestID -> "Inside second test environment for second package \
symbol from \"unrelated\" test environment is not available by name."
];
Test[
	Names[
		BeginEndTestEnvironment`unrelatedTestEnvContext <> "testSymUnrelated"
	]
	,
	{}
	,
	TestID -> "Inside second test environment for second package \
symbol from \"unrelated\" test environment is not available by context`name."
];


Test[
	testSym2Another
	,
	"testSym2AnotherValue"
	,
	TestID -> "Inside second test environment for second package \
symbol from second test environment for second package is available by name."
];


(* End second test environment for second package. *)
Test[
	EndTestEnvironment[]
	,
	BeginEndTestEnvironment`myPackage2TestEnv2Data
	,
	TestID -> "Ending second test environment for second package returns same \
data that was returned by begining of second test environment for second \
package."
];


(*****************************************************************************)


(* ::Section:: *)
(*After unit tests for second package (second set)*)


Test[
	func1[]
	,
	"func1ReturnedValue"
	,
	TestID -> "After ending second test environment for second package \
symbol from first package is available by name."
];


Test[
	sym2
	,
	"sym2Value"
	,
	TestID -> "After ending second test environment for second package \
symbol from second package is available by name."
];


Test[
	Names["testSym1"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from first test environment is not available by name."
];
Test[
	Names[BeginEndTestEnvironment`myPackage1TestEnvContext <> "testSym1"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from first test environment is not available by context`name."
];


Test[
	Names["testSym2"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from second test environment is not available by name."
];
Test[
	Names["UnitTests`MyPackage2`testSym2"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from second test environment is not available by context`name."
];


Test[
	Names["testSymUnrelated"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from \"unrelated\" test environment is not available by name."
];
Test[
	Names[
		BeginEndTestEnvironment`unrelatedTestEnvContext <> "testSymUnrelated"
	]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from \"unrelated\" test environment is not available by context`name."
];


Test[
	Names["testSym2Another"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from second test environment for second package is available by name."
];
Test[
	Names["UnitTests`MyPackage2`testSym2Another"]
	,
	{}
	,
	TestID -> "After ending second test environment for second package \
symbol from second test environment for second package is not available by \
context`name."
];


(*****************************************************************************)


(* ::Section:: *)
(*Tear down*)


(* Remove all symbols defined in current context and in test packages. *)
Unprotect["`*", "MyPackage1`*", "MyPackage2`*"];
Quiet[Remove["`*", "MyPackage1`*", "MyPackage2`*"], {Remove::rmnsm}];


End[];
