# 给 Codex 先读：Roblox 游戏 GUI 界面读取

## 语言规则

用户英语水平是大学英语四级。默认中文说明，英文只保留 Roblox 类名、属性名、脚本名、文件名、API 名。

## 目标

本工作流的目标不是写玩法，也不是重构代码，而是先把 Roblox GUI 读懂。

要读懂的内容包括：

```text
1. GUI 树结构：ScreenGui、Frame、ImageLabel、ImageButton、TextLabel、ScrollingFrame 等。
2. 页面分层：共用层、页面层、左面板、右面板、弹窗、按钮、列表。
3. 当前显示状态：Visible、选中 Tab、当前页面 Attribute。
4. 布局方式：Position、Size、AnchorPoint、Scale / Offset、是否居中。
5. 素材使用：Image AssetId、SourceAsset、NormalImage、SelectedImage。
6. 九宫格切片：ScaleType = Slice、SliceCenter、SliceScale。
7. 滚动区域：ScrollingFrame、CanvasSize、AutomaticCanvasSize、ScrollBar。
8. 文字设置：TextScaled、TextXAlignment、TextYAlignment、TextStroke。
9. 用户手动改动：通过 before / after 两份快照对比，不靠截图猜。
```

## Codex 先做什么

```text
1. 找到本工作流目录。
2. 读取 WORKFLOW_MANIFEST.json 和本文件。
3. 如果用户只说“读一下项目 / 读一下文件”，默认先做 GUI 总览。
4. 从总览结果里挑一个目标 GUI 路径。
5. 把目标路径填进聚焦导出器的 TARGET_PATHS。
6. 解析导出的快照。
7. 输出 UI 读懂报告。
```

## 两段式导出

### 第一步：总览导出

新接手项目、用户没有说明具体 UI 路径时，先让用户在 Studio Command Bar 运行：

```text
Tools/RobloxStudio_GuiOverviewExporter.luau
```

总览只负责找候选 GUI 根节点，不导出大量属性，避免 Output 被截断。

### 第二步：聚焦快照

确认要读的界面后，再运行：

```text
Tools/RobloxStudio_GuiSnapshotExporter.luau
```

修改脚本顶部的 `TARGET_PATHS`，只导出一个页面、一个面板、一个弹窗、或一个模板。

路径格式示例：

```text
StarterGui/<ScreenGuiName>
StarterGui/<ScreenGuiName>/<PageName>
StarterGui/<ScreenGuiName>/<PageName>/<PanelName>
ReplicatedStorage/Resource/ui/<GuiTemplateName>
PlayerGui/<运行时 GUI>，仅在 Play 模式需要时使用
```

整棵大 GUI 只作为兜底，不作为默认方式：

```text
StarterGui/<ScreenGuiName>
```

因为整棵 GUI 往往包含多个页面、模板、弹窗，Studio Output 容易出现 `[trimmed]`。

## 完整性判断

聚焦快照必须同时包含：

```text
## BEGIN_ROBLOX_GUI_SNAPSHOT_JSON
## END_ROBLOX_GUI_SNAPSHOT_JSON
```

如果只有 `BEGIN` 没有 `END`，或者末尾出现 `[trimmed]`，这份快照不能用于精确同步模板。应缩小 `TARGET_PATHS` 重新导出。

## 重要规则

如果只有一份导出快照，只能说“当前状态是什么”，不能武断说“用户改了什么”。

本工作流必须低耦合：

```text
1. 不内置某个项目的 ScreenGui 名字。
2. 不内置某个页面名、面板名、模板名。
3. 目标路径必须来自总览导出、用户说明、或当前项目文档。
4. 当前项目示例只能放在报告或示例区，不能变成工作流规则。
```

如果要准确知道用户改动，必须有两份快照：

```text
Before：改动前
After：改动后
```

然后运行：

```powershell
powershell -ExecutionPolicy Bypass -File ".\Tools\Compare-GuiSnapshots.ps1" -Before "<before.md>" -After "<after.md>"
```

## 推荐输出文件

项目根目录下建议放：

```text
Project_Analysis_Package/
└─ GuiSnapshots/
   ├─ <GuiName>_<Scope>_Before.md
   ├─ <GuiName>_<Scope>_After.md
   ├─ <GuiName>_<Scope>_After.summary.md
   └─ <GuiName>_<Scope>_Before_vs_After.diff.md
```

最终报告建议放：

```text
Project_Analysis_Package/Gui_Understanding_Report.md
```
