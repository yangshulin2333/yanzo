# Roblox 游戏 GUI 界面读取工作流

这个目录是专门给 Codex 读懂 Roblox GUI 用的工作流包。

它解决的问题：

```text
1. 不靠截图猜 UI 结构。
2. 从 Roblox Studio 导出 ScreenGui / Frame / ImageLabel / TextLabel 等真实节点。
3. 记录 Position、Size、AnchorPoint、Visible、ZIndex、Image、ScaleType、SliceCenter、TextScaled、CanvasSize 等关键属性。
4. 能对比两次导出，判断用户在 Studio 里手动改了哪些地方。
5. 输出一份中文 UI 读懂报告，方便后续继续做 UI、脚本、数据绑定。
```

稳定识别这个工作流时，不要靠文件夹名，靠这些文件：

```text
WORKFLOW_MANIFEST.json
00_Start_Here_For_Codex_给Codex先读.md
06_Low_Coupling_Rules_低耦合规则.md
Tools/RobloxStudio_GuiOverviewExporter.luau
Tools/RobloxStudio_GuiSnapshotExporter.luau
Tools/RobloxStudio_GuiHttpSnapshotExporter.luau
Tools/Receive-GuiSnapshotHttp.py
Tools/Parse-ChunkedGuiSnapshot.ps1
Tools/Test-UiAssetMap.py
Tools/Test-UiAssetMap.ps1
```

最常用流程：

```text
1. Codex 先读 00_Start_Here_For_Codex_给Codex先读.md。
2. 在 Studio 打开目标项目。
3. 新项目先运行 Tools/RobloxStudio_GuiOverviewExporter.luau，找到候选 GUI 根节点。
4. 再按目标页面运行 Tools/RobloxStudio_GuiSnapshotExporter.luau。
5. 把 Output 保存为 Project_Analysis_Package/GuiSnapshots/<名字>.md。
6. Codex 运行 Tools/Parse-GuiSnapshot.ps1 生成摘要。
7. 如果要知道手动改动，导出 before 和 after，再运行 Tools/Compare-GuiSnapshots.ps1。
8. 如果涉及 UI 图片素材表，优先运行 Tools/Test-UiAssetMap.py 直接检查 `.xlsx` 或 `.csv` 的 AssetId 是否真的可用。
```

`Tools/Test-UiAssetMap.py` 的 `.xlsx` 读取不强依赖 `openpyxl`。如果当前 Python 环境没装 `openpyxl`，工具会自动用内置读取逻辑读取第一张工作表，避免因为环境缺依赖而误判素材缺失。

如果目标是很大的 ScreenGui，普通 Studio Output 可能被截断，优先使用 HTTP 分段模式：

```powershell
python "<WorkflowDir>\Tools\Receive-GuiSnapshotHttp.py" `
  --out-dir "<ProjectDir>\Project_Analysis_Package\GuiSnapshots" `
  --name "<GuiName>_Current_Http"
```

然后由 Codex 按当前项目填好：

```text
Tools/RobloxStudio_GuiHttpSnapshotExporter.luau
```

脚本里的 `TARGET_JOBS` 是项目参数，可以写多个路径，例如 Root、某几个 Page、某个 Popup。Studio 运行后，接收器会写出：

```text
<Name>.combined.json
<Name>.summary.md
<Name>_<SegmentName>.json
```

如果只能走 Output 模式，Codex 读取保存后的 Output 时，使用：

```powershell
Roblox项目读取\Roblox游戏Gui界面读取\Tools\Parse-ChunkedGuiSnapshot.ps1
```

关键规则：

```text
1. 不默认导出整个 ScreenGui。
2. 先导出页面、弹窗、面板、模板这类小范围。
3. 快照必须有 BEGIN 和 END 两个 JSON 标记。
4. 如果 Output 出现 [trimmed]，这份快照只能粗看树结构，不能用于精确同步模板。
5. 大 GUI 默认走 HTTP 分段模式，不再把完整 JSON 打到 Output。
6. 工作流不绑定某个项目的 GUI 名、页面名、面板名。
7. AssetId 表支持纯数字、`rbxassetid://数字`、Roblox URL 里带 `id=数字` 三种格式。
```

如果是在 Studio 里手动调完 UI，想让 Codex 同步回生成脚本，先读：

```text
05_After_Studio_Edit_Sync_手动改动同步模板.md
```

日常协作里，用户不需要手动改导出脚本。用户说明“改了哪个区域、要不要同步回脚本”，Codex 负责填写 `TARGET_PATHS`，用户只在 Studio Command Bar 运行脚本并保存 Output。

素材表协作规则：

```text
1. 如果 Codex 说某个素材缺 AssetId，必须先说明读取的是哪一个表格文件。
2. Codex 必须运行 Test-UiAssetMap.py 生成待确认清单。
3. 如果用户表格界面里有 ID，但报告里为空，先让用户保存表格，再重新读取。
4. 必要时 Codex 使用 Test-UiAssetMap.ps1 -OpenCsv 帮用户打开对应表格。
5. 如果 `.xlsx` 和 `.csv` 不一致，优先使用用户明确指定的源文件，然后同步或重生成另一个文件。
```
