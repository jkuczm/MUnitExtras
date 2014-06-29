(* ::Package:: *)

Get["https://raw.githubusercontent.com/jkuczm/MathematicaBootstrapInstaller/v0.1.0/BootstrapInstaller.m"]


BootstrapInstall[
	"MUnitExtras",
	"https://github.com/jkuczm/MUnitExtras/releases/download/v0.1.1/MUnitExtras.zip"
	,
	{
		#1
		,
		"https://github.com/jkuczm/Mathematica" <> #1 <>
		"/releases/download/v" <> #2 <> "/" <> #1 <> ".zip"
	}& @@@ {
		"EvaluationUtilities" -> "0.1.0",
		"MessagesUtilities" -> "0.1.0",
		"OptionsUtilities" -> "0.1.0",
		"PatternUtilities" -> "0.1.0",
		"ProtectionUtilities" -> "0.1.0",
		"StringUtilities" -> "0.1.0"
	}
	,
	"AdditionalFailureMessage" -> 
		Sequence[
			"You can ", 
			Hyperlink[
				"install MUnitExtras package manually", 
				"https://github.com/jkuczm/MUnitExtras#manual-installation"
			],
			"."
		]
]
