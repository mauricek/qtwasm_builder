@echo off
rem setlocal
IF "%~1" == "" GOTO InvalidInput

set SOURCEPATH=%~dpnx1
set BUILDPATH=%~dpnx2
IF NOT EXIST "%SOURCEPATH%" (
  echo "%SOURCEPATH%" does not exist.
  GOTO Usage
)
IF NOT EXIST "%BUILDPATH%" (
  set BUILDPATH=%cd%
  echo "Assuming pwd": %BUILDPATH%
)

echo Verify latest build env
docker pull maukalinow/qtwasm_builder:latest

echo Invoke Docker build, Source: %SOURCEPATH%, Build: %BUILDPATH%
docker run --rm -v %SOURCEPATH%:/project/source -v %BUILDPATH%:/project/build maukalinow/qtwasm_builder:latest

GOTO End

:InvalidInput
echo Not sufficient arguments.
GOTO Usage

:Usage
echo Usage: dqwm source-dir build-dir

:End
