REM Usage: build_environment.bat x86 Release
set MACHINE_X86="%1" == "x86"
set CONFIG_RELEASE="%2" == "Release"

if %MACHINE_X86% (
  echo Building for x86.
  set MACHINE_X=x86
) else (
  echo Building for x64.
  set MACHINE_X=x64
)

if %CONFIG_RELEASE% (
  echo Building release mode.
) else (
  echo Building debug mode.  
)

SET MSBUILD=msbuild /p:VCTargetsPath="C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\V120\\"
set ROOT_DIR=%CD%
SET LIB_DIR=%CD%\lib\
SET INCLUDE_DIR=%CD%\include\
SET BUILD_DIR=%CD%\build\

if %MACHINE_X86% (
  call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
) else (
  call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
)

call build_zlib.bat 
call build_pthreads.bat
call build_protobuf.bat
call build_portmidi.bat
call build_libid3tag.bat
call build_libmad.bat
call build_libogg.bat
call build_libvorbis.bat
call build_libshout.bat
call build_libflac.bat
call build_libsndfile.bat
