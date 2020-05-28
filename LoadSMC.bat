@echo off
pushd %~dp0
setlocal

rem Configure a Synergy environment
rem call "%SYNERGYDE32%dbl\dblvars32.bat"
call "%SYNERGYDE64%dbl\dblvars64.bat"

set XFPL_SMCPATH=.\SMC\

rem Delete any existing file to make sure we get a new one
if exist "%XFPL_SMCPATH%smc.xml" del /q "%XFPL_SMCPATH%smc.xml"

rem Generate a new SMC XML file from our method sources
echo Processing source files...
dbl2xml .\xfplMethods\*.dbl -out "%XFPL_SMCPATH%smc.xml"
if ERRORLEVEL 1 goto parse_fail

rem Load the XML file into the SMC
echo Loading method catalog...
dbs DBLDIR:mdu -u "%XFPL_SMCPATH%smc.xml"
if ERRORLEVEL 1 goto load_fail
echo Method catalog was loaded

rem Unload the SMCback to an XML file
echo Unloading method catalog...
dbs DBLDIR:mdu -e "%XFPL_SMCPATH%smc.xml"
if ERRORLEVEL 1 goto load_fail

goto done

:parse_fail
echo ERROR: Failed to extract SMC data from code
goto done

:load_fail
echo ERROR: Failed to load method catalog
goto done

:unload_fail
echo ERROR: Failed to unload method catalog
goto done

:done
endlocal
popd