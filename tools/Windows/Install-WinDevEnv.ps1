Set-Location $PSScriptRoot

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force

#Get Python Latest Version
$pythonRegexLatestUri = '<a href=".+">Latest Python 3 Release - Python \d+\.\d+\.\d+<\/a>'

$results = Invoke-WebRequest -Uri https://www.python.org/downloads/windows/ 
$results.Content -match $pythonRegexLatestUri
$splicedUri01 = $Matches[0].Substring(9)
$pythonLatestUri = "https://python.org" + $splicedUri01.Substring(0,$splicedUri01.IndexOf('"'))

#Get Python Latest Windows Version Page
$results = Invoke-WebRequest -Uri $pythonLatestUri
$pythonRegexWindowsLatestUri = '<a href="https://www.python.org/.+amd64.exe">Windows installer \(64-bit\)<\/a>'
$results -match $pythonRegexWindowsLatestUri
$splicedUri02 = $Matches[0].Substring(9)
$pythonWindowsAmd64LatestUri = $splicedUri02.Substring(0,$splicedUri02.IndexOf('"'))
$webClient = New-Object System.Net.WebClient
$webClient.Downloadfile($pythonWindowsAmd64LatestUri, "python-installer.exe")

Start-Process -FilePath "$PSScriptRoot\python-installer.exe" -ArgumentList '/quiet InstallAllUsers=0 PrependPath=1' -Wait

#reload $ENV:PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

pip install virtualenv

$venvPath = "venv-mkdocs"
# Check if the virtual environment exists
if (-not (Test-Path $venvPath)) {
    # If it doesn't exist, create the virtual environment
    python -m venv $venvPath
    Write-Output "Virtual environment created at $venvPath"
} else {
    Write-Output "Virtual environment already exists at $venvPath"
}

#Activate Python Virtual Enviroment
venv-mkdocs/scripts/activate.ps1

#Install Requirements for repo
pip install -r .\requirements.txt