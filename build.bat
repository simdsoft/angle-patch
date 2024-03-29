:: ----------- default is angle default optimize flags is /O1 on windows
@echo off
chcp 65001
rem ---------- setup env
set programdir=%ProgramFiles%

call "%programdir%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

rem --- 1. angle_enable_vulkan=false
rem --- 2. dynamic crt MD (angle\build\config\win\BUILD.gn)
pushd angle
rem git pull
rem gclient sync -D

rem This tells depot_tools to use your locally installed version of Visual Studio (by default, depot_tools will try to use a google-internal version).
set DEPOT_TOOLS_WIN_TOOLCHAIN=0

call gn gen out/release --sln=angle-release --ide=vs2022 "--args=is_debug=false is_clang=false target_cpu=\"x64\" treat_warnings_as_errors=false angle_enable_vulkan=false angle_enable_gl=false use_msvcr14x=false"
REM call devenv out\release\angle-release.sln /build "GN|Win32" /Project libEGL
call autoninja -C out\release libEGL
popd

