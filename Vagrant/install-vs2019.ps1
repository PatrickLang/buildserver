
# Used for dealing with multiple VS install locations & versions in build_environment.bat
choco install vswhere

if (-Not (Test-Path -Path (vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath))) {
    Write-Host "Missing Visual Studio, so installing it"
    if ((Get-PSDrive C).Free -lt 90Gb) {
        Write-Error "Not enough free space to install Visual Studio tools"
        exit 1
    }

    if ((Test-Path c:\vsinstall) -eq $false) {
        mkdir c:\vsinstall

        cd \vsinstall
        # Download the build tools log collector
        curl.exe -Lo vscollect.exe https://aka.ms/vscollect.exe

        # Download the Build Tools bootstrapper.
        curl.exe -Lo vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe 

        # Install Build Tools excluding workloads and components with known issues.
        $vsArgs =  "--quiet",  "--wait", "--norestart", "--nocache", `
            "--installPath C:\BuildTools", `
            "--all", `
            "--add Microsoft.VisualStudio.Workload.VCTools", `
            "--add Microsoft.VisualStudio.Component.VC.v141.x86.x64", `
            "--includeRecommended", `
            "--remove Microsoft.VisualStudio.Component.Windows10SDK.10240", `
            "--remove Microsoft.VisualStudio.Component.Windows10SDK.10586", `
            "--remove Microsoft.VisualStudio.Component.Windows10SDK.14393", `
            "--remove Microsoft.VisualStudio.Component.Windows81SDK"
        Write-Host $vsArgs
        Start-Process -NoNewWindow -Wait .\vs_buildtools.exe -Args $vsArgs
    }
}