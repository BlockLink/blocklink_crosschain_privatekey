 @echo off
set GRA_ROOT=E:\blocklink_project
set BOOST_ROOT=%GRA_ROOT%\boost_1_57_0


set PATH=%GRA_ROOT%\CMake\bin;%BOOST_ROOT%\lib;%PATH%

echo Setting up VS2013 environment...
call "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64