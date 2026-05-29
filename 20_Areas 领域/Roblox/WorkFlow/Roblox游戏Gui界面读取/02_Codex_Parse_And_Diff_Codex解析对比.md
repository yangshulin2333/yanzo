# Codex 解析与对比步骤

## 解析单个快照

在项目根目录或工作流目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File ".\Tools\Parse-GuiSnapshot.ps1" -InputPath "Project_Analysis_Package\GuiSnapshots\<GuiName>_<Scope>_After.md"
```

解析前先确认快照完整：

```text
必须有 ## BEGIN_ROBLOX_GUI_SNAPSHOT_JSON
必须有 ## END_ROBLOX_GUI_SNAPSHOT_JSON
不能以 [trimmed] 结尾
```

如果缺少 `END`，先让用户缩小 `TARGET_PATHS` 重新导出，不要用不完整 JSON 做模板同步。

输出：

```text
<原文件名>.json
<原文件名>.summary.md
```

摘要里重点看：

```text
1. targetPaths / nodeCount
2. ScreenGui attributes
3. 当前 Visible 的页面
4. Tab / Button 的 TargetAttrContent
5. ScrollingFrame 设置
6. Slice 图片设置
7. TextScaled = false 的文字
8. UIAspectRatioConstraint / UIScale 等约束节点
```

## 对比两份快照

如果用户问“我改了哪些”，必须使用 before / after 两份导出。

```powershell
powershell -ExecutionPolicy Bypass -File ".\Tools\Compare-GuiSnapshots.ps1" -Before "Project_Analysis_Package\GuiSnapshots\<GuiName>_<Scope>_Before.md" -After "Project_Analysis_Package\GuiSnapshots\<GuiName>_<Scope>_After.md"
```

输出：

```text
<GuiName>_<Scope>_Before_vs_<GuiName>_<Scope>_After.diff.md
```

对比报告会列出：

```text
1. Added nodes：新增节点
2. Removed nodes：删除节点
3. Changed nodes：关键属性变化
```

## 报告时的说法

只有 after 快照时：

```text
我能确认当前状态，但不能严格判断哪些是你刚改的。
```

有 before / after 快照时：

```text
我能确认这些路径、属性、数值发生了变化。
```
