


cmake -S googletest -Wno-dev -B _build -DCMAKE_INSTALL_PREFIX=_install -DCMAKE_BUILD_TYPE="Debug;RelWithDebInfo" -DCMAKE_CXX_COMPILER="cl.exe" -DCMAKE_C_COMPILER="cl.exe" -DMSVC_TOOLSET_VERSION=142 -D BUILD_GMOCK=TRUE -DBUILD_SHARED_LIBS=TRUE -DINSTALL_GTEST=TRUE -G Ninja

$vswherePath="${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

$installDir = & $vswherePath -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath

$vcvarallPath = join-path $installDir 'VC\Auxiliary\Build\vcvarsall.bat'

if(!(test-path $vcvarallPath)) {
  exit /b 2
}

cmd.exe /c " `"$vcvarallPath`" x64 && set" | foreach {
  # if the line is a session variable
  if( $_ -match "=" )
  {
    $pair = $_.split("=");
    # Set the environment variable for the current PowerShell session
    Set-Item -Force -Path "ENV:\$($pair[0])" -Value "$($pair[1])"
  }
}

cmake -S benchmark -Wno-dev -B _build -DCMAKE_INSTALL_PREFIX=_install -DBENCHMARK_ENABLE_GTEST_TESTS=FALSE -DBENCHMARK_ENABLE_TESTING=FALSE -DCMAKE_BUILD_TYPE="RelWithDebInfo" -DBUILD_SHARED_LIBS=TRUE -DMSVC_TOOLSET_VERSION=142 -G Ninja         
cmake --build ./_build --config "RelWithDebInfo" --clean-first
cmake --install ./_build --config "RelWithDebInfo"

# Get-ChildItem -Recurse -Depth 1
