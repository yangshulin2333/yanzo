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
Tools/RobloxStudio_GuiSnapshotExporter.luau
```

最常用流程：

```text
1. Codex 先读 00_Start_Here_For_Codex_给Codex先读.md。
2. 在 Studio 打开目标项目。
3. 把 Tools/RobloxStudio_GuiSnapshotExporter.luau 粘贴到 Command Bar 运行。
4. 把 Output 保存为 Project_Analysis_Package/GuiSnapshots/<名字>.md。
5. Codex 运行 Tools/Parse-GuiSnapshot.ps1 生成摘要。
6. 如果要知道手动改动，导出 before 和 after，再运行 Tools/Compare-GuiSnapshots.ps1。
```

