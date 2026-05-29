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
3. 确认用户要读取的 GUI 根节点路径。
   常见路径：
   - StarterGui/MainGui
   - StarterGui/<某个 ScreenGui>
   - ReplicatedStorage/Resource/ui/<某个 UI 模板>
   - PlayerGui/<运行时 GUI>，仅在 Play 模式需要时使用
4. 让用户在 Studio Command Bar 运行导出脚本。
5. 解析导出的快照。
6. 输出 UI 读懂报告。
```

## 重要规则

如果只有一份导出快照，只能说“当前状态是什么”，不能武断说“用户改了什么”。

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
   ├─ MainGui_Before.md
   ├─ MainGui_After.md
   ├─ MainGui_After.summary.md
   └─ MainGui_Before_vs_After.diff.md
```

最终报告建议放：

```text
Project_Analysis_Package/Gui_Understanding_Report.md
```

