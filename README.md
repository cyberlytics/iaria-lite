
# iaria-lite – Write documents for the IARIA publications

This repository hosts the source code for the [CTAN](https://ctan.org/) package [IARIA-lite](https://ctan.org/pkg/iaria-lite).


This package provides a convenient environment for writing IARIA (International Academy, Research, and Industry Association) scholary publications.

It does not implement the specifications for the IARIA citation style, for which you have to use the iaria class.


DISCLAIMER: If your are using biblatex/biber, it is recommended to use [CTAN](https://ctan.org/) package [IARIA](https://ctan.org/pkg/iaria).

If you just want to extend you LaTeX installation please download the [iaria-lite package from CTAN](https://ctan.org/pkg/iaria-lite) and follow the installation instructions.

If you want to extend the package please follow this guideline.

## Building the package

To build the package from source clone this repository:

```bash
$ git clone https://github.com/cyberlytics/iaria-lite.git
```

and run `make`:

```bash
$ make dist
```

This will create the zip file `dist/iaria-lite.zip` with the complete installation package as it can be downloaded from CTAN.

All build artifacts without the archive itself can be build with:

```bash
$ make compile
```

The repository can be cleaned up with:

```bash
$ make clean
```

## The source files

* `dependencies/` contains third party tools that are needed for compilation
* `doc/iaria-lite.tex` The user documentation of the iaria-lite class
* `patch/` Files needed for patching generated artifacts
* `src/iaria-lite.cls` The LaTeX class of the package
* `static` All files that will be added unchanged to the CTAN package like `README` and template sources

## Build artifacts

All build artifacts can be found in `build`. The `Makefile` builds the following artifacts:

* `iaria-lite.ins` and `iaria-lite.dtx` which contains the LaTeX installation package and the documentation source.
* `iaria-lite.pdf` the documentation of the class
* `*-example-*.zip` include TEX+PDF example based on this class

## Build dependencies

The build environment needs the following Unix tools to be installed:

* GNU make
* LaTeX (inclduding `latexmk`)
* perl
* Unix commandline: bash, echo, cp, mv, rm, ed, cut, mkdir, head

## Contact

* [Christoph P. Neumann <cyberpetaneuron@gmail.com>](mailto:cyberpetaneuron+iarialite@gmail.com)