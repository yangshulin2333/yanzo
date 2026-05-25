---
name: roblox-rojo-project-init
description: Initialize a new Roblox Rojo project or explain the initialization workflow for Roblox independent game development. Use when the user asks to create, scaffold, initialize, set up, or teach a new Roblox + Rojo project, especially with commented Luau starter code, client-server boundaries, RemoteEvent setup, VS Code/Studio workflow, Wally/Stylua files, or safe first-playable skeletons.
---

# Roblox Rojo Project Init

## Purpose

Use this skill to create a practical Roblox + Rojo starter project that teaches the user how an independent Roblox game is structured. Prefer a small, safe, commented client-server skeleton over a large framework-heavy template.

## Workflow

1. Confirm or infer the project name and target folder.
2. Inspect the target path before writing files.
3. Resolve the skill directory from the current `SKILL.md`, then run `scripts/New-RobloxRojoProject.ps1` from that directory to create the base project. Do not hardcode a user-specific path such as `C:\Users\...\`.
4. Explain the generated structure in learning order:
   - `default.project.json` maps local files into Roblox Studio.
   - `ReplicatedStorage/Shared` holds shared config, Remote names, and utilities.
   - `ServerScriptService` holds authoritative gameplay and data logic.
   - `StarterPlayerScripts` holds client UI/input/feedback logic.
   - `.vscode` recommends Roblox/Rojo/Luau development extensions and task shortcuts.
5. Keep the first playable loop small:
   - client button click
   - RemoteEvent request
   - server validation
   - server-side data change
   - client feedback
6. Do not add monetization, DataStore schema expansion, UGC, Skin, Aura, or real asset pipelines in the first scaffold unless the user explicitly asks.

## Script

Run the bundled script by resolving it relative to this skill folder:

```powershell
$skillDir = "<path-to-this-skill-folder>"
powershell -ExecutionPolicy Bypass -File "$skillDir\scripts\New-RobloxRojoProject.ps1" -ProjectName "MyGame" -OutputPath "<parent-folder-for-new-projects>"
```

If the user asks from a completely fresh environment, first explain that the skill must exist in that Codex environment before it can be invoked. Then create the project in the user-chosen folder, not in a hardcoded path.

Required tools for a fresh Windows Roblox setup:

```text
Roblox Studio
VS Code
Git
Rojo CLI
Rojo Studio plugin
StyLua
```

The script creates:

```text
MyGame/
  default.project.json
  README.md
  .gitignore
  wally.toml
  stylua.toml
  .vscode/
    extensions.json
    settings.json
    tasks.json
    immersive-translate-api-key.md
  src/
    ReplicatedStorage/
      Shared/
        GameConfig.luau
        RemoteNames.luau
        InstanceUtil.luau
    ServerScriptService/
      Main.server.luau
      Services/
        DataService.luau
        RewardService.luau
    StarterPlayer/
      StarterPlayerScripts/
        Main.client.luau
        ClientModules/
          UIController.luau
          RewardController.luau
```

## Teaching Rules

- Explain `.server.luau`, `.client.luau`, and plain `.luau` every time the user is learning a new project skeleton.
- Emphasize that client code can request actions but server code must decide rewards, purchases, inventory, and saved data.
- Treat `rojo serve` as a local development session that must be restarted after reboot or terminal close.
- Explain the generated VS Code recommendations:
  - `evaera.vscode-rojo`: Rojo project workflow support.
  - `JohnnyMorganz.luau-lsp`: Luau language server for completion and diagnostics.
  - `JohnnyMorganz.stylua`: format Luau/Lua code.
  - `tamasfe.even-better-toml`: edit `wally.toml` cleanly.
  - `ms-vscode.PowerShell`: edit/run helper scripts on Windows.
  - `liujie2288.immersive-translate-vscode`: translate code comments and Markdown without modifying source files.
- Configure Immersive Translate defaults in `.vscode/settings.json`:
  - service: `deepl`
  - source language: `auto`
  - target language: `zh-CN`
  - cache: enabled
- Do not put real translation API keys into generated project files. Generate `.vscode/immersive-translate-api-key.md` with the exact command-palette location:
  - `Ctrl+Shift+P`
  - `Immersive Translate: Set API Key`
  - choose service
  - paste the API key there
- Explain the generated VS Code tasks:
  - `Rojo: serve`: start the local Studio sync server.
  - `Rojo: sourcemap`: generate sourcemap for tooling.
  - `StyLua: check src`: verify code formatting.
- Recommend this startup command from the generated project root:

```powershell
rojo serve default.project.json --address 127.0.0.1 --port 34872
```

- If the user is still learning, do not hide the workflow behind automation too early. Give the command and explain why it works.

## Validation

After creating a project, run checks when tools are available:

```powershell
rojo sourcemap default.project.json --output sourcemap.json
stylua --check src
```

If `rojo` or `stylua` is missing, report that clearly and still explain the generated files.

## Optional Reference

If the user asks why the skeleton is shaped this way, read `references/structure-decisions.md`.
