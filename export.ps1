# Copies this PC's herdr config (%APPDATA%\herdr\config.toml) back into the repo, so a change
# made in herdr's own settings can be committed and installed elsewhere with install.ps1.
Copy-Item (Join-Path $env:APPDATA 'herdr\config.toml') (Join-Path $PSScriptRoot 'config.toml')
git -C $PSScriptRoot diff --stat -- config.toml
