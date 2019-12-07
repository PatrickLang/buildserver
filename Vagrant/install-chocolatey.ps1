if ((Get-Command choco.exe -ErrorAction Ignore) -eq $null) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}