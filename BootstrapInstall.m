(* ::Package:: *)

Module[
	{$PIImportResult}
	,
	
	Quiet[
		$PIImportResult = Needs["ProjectInstaller`"],
		{Get::noopen, Needs::nocont}
	];
	
	If[$PIImportResult === $Failed,
		Print["ProjectInstaller not found, installing it:"];
		Print @ Import[
			"https://raw.github.com/lshifr/ProjectInstaller/master/BootstrapInstall.m"
		];
		$PIImportResult = Needs["ProjectInstaller`"];
	];

	If[$PIImportResult === $Failed,
		Print[
			"Unable to load ProjectInstaller.\n",
			"Please ",
			Hyperlink[
				"install MUnitExtras package manually",
				"https://github.com/jkuczm/MUnitExtras#manual-installation"
			],
			".\n",
			"We would be grateful for ",
			Hyperlink[
				"reporting this issue",
				"https://github.com/jkuczm/MUnitExtras/issues"
			],
			"."
		];
	(* else *),
		Print["Installing dependencies:"];
		(Print @ ProjectInstaller`ProjectInstall @ URL[
			"https://github.com/jkuczm/Mathematica" <> #1 <>
			"/releases/download/v" <> #2 <> "/" <> #1 <> ".zip"
		])& @@@ {
			"EvaluationUtilities" -> "0.1.0",
			"MessagesUtilities" -> "0.1.0",
			"OptionsUtilities" -> "0.1.0",
			"PatternUtilities" -> "0.1.0",
			"ProtectionUtilities" -> "0.1.0",
			"StringUtilities" -> "0.1.0"
		};
		
		Print["Installing MUnitExtras:"];
		Print @ ProjectInstaller`ProjectInstall @ URL[
			"https://github.com/jkuczm/MUnitExtras/releases/download/v0.1.0/MUnitExtras.zip"
		];
	];
]
