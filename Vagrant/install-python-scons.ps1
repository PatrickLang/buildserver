# This is a shortcut for now. If chocolatey packages are removed / change versions, things could break.
choco install -y python2

if ((Get-Command pip -ErrorAction Ignore) -eq $null) {
    # TODO best to pin this to a specific version
    curl.exe https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
}

pip install --no-cache-dir virtualenv
pip install scons