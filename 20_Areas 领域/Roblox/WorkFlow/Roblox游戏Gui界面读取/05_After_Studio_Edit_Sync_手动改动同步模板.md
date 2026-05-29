# Studio 手动改动后，同步回生成脚本

当用户在 Roblox Studio 里手动调整了 UI，Codex 想准确知道改动并同步回生成脚本时，走这个流程。

## 输入参数

这个模板是通用的，不绑定任何项目名称。

```text
<WorkflowDir>：Roblox游戏Gui界面读取 工作流目录
<ProjectDir>：当前 Roblox 项目目录
<TargetPath>：要读取的 GUI 节点路径
<BeforeSnapshot>：改动前快照，可选
<AfterSnapshot>：改动后快照，必需
<TemplateNode>：需要同步的模板节点，可选
```

## 最少需要一份 After 快照

如果只有一份改动后的快照，Codex 可以确认当前状态，并按当前状态改模板。

推荐保存为：

```text
<ProjectDir>/Project_Analysis_Package/GuiSnapshots/<GuiName>_<Scope>_After.md
```

## 精确知道改动，需要 Before + After

如果要精确回答“用户改了哪些属性”，需要两份快照：

```text
<ProjectDir>/Project_Analysis_Package/GuiSnapshots/<GuiName>_<Scope>_Before.md
<ProjectDir>/Project_Analysis_Package/GuiSnapshots/<GuiName>_<Scope>_After.md
```

然后运行：

```powershell
powershell -ExecutionPolicy Bypass -File "<WorkflowDir>\Tools\Compare-GuiSnapshots.ps1" -Before "<BeforeSnapshot>" -After "<AfterSnapshot>"
```

## 选择 TargetPath 的原则

不要默认导出整个 `ScreenGui`。优先导出最小可用范围：

```text
1. 只改一个模板：导出这个模板节点。
2. 只改一个列表：导出这个列表所在面板。
3. 只改一个弹窗：导出这个弹窗。
4. 不知道路径：先运行 GuiOverviewExporter，再从候选路径里选。
```

路径格式示例：

```text
StarterGui/<ScreenGuiName>/<PageName>/<PanelName>
StarterGui/<ScreenGuiName>/<PopupName>
ReplicatedStorage/Resource/ui/<GuiTemplateName>
```

## 解析 After 快照

```powershell
powershell -ExecutionPolicy Bypass -File "<WorkflowDir>\Tools\Parse-GuiSnapshot.ps1" -InputPath "<AfterSnapshot>"
```

解析摘要会生成：

```text
<AfterSnapshot>.summary.md
```

重点查看：

```text
## Visible / Page State
## ScrollingFrame
## Template Nodes
## Buttons And Tab Targets
## Slice Images
## TextScaled False Or Missing
```

## Codex 同步原则

```text
1. 先同步模板节点，再同步普通实例的生成逻辑。
2. 不要只改某一个 clone 出来的普通实例。
3. 用户新增的子节点层级，模板也要补齐。
4. 用户改了 UIListLayout、CanvasSize、AutomaticCanvasSize，生成脚本也要跟着改。
5. 用户改了字体、TextScaled、描边、对齐方式，生成脚本也要跟着改。
6. 同步后跑格式检查和项目可生成性检查。
```

## 快照不完整时

如果解析脚本提示找不到 `END_ROBLOX_GUI_SNAPSHOT_JSON`，或者源文件里有 `[trimmed]`：

```text
1. 不能按这份文件做精确同步。
2. 重新导出更小的 TARGET_PATHS。
3. 如果仍然太大，就把一个面板拆成多个子节点分别导出。
```
