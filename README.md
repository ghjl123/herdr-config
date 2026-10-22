# herdr-config

My herdr configuration for Windows.

- `config.toml`: the herdr config (UI, keys, numbered sidebar spaces).
- `install.ps1`: copies `config.toml` to `%APPDATA%\herdr\`, reloads the herdr server, and starts
  `space-index.ps1` hidden (plus a Startup shortcut so it runs at login).
- `export.ps1`: copies `%APPDATA%\herdr\config.toml` back here, so a change made in herdr can be committed.
- `space-index.ps1`: reports each workspace's number as the `$index` sidebar token.

```powershell
.\install.ps1   # apply this repo's config
.\export.ps1    # pull the live config back into the repo
```
