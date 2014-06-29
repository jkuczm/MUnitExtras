# MUnit Extras

[![latest release](http://img.shields.io/github/release/jkuczm/MUnitExtras.svg)](https://github.com/jkuczm/MUnitExtras/releases/latest)
[![Semantic Versioning](http://jkuczm.github.io/media/images/SemVer-2.0.0-brightgreen.svg)](http://semver.org/spec/v2.0.0.html)
[![license MIT](http://jkuczm.github.io/media/images/license-MIT-blue.svg)](https://github.com/jkuczm/MUnitExtras/blob/master/LICENSE)

* [Features](#features)
* [Requirements](#requirements)
* [Installation](#installation)
    * [Automatic installation](#automatic-installation)
    * [Manual installation](#manual-installation)
* [Documentation](#documentation)
* [Bugs and requests](#bugs-and-requests)
* [Contributing](#contributing)
* [License](#license)
* [Versioning](#versioning)



## Features

* Functions creating isolated test environments.
* Tools simplifying creation of custom tests.
* Tools for creation of reusable test cases (collections of tests).
* Customizable automatic failure messages.
* 11 new specialized test functions and 4 test case functions.



## Requirements

* Mathematica version 8+

* MUnit version 1.3.0
  
  This package contains some dirty monkey patches compatible with MUnit
  version 1.3.0 that is distributed with version 2.0.138 of Wolfram Workbench
  (which is newest version available at
  http://workbench.wolfram.com/update as Eclipse plugin).



## Installation

### Automatic installation

To install MUnitExtras package evaluate:
```Mathematica
Get["https://raw.githubusercontent.com/jkuczm/MUnitExtras/master/BootstrapInstall.m"]
```

Note that this will also install dependencies:
[EvaluationUtilities](https://github.com/jkuczm/MathematicaEvaluationUtilities),
[MessagesUtilities](https://github.com/jkuczm/MathematicaMessagesUtilities),
[OptionsUtilities](https://github.com/jkuczm/MathematicaOptionsUtilities),
[PatternUtilities](https://github.com/jkuczm/MathematicaPatternUtilities),
[ProtectionUtilities](https://github.com/jkuczm/MathematicaProtectionUtilities),
[StringUtilities](https://github.com/jkuczm/MathematicaStringUtilities) and
[ProjectInstaller](https://github.com/lshifr/ProjectInstaller) package, if you
don't have it already installed.


### Manual installation

1. Download latest released
   [MUnitExtras.zip](https://github.com/jkuczm/MUnitExtras/releases/download/v0.1.1/MUnitExtras.zip)
   file.

2. Extract downloaded `MUnitExtras.zip` to any directory which is on
   Mathematica `$Path`, e.g. to one obtained by evaluating
   `FileNameJoin[{$UserBaseDirectory,"Applications"}]`.


3. Install dependencies:
[EvaluationUtilities](https://github.com/jkuczm/MathematicaEvaluationUtilities),
[MessagesUtilities](https://github.com/jkuczm/MathematicaMessagesUtilities),
[OptionsUtilities](https://github.com/jkuczm/MathematicaOptionsUtilities),
[PatternUtilities](https://github.com/jkuczm/MathematicaPatternUtilities),
[ProtectionUtilities](https://github.com/jkuczm/MathematicaProtectionUtilities),
[StringUtilities](https://github.com/jkuczm/MathematicaStringUtilities)



## Initialization

To load MUnitExtras in `*.mt` file run with
[Workbenchs test runner](http://reference.wolfram.com/workbench/index.jsp?topic=/com.wolfram.eclipse.help/html/tasks/documentationpaclets/index.html)
add ``Needs["MUnitExtras`"]`` to the file.

To use MUnitExtras outside of Workbenchs test runner, you must find MUnit
package in your Workbench installation directory and add its location to
Mathematica `$Path`:
```Mathematica
$Path =
    DeleteDuplicates @ Join[
        FileNameJoin[{"/path/to/eclipse/configuration/org.eclipse.osgi/bundles/497/1/.cp", #}]& /@ {
            "MathematicaSource", 
            "MathematicaSourceVersioned/Head"
        }
        ,
        $Path
    ];

Needs["MUnitExtras`"]
```
(change
`/path/to/eclipse/configuration/org.eclipse.osgi/bundles/497/1/.cp`
to location of MUnit on your system).


## Documentation

Real documentation is currently non-existent, except for usage messages.

`*.mt` files in `Usage` directory are supposed to be a lame substitute.
Look also at acceptance and unit tests for more usage examples.



## Bugs and requests

If you find any bugs or have feature request please create an
[issue on GitHub](https://github.com/jkuczm/MUnitExtras/issues).



## Contributing

Feel free to fork and send pull requests.

If you want to use Ant scripts from this repository you will also need to
install [WWBCommon](https://github.com/jkuczm/WWBCommon) project.

All contributions are welcome!



## License

This package is released under
[The MIT License](https://github.com/jkuczm/MUnitExtras/blob/master/LICENSE).



## Versioning

Releases of this package will be numbered using
[Semantic Versioning guidelines](http://semver.org/).
