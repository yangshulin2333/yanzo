# Roblox Studio 通用导出脚本说明

新对话里的 Codex 应该先读：

```text
WORKFLOW_MANIFEST.json
00_START_HERE_给Codex.md
```

这份 README 只作为脚本用途速查。

这些脚本只读当前打开的 Roblox 项目，用来把 Studio 里的结构、脚本、Remote、素材、动画和音效导出成 Codex 可读文本。

## Codex 先做

推荐把这套工具放在新项目根目录的 `Tools/` 下，然后在新项目根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1 -TargetRoot . -CopyExporters
```

如果工具包暂时放在新项目外面，也用相对路径，例如：

```powershell
powershell -ExecutionPolicy Bypass -File ..\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1 -TargetRoot . -SourceToolsDir ..\Tools -CopyExporters
```

它会创建：

```text
Project_Analysis_Package/
Tools/
```

并创建空的 `Audit_*.md`、索引文档和报告文档，同时复制通用导出脚本。

## 用户必须在 Studio 做

```text
1. Roblox Studio 打开新项目。
2. View -> Output。
3. View -> Command Bar。
4. 复制 Tools/*.luau 全部内容。
5. 粘贴到 Command Bar。
6. 按 Enter。
7. 把这次运行后的 Output 全部复制出来。
8. 粘贴到 Codex 已经创建好的对应 md 文件。
```

## 脚本用途

| 脚本 | 输出文件 | 用途 |
|---|---|---|
| `RobloxStudio_QuickFocusedAuditExporter.luau` | `Audit_Quick_Focused_Output.md` | 结构、脚本、Remote、基础素材概览 |
| `RobloxStudio_ProjectOnlyAssetExporter.luau` | `Audit_Project_Assets_Output.md` | 项目服务内素材引用 |
| `RobloxStudio_AnimationSoundExporter.luau` | `Audit_Animation_Sound_Output.md` | Animation / Sound 对象和 AssetId |
| `RobloxStudio_SourceAssetSearchExporter.luau` | `Audit_SourceAssetSearch_Output.md` | 脚本源码里的 AssetId 和资源关键词 |
| `RobloxStudio_TargetSourceExporter.luau` | `Audit_TargetSource_Output.md` | 指定脚本完整源码 |
| `RobloxStudio_AuditExporter.luau` | `Audit_Raw_Output.md` | 更宽的综合导出，Output 太长时可以不用 |

## 关键说明

`RobloxStudio_TargetSourceExporter.luau` 默认不带任何旧项目路径。第一次运行会输出可选脚本路径列表；把需要的路径填进 `TARGET_PATHS` 后再运行一次，才会导出完整源码。
