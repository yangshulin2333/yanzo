# Roblox 新项目完整导出清单

目标只有一个：

```text
把新接收的 Roblox 项目尽可能完整导出成 Codex 可读的文本资料。
```

## 先准备目录

在新项目根目录创建：

```text
Project_Analysis_Package/
Tools/
```

从当前项目复制这些脚本到新项目 `Tools/`：

```text
Tools/RobloxStudio_QuickFocusedAuditExporter.luau
Tools/RobloxStudio_ProjectOnlyAssetExporter.luau
Tools/RobloxStudio_AnimationSoundExporter.luau
Tools/RobloxStudio_SourceAssetSearchExporter.luau
Tools/RobloxStudio_TargetSourceExporter.luau
```

## Studio 运行方式

每个脚本都这样跑：

```text
1. Roblox Studio 打开新项目。
2. View -> Output。
3. View -> Command Bar。
4. 复制 Tools/*.luau 全部内容。
5. 粘贴到 Command Bar。
6. 按 Enter。
7. 把 Output 里以 # Roblox 开头的内容复制出来。
8. 保存到 Project_Analysis_Package/ 对应 md 文件。
```

## 必导 1：项目结构 / 脚本 / Remote / 基础素材

运行：

```text
Tools/RobloxStudio_QuickFocusedAuditExporter.luau
```

保存为：

```text
Project_Analysis_Package/Audit_Quick_Focused_Output.md
```

它导出：

```text
GameId / PlaceId / Creator
Script / LocalScript / ModuleScript 列表
RemoteEvent / RemoteFunction / BindableEvent / BindableFunction
基础 AssetId 引用
```

## 必导 2：项目内素材引用

运行：

```text
Tools/RobloxStudio_ProjectOnlyAssetExporter.luau
```

保存为：

```text
Project_Analysis_Package/Audit_Project_Assets_Output.md
```

它导出：

```text
Workspace
ReplicatedStorage
ServerScriptService
ServerStorage
StarterGui
StarterPlayer
StarterPack
ReplicatedFirst
Lighting
SoundService
```

里面引用的：

```text
Image
Texture
Mesh
Sound
Animation
Particle / Trail / Beam 相关资源
```

## 必导 3：动画和音效

运行：

```text
Tools/RobloxStudio_AnimationSoundExporter.luau
```

保存为：

```text
Project_Analysis_Package/Audit_Animation_Sound_Output.md
```

它导出：

```text
Animation 对象
Sound 对象
动画模块
音效模块
音频 AssetId
动画 AssetId
```

## 必导 4：脚本源码里的 AssetId

运行：

```text
Tools/RobloxStudio_SourceAssetSearchExporter.luau
```

保存为：

```text
Project_Analysis_Package/Audit_SourceAssetSearch_Output.md
```

它导出脚本源码中硬编码的：

```text
rbxassetid://...
数字 AssetId
图片资源
音效资源
动画资源
Mesh 资源
```

## 必导 5：关键源码

先根据前 4 个导出结果，找出最关键的脚本路径。

然后编辑：

```text
Tools/RobloxStudio_TargetSourceExporter.luau
```

改顶部：

```lua
local TARGET_PATHS = {
	"StarterPlayer/StarterPlayerScripts/你的客户端脚本",
	"ServerScriptService/你的服务端脚本",
	"ReplicatedStorage/你的模块脚本",
}
```

运行后保存为：

```text
Project_Analysis_Package/Audit_TargetSource_Output.md
```

它导出：

```text
目标 Script / LocalScript / ModuleScript 的完整源码
```

## 可选：如果要更完整导出 Explorer 树

运行：

```text
Tools/RobloxStudio_AuditExporter.luau
```

保存为：

```text
Project_Analysis_Package/Audit_Raw_Output.md
```

它导出更宽的：

```text
Explorer 树
脚本列表
Remote 列表
素材引用
```

如果 Output 太长被截断，就不要用它，回到前面的分步导出。

## 最终给 Codex 读取这些文件

新对话里直接让 Codex 读：

```text
Project_Analysis_Package/Audit_Quick_Focused_Output.md
Project_Analysis_Package/Audit_Project_Assets_Output.md
Project_Analysis_Package/Audit_Animation_Sound_Output.md
Project_Analysis_Package/Audit_SourceAssetSearch_Output.md
Project_Analysis_Package/Audit_TargetSource_Output.md
Project_Analysis_Package/Audit_Raw_Output.md
```

然后让 Codex 输出：

```text
Project_Analysis_Package/Explorer_Tree.md
Project_Analysis_Package/Script_Index.md
Project_Analysis_Package/RemoteEvent_Map.md
Project_Analysis_Package/Asset_Audit.md
Project_Analysis_Package/Animation_Sound_Index.md
Project_Analysis_Package/Source_Asset_Search_Index.md
Project_Analysis_Package/Target_Source_Index.md
Project_Analysis_Package/Project_Understanding_Report.md
```

## 新对话提示词

```text
这是一个新的 Roblox 项目。
我已经用 Studio 导出了项目结构、脚本、Remote、素材、动画、音效和目标源码。

请先读取 Project_Analysis_Package 下所有 Audit_*.md。
不要改代码。

请输出：
1. 项目整体结构
2. 所有脚本索引
3. Remote / Bindable 通信表
4. 素材 / 动画 / 音效资产表
5. 关键功能链路
6. 数据结构和配置位置
7. 还缺哪些导出
8. 下一步应该重点读哪些源码
```

## 最小版

时间不够时，只跑这两个：

```text
1. RobloxStudio_QuickFocusedAuditExporter.luau
2. RobloxStudio_TargetSourceExporter.luau
```

一个导结构，一个导关键源码。
