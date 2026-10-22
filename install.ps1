# Copies config.toml to herdr's config folder, reloads the running server and (re)starts
# the hidden space-index reporter that numbers the sidebar spaces.
$target = Join-Path $env:APPDATA 'herdr'
New-Item -ItemType Directory -Force $target | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'config.toml') (Join-Path $target 'config.toml')
herdr server reload-config

$script = Join-Path $PSScriptRoot 'space-index.ps1'
Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'" |
    Where-Object CommandLine -like '*space-index.ps1*' |
    ForEach-Object { Stop-Process -Id $_.ProcessId }
Start-Process pwsh -WindowStyle Hidden -ArgumentList '-NoProfile', '-File', $script
