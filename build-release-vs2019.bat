:: ----------- default is angle default optimize flags is /O1 on windows
@echo off
rem ---------- setup env
set programdir=%ProgramFiles%
if exist "%ProgramFiles% (x86)" set programdir=%programdir% (x86)
call "%programdir%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86

rem --- 1. angle_enable_vulkan=false
rem --- 2. dynamic crt MD (angle\build\config\win\BUILD.gn)
pushd angle
call gn gen out/release --sln=angle-release --ide=vs2019 "--args=is_debug=false is_clang=false target_cpu=\"x86\" treat_warnings_as_errors=false angle_enable_vulkan=false"
call devenv out\release\angle-release.sln /rebuild "GN|Win32" /Project libEGL
popd

