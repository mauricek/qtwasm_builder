@echo off
rem setlocal

set SOURCEPATH=%~dpnx1

IF NOT EXIST "%SOURCEPATH%" (
  set SOURCEPATH=%cd%
  echo Assuming current directory as root
)

echo Verify latest build env
docker pull netresearch/node-webserver:latest

echo Invoke Docker run, Source: %SOURCEPATH%
docker run --rm -p 8090:8080 -v %SOURCEPATH%:/app/public:ro netresearch/node-webserver

GOTO End

:Usage
echo Usage: dqwr root-dir

:End
