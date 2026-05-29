# Studio GUI 导出说明

## 使用场景

当 Codex 需要读懂 Roblox UI，或者需要知道你在 Studio 里手动改了哪些 UI 属性时，用这个导出。

## 操作步骤

1. 打开 Roblox Studio，并打开目标项目。
2. 打开 `View > Output` 和 `View > Command Bar`。
3. 打开本工作流文件：

```text
Tools/RobloxStudio_GuiSnapshotExporter.luau
```

4. 根据目标 UI 修改脚本顶部的 `TARGET_PATHS`。

常用例子：

```lua
local TARGET_PATHS = {
	"StarterGui/MainGui",
}
```

如果 UI 模板在资源目录：

```lua
local TARGET_PATHS = {
	"ReplicatedStorage/Resource/ui/MainGui",
}
```

5. 把整个脚本粘贴到 Studio 的 Command Bar，按 Enter 运行。
6. 从 Output 复制导出内容，保存到：

```text
Project_Analysis_Package/GuiSnapshots/<有意义的名字>.md
```

推荐命名：

```text
MainGui_BeforeManualEdit.md
MainGui_AfterManualEdit.md
AttrWindow_AfterFix.md
```

## 判断是否导出成功

导出内容里必须有这两个标记：

```text
## BEGIN_ROBLOX_GUI_SNAPSHOT_JSON
## END_ROBLOX_GUI_SNAPSHOT_JSON
```

如果 Output 被截断，通常会出现 JSON 不完整。处理方式：

```text
1. 缩小 TARGET_PATHS，只导出一个 ScreenGui 或一个弹窗。
2. 不要一次导出整个 game。
3. 重新运行并保存。
```

