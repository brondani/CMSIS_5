# Compose and build projects with CMSIS Build

[CMSIS Build](https://arm-software.github.io/CMSIS_5/Build/html/index.html) takes as input an embedded project described in the [CPRJ format](https://arm-software.github.io/CMSIS_5/Build/html/cprjFormat_pg.html), generates build instructions (CMakeLists) that are used together with a chosen toolchain to compile source modules, producing a library or linking them into an executable.

This demo shows how to use CMSIS Build to compose projects from layers, iteratively generating project descriptions (CPRJ) and finally building them.

## Getting Started

### 1) Download CMSIS-Build installer (dev version 0.0.0+g9e8126a)

- [Linux/Windows 64/macOS](https://github.com/brondani/CMSIS_5/tree/dsp-examples/CMSIS/DSP/Layers/installer/cbuild_install.sh)

### 2) Toolchain download options

- [Keil MDK IDE](http://www.keil.com/mdk5)

  Version 5.35 (Jun 2021) is the latest version of MDK supporting the CMSIS-Project file format (*.cprj) export and import including export of layer information.

  [Installation Guide](http://www2.keil.com/mdk5/install)

  - Install [MDK](http://www2.keil.com/demo/eval/arm.htm) first.
  - In cbuild_install.sh specify the MDK installation compiler path (c:\Keil_v5\ARM\ARMClang\bin) to setup AC6 compiler for you.

- [GNU Arm Embedded Toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads):

  Version 10-2020-q4-major (Dec. 11th 2020):
  - [Windows 32-bit ZIP](https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-win32.exe)
  - [Linux x86_64 Tarball](https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2)
  - [Mac OS X 64-bit Package](https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-mac.pkg)

- [ARM Compiler Version 6](https://developer.arm.com/tools-and-software/embedded/arm-compiler/downloads/version-6) **license managed**:

  Version 6.16 (Mar. 10th 2020)
  - [Windows 32-bit Installer](https://developer.arm.com/-/media/Files/downloads/compiler/DS500-BN-00025-r5p0-18rel0.zip)

    - Download installer
    - Extract archive unzip DS500-BN-00025-r5p0-18rel0.zip
    - Run win-x86_32\setup.exe
    - Default installation path: C:\Program Files (x86)\ARMCompiler6.16\

  - [Linux x86_64 Installer](https://developer.arm.com/-/media/Files/downloads/compiler/DS500-BN-00026-r5p0-18rel0.tgz)
    - Download installer
    - Extract the archive tar -xzf DS500-BN-00026-r5p0-18rel0.tgz
    - Run install_x86_64.sh

### 3) CMake installation

- [Download](https://cmake.org/download) and install CMake 3.18.0 or higher, as well as [GNU Make](https://www.gnu.org/software/make/) or [Ninja](https://ninja-build.org/).

### 4) CMSIS-Build Installation instructions

- [Setup build environment](https://arm-software.github.io/CMSIS_5/Build/html/cbuild_install.html)\
       Note: CMSIS-Build tools require at least one of the above toolchains.

### 5) Documentation

- [Overview](https://arm-software.github.io/CMSIS_5/Build/html/index.html)

## Layers

In this demo two categories of layers were created (`Application` and `Device`) for two toolchains (`AC6` and `GCC`).
The layers description files have the extension `.clayer`, they were manually written and can be found in the [layers](layers) folder.
The layers contents contain sources, headers and linker descriptors that were copied from `Platforms` and `Examples` folders with the script [copy_layer_files.sh](copy_layer_files.sh) and the list [FilesList.txt](FilesList.txt).
```
./copy_layer_files.sh FilesList.txt
```
| List of Device layers
|:--------------------------
| ARMCM0.AC6
| ARMCM0.GCC
| ARMCM4.AC6
| ARMCM4.GCC
| ARMCM7.AC6
| ARMCM7.GCC

| List of Application layers
|:--------------------------
| arm_variance_example
| arm_svm_example
| arm_sin_cos_example
| arm_signal_converge_example
| arm_matrix_example

## Generate and build
After having followed the [Getting Started](#getting-started) section and cloned this repository, run the following commands to generate CPRJs and build the generated projects:
```
source <path><to><cbuild>/etc/setup
./gen_and_build.sh
```
The [gen_and_build.sh](gen_and_build.sh) script just calls the following scripts:

### Generate CPRJs

Calling the script [gen_proj_list.sh](gen_proj_list.sh) will generate projects in the [projects](projects) folder with all possible combinations of Application and Device layers as in the [ProjectList.txt](ProjectList.txt).
```
./gen_proj_list.sh ProjectList.txt
```

### Build projects
Calling the script [build_proj_list.sh](build_proj_list.sh) will build all projects in the [BuildList.txt](BuildList.txt). 
```
./build_proj_list.sh BuildList.txt
```