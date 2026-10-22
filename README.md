# herdr-config

My [herdr](https://herdr.dev) setup for Windows (tested with herdr 0.9.5): browser-style keys for
workspaces (spaces), numbered spaces in the sidebar, and two scripts to keep the config in git.

## What you get

| Key | Action |
| --- | --- |
| `Alt+1` … `Alt+9` | Go to space 1–9 |
| `Alt+Up` / `Alt+Down` | Previous / next space |
| `Alt+N` (or `prefix` `n`) | New space |
| `Ctrl+W` / `Alt+W` (or `prefix` `Shift+D`) | Close the current space (herdr asks first) |

Other settings in `config.toml`:

- **Numbered sidebar.** Each space shows its number (the one `Alt+1..9` uses), its state, name, git branch and
  git status. herdr has no built-in number token, so `space-index.ps1` reports it (see below).
- **Mouse.** herdr handles the mouse (click a space to open it). herdr has no right-click paste: use
  `Shift`+right-click (Windows Terminal pastes) or `Ctrl+V`.
- **Quiet.** No sounds, notifications go to the system, onboarding off.

Note: `Ctrl+W` closes the space, so it no longer reaches the shell (bash's delete-word). Remove it from
`close_workspace` if you want it back.

## Requirements

- Windows with herdr installed and on `PATH`.
- PowerShell 7 (`pwsh`): `space-index.ps1` runs under it.

## Install

```powershell
git clone https://github.com/ghjl123/herdr-config.git
cd herdr-config
.\install.ps1
```

`install.ps1`:

1. Copies `config.toml` to `%APPDATA%\herdr\config.toml`. This overwrites your current herdr config, so
   back it up first if you have one.
2. Runs `herdr server reload-config`, so a running herdr picks it up.
3. Starts `space-index.ps1` hidden (restarting it if it already runs) and adds a shortcut to your Startup
   folder so it runs at login.

To use only the keys, copy `config.toml` by hand and drop the `$index` token from `[ui.sidebar.spaces]`.

## Keeping it in git

Changed something in herdr's own settings? Pull it back into the repo and commit:

```powershell
.\export.ps1    # copies %APPDATA%\herdr\config.toml here and shows the diff
```

## How the numbered sidebar works

`space-index.ps1` polls `herdr workspace list` every 2 seconds. When the list changes (a space opened, closed
or moved), it reports each space's number with `herdr workspace report-metadata … --token "index=N"`, and the
sidebar row `["state_icon", "$index", "workspace"]` shows it. Before herdr runs it just waits.

To stop it: end the hidden `pwsh` process running `space-index.ps1` and delete `herdr space-index.lnk` from
your Startup folder (`shell:startup`).
