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

# Start it at login too: a shortcut in the user's Startup folder (minimised, then hidden).
# Before herdr runs, the reporter just waits and numbers the spaces once it does.
$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut(
    (Join-Path ([Environment]::GetFolderPath('Startup')) 'herdr space-index.lnk'))
$shortcut.TargetPath = (Get-Command pwsh).Source
$shortcut.Arguments = "-NoProfile -WindowStyle Hidden -File `"$script`""
$shortcut.WindowStyle = 7
$shortcut.Save()
