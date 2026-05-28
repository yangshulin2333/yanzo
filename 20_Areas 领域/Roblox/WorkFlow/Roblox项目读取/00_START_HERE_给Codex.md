# Roblox 项目读取工作流：Codex 入口

## 你现在的角色

你是 Codex。用户刚接手一个 Roblox 项目，并把本工作流文件夹提供给你，或者复制到了项目根目录。

重要：工作流文件夹的名字可以是任意名称。不要根据文件夹名判断它是不是工作流；只能根据本目录下的 `WORKFLOW_MANIFEST.json`、`00_START_HERE_给Codex.md` 和 `Tools/Bootstrap_RobloxProjectAuditWorkspace.ps1` 判断。

你的目标只有一个：

```text
帮助用户把当前 Roblox 项目完整导出成你能读取、分析、接手的文本资料。
```

不要一开始就写功能、改代码、重构、评价玩法。先完成项目读取。

## 你必须先做什么

第一步不是让用户建文件，也不是让用户复制工具。

你先自动完成这些本地准备：

```text
1. 确认当前工作目录是不是 Roblox 项目根目录。
2. 找到本工作流里的 `Tools/Bootstrap_RobloxProjectAuditWorkspace.ps1`。
3. 在项目根目录创建 Project_Analysis_Package/。
4. 在项目根目录创建 Tools/。
5. 创建所有空的 Audit_*.md 和分析输出 md。
6. 把通用 RobloxStudio_*.luau 导出脚本复制到项目根目录的 Tools/。
7. 然后再告诉用户去 Roblox Studio 跑哪个脚本。
```

## 判断工作流放在哪里

按顺序判断：

### 情况 A：工作流文件夹被复制到项目根目录，且保留为单独子文件夹

例如：

```text
项目根目录/
├─ <任意工作流文件夹名>/
│  ├─ 00_START_HERE_给Codex.md
│  ├─ WORKFLOW_MANIFEST.json
│  └─ Tools/
```

判断方法：

```text
在项目根目录的子目录里查找：
1. WORKFLOW_MANIFEST.json
2. 00_START_HERE_给Codex.md
3. Tools/Bootstrap_RobloxProjectAuditWorkspace.ps1
```

找到后，用真实子目录名运行。示例：

```powershell
powershell -ExecutionPolicy Bypass -File ".\<任意工作流文件夹名>\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1" -TargetRoot "." -SourceToolsDir ".\<任意工作流文件夹名>\Tools" -CopyExporters
```

### 情况 B：工作流内容已经合并到项目根目录

例如：

```text
项目根目录/
├─ Tools/
│  └─ Bootstrap_RobloxProjectAuditWorkspace.ps1
├─ README_Studio_Export.md
└─ Roblox_NewProject_FullExport_Only_CN.md
```

你在项目根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File ".\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1" -TargetRoot "." -SourceToolsDir ".\Tools" -CopyExporters
```

### 情况 C：用户只告诉你工作流路径

例如用户说：

```text
工作流路径：<工作流文件夹路径>
项目路径：<当前 Roblox 项目根目录>
```

你运行：

```powershell
powershell -ExecutionPolicy Bypass -File "工作流路径\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1" -TargetRoot "项目路径" -SourceToolsDir "工作流路径\Tools" -CopyExporters
```

注意：实际执行时替换成真实路径。不要把某个固定盘符路径写死到文档里。

### 如果当前目录本身就是工作流目录

如果当前目录包含：

```text
WORKFLOW_MANIFEST.json
00_START_HERE_给Codex.md
Tools/Bootstrap_RobloxProjectAuditWorkspace.ps1
```

那当前目录是工作流目录，不一定是 Roblox 项目根目录。

优先判断当前目录的父目录是不是项目根目录。判断依据：

```text
1. 父目录里有 .rbxl / .rbxlx。
2. 父目录里有 default.project.json。
3. 父目录里有 src/、ReplicatedStorage/、ServerScriptService/、StarterPlayer/ 等 Roblox 项目结构。
4. 用户明确说“工作流文件夹放在项目根目录下”。
```

如果父目录符合，就把父目录作为 `TargetRoot`。示例：

```powershell
powershell -ExecutionPolicy Bypass -File ".\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1" -TargetRoot ".." -SourceToolsDir ".\Tools" -CopyExporters
```

如果无法判断父目录是不是项目根目录，再问用户项目根目录在哪里，然后用：

```powershell
powershell -ExecutionPolicy Bypass -File ".\Tools\Bootstrap_RobloxProjectAuditWorkspace.ps1" -TargetRoot "<当前 Roblox 项目根目录>" -SourceToolsDir ".\Tools" -CopyExporters
```

不要把工作流目录本身误判为 Roblox 项目根目录。

## 初始化后应该出现什么

项目根目录下应该出现：

```text
Project_Analysis_Package/
Tools/
```

`Project_Analysis_Package/` 里应该有：

```text
Startup_Record.md
Audit_Quick_Focused_Output.md
Audit_Project_Assets_Output.md
Audit_Animation_Sound_Output.md
Audit_SourceAssetSearch_Output.md
Audit_TargetSource_Output.md
Audit_Raw_Output.md
Explorer_Tree.md
Script_Index.md
RemoteEvent_Map.md
Asset_Audit.md
Animation_Sound_Index.md
Source_Asset_Search_Index.md
Target_Source_Index.md
Project_Understanding_Report.md
Next_Steps.md
```

`Tools/` 里应该有：

```text
RobloxStudio_QuickFocusedAuditExporter.luau
RobloxStudio_ProjectOnlyAssetExporter.luau
RobloxStudio_AnimationSoundExporter.luau
RobloxStudio_SourceAssetSearchExporter.luau
RobloxStudio_TargetSourceExporter.luau
RobloxStudio_AuditExporter.luau
```

## 然后你对用户说什么

初始化完成后，直接告诉用户：

```text
现在请你在 Roblox Studio 做这一步：

1. 打开当前 Roblox 项目。
2. 打开 View -> Output。
3. 打开 View -> Command Bar。
4. 打开项目根目录下的 Tools/RobloxStudio_QuickFocusedAuditExporter.luau。
5. 复制这个 luau 文件全部内容。
6. 粘贴到 Studio Command Bar。
7. 按 Enter。
8. 把这次 Output 全部复制。
9. 粘贴到 Project_Analysis_Package/Audit_Quick_Focused_Output.md。

完成后告诉我。
```

不要要求用户创建 md 文件；你已经创建好了。

## 用户完成第一份导出后你做什么

读取：

```text
Project_Analysis_Package/Audit_Quick_Focused_Output.md
```

然后输出：

```text
1. 项目结构初判
2. 脚本数量和分布
3. Remote / Bindable 初判
4. 素材引用初判
5. 下一步应该跑哪个导出脚本
6. 如果要导关键源码，TargetSourceExporter 应该先怎么用
```

此时仍然不要改游戏代码。

## 推荐导出顺序

按这个顺序推进：

```text
1. RobloxStudio_QuickFocusedAuditExporter.luau
   -> Audit_Quick_Focused_Output.md

2. RobloxStudio_ProjectOnlyAssetExporter.luau
   -> Audit_Project_Assets_Output.md

3. RobloxStudio_AnimationSoundExporter.luau
   -> Audit_Animation_Sound_Output.md

4. RobloxStudio_SourceAssetSearchExporter.luau
   -> Audit_SourceAssetSearch_Output.md

5. RobloxStudio_TargetSourceExporter.luau 第一次运行
   -> Audit_TargetSource_Output.md
   作用：列出可选脚本路径。

6. 你根据前面输出，修改 Tools/RobloxStudio_TargetSourceExporter.luau 的 TARGET_PATHS。

7. 用户再次在 Studio 运行 RobloxStudio_TargetSourceExporter.luau
   -> 覆盖 Audit_TargetSource_Output.md
   作用：导出关键脚本完整源码。
```

## TargetSourceExporter 的责任分工

用户不应该自己猜 `TARGET_PATHS`。

流程应该是：

```text
1. 用户第一次运行 TargetSourceExporter。
2. 用户把 Output 粘贴到 Audit_TargetSource_Output.md。
3. 你读取脚本路径列表。
4. 你判断哪些脚本最关键。
5. 你直接修改项目根目录下的 Tools/RobloxStudio_TargetSourceExporter.luau。
6. 你告诉用户重新复制这个文件到 Studio Command Bar 运行。
```

## 最终你要生成哪些分析文件

等 `Audit_*.md` 基本齐了，你再写：

```text
Explorer_Tree.md
Script_Index.md
RemoteEvent_Map.md
Asset_Audit.md
Animation_Sound_Index.md
Source_Asset_Search_Index.md
Target_Source_Index.md
Project_Understanding_Report.md
Next_Steps.md
```

## 禁止事项

```text
1. 不要让用户手动创建 Project_Analysis_Package/。
2. 不要让用户手动创建空 md。
3. 不要默认修改游戏代码。
4. 不要假装能直接读懂 .rbxl 二进制内容。
5. 不要要求用户只复制 Output 的某一段；让用户复制本次 Output 全部内容。
6. 不要写死某个路径。
7. 不要把旧项目名、旧 AssetId 黑名单、旧业务逻辑带进新项目。
```

## 如果用户只问“我现在该做什么”

直接回答：

```text
我先初始化项目读取目录和空文件。
初始化完成后，你只需要在 Roblox Studio 里运行第一个导出脚本，并把 Output 全部粘贴回来。
```
