# Roblox 武器模型制作工作流

更新时间：2026-06-15

## 新对话先看这一段

项目根目录已新增 `D:\SVN\AGENTS.md`。新对话在 `D:\SVN` 工作区内处理 Roblox 武器模型下载打包时，应自动遵守这里的项目级规则。

## 固定触发语句

用户以后可能只发一条类似这样的消息：

```text
C:\Users\14176\Desktop\武器\模型下载\某个FBX或目录 生成可直接导入roblox版本
```

只要看到“FBX/GLB/模型下载目录路径”加“生成可直接导入 Roblox 版本 / Roblox 可导入版 / 可直接导入roblox”这类说法，Codex 必须直接运行固定脚本。不要重新写临时脚本，不要输出 `Roblox_Ready`，不要让用户手动找贴图。

用户以后会把 3D 模型网站下载的武器模型路径直接发给 Codex，路径可能是：

1. 一个具体 `.fbx` 文件。
2. 一个包含 `.fbx` 和贴图的下载目录。
3. 一个表面是 `.fbx`、实际是 ZIP 压缩包的 Meshy 下载文件。

Codex 的默认动作不是讲教程，而是直接打包成 Roblox 可导入版本：

```powershell
& "D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\scripts\Prepare-RobloxWeaponImport.ps1" `
  -InputPath "用户给的文件或目录路径" `
  -Name "武器名" `
  -OutputRoot "C:\Users\14176\Desktop\weapon_upload"
```

如果用户没有给武器名，Codex 可以根据目录名或文件名自动命名；如果用户给了明确编号或名称，就用用户给的名称。

## 这套流程解决什么

把 Meshy 或其他 3D 模型网站下载的武器模型，稳定整理成 Roblox Studio 能导入、能预览、能继续挂到 Tool/Accessory 的文件。

一句话：

```text
用户负责提供模型路径和在 Roblox Studio 里看效果；Codex 负责识别文件、打包、排错、记录。
```

## 三视图参考图生成规则

如果用户提供武器截图，并要求“生成同系列改款三视图 / 用于 3D AI 模型生成 / 注意图片一致性”，这不是 FBX / GLB 打包任务，应走独立三张三视图流程：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\三视图生成_独立三张流程.md
```

默认交付三张独立图片：

```text
*_front_view.png
*_side_view.png
*_back_view.png
```

不要默认只生成一张三视图合图再裁切。合图可以作为人工检查用的附加文件，但最终给 3D AI 的主交付必须是三张独立视角图。

从 2026-06-15 起，三视图任务必须先保护风格一致性。用户强调“重新生成 / 风格变了 / 用于 3D AI 建模”时，正式交付不要默认调用内置图像生成；优先使用本地可控渲染或绘制。内置图像生成如果出现无关信息图、图表、人物、咖啡、税表、文字海报或非武器内容，立即废弃该路线，不要把错误图写入 `generated_views`，也不要在最终回复中作为交付展示。

推荐输出目录：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\generated_views\武器名_日期_three_views
```

## 每把武器固定流程

1. 用户提供一个模型路径，可以是目录、真 FBX、或伪 FBX 压缩包。
2. Codex 先读本 README、`STATUS.md`、`Roblox导入_直接可用打包流程.md`。
3. Codex 运行 `Prepare-RobloxWeaponImport.ps1`。
4. 脚本自动找 FBX、找颜色贴图、压缩贴图、用 Blender 后台重新绑定材质。
5. Codex 验证输出：确认 `ROBLOX_WEAPON_EXPORT_OK`、面数、贴图尺寸、输出文件存在。
6. Codex 用可点击链接给用户导入文件，不只给裸路径。
7. 用户在 Roblox Studio 里按优先级导入。
8. 如果失败，用户发截图或报错，Codex 继续排查。
9. Codex 把结果写入 `工作记录.md`。

## 用户负责什么

- 提供下载目录或 FBX 文件路径。
- 在 Roblox Studio 里导入测试。
- 判断外形、贴图、比例是否能接受。
- 把失败截图或报错发给 Codex。

## Codex 负责什么

- 自动判断输入是目录、真 FBX、还是伪 FBX 压缩包。
- 从目录里自动选择主要 FBX。
- 从同目录或子目录里自动选择颜色贴图。
- 自动排除 `Roblox_Ready`、`Roblox_Import*`、`.fbm`、`*_roblox_direct` 等历史输出目录，避免误选失败文件。
- 避开 normal、roughness、metallic、emissive 等非颜色贴图。
- 把贴图压缩到 `1024x1024 jpg`，降低 Roblox 上传失败概率。
- 用 Blender 后台重新绑定材质。
- 输出直接可导入的 FBX / GLB。
- 保留 mesh-only 保底 FBX 和压缩贴图。
- 给用户可点击打开的输出文件链接。
- 更新工作记录和流程文档。

## 不再默认做什么

- 不让用户自己分开导入模型和贴图，除非直接 FBX / GLB 都失败。
- 不直接把 Meshy 原始 `.fbx` 拖进 Roblox。
- 不停留在“你可以试试”的说明层面。
- 不大面积手工修模型，除非用户明确要修。
- 不默认把高模硬压到 3000 面后说可用。

## 目标规格

- 面数：优先 `3000-4000 面`左右，但先以 Roblox 可导入为第一目标。
- 贴图：默认压缩为 `1024x1024 jpg`。
- 风格：Roblox 低模游戏资产。
- 交付：优先一个文件直接导入。

如果面数略高于目标范围，先给用户导入测试；只有用户要求严格控制时，再单独做 LOD4000。

## 输出文件

脚本输出目录一般是：

```text
C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct
```

重点文件：

```text
武器名_direct_1024tex.fbx   优先导入
武器名_direct_1024tex.glb   FBX 失败时备用
武器名_mesh_only.fbx        贴图仍失败时保底
武器名_texture_1024.jpg     手动贴图备用
README_import_order.txt     本次打包说明
```

## Roblox 导入顺序

1. 先导入 `*_direct_1024tex.fbx`。
2. 如果失败，导入 `*_direct_1024tex.glb`。
3. 如果还是失败，导入 `*_mesh_only.fbx`，再手动上传 `*_texture_1024.jpg`。

## 关键验证点

Codex 完成后至少要报告：

```text
faces=实际面数
texture=1024x1024 RGB JPG
direct_fbx generated
direct_glb generated
mesh_only_fbx generated
```

最终回复必须提供可点击链接，例如：

```md
- [打开输出文件夹](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct>)
- [优先导入 FBX](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct\武器名_direct_1024tex.fbx>)
```

## 文件说明

- `README.md`：总流程，新对话先读这个。
- `STATUS.md`：当前验证结果和下一步规则。
- `Roblox导入_直接可用打包流程.md`：一条命令打包细节。
- `Prompt_素材库.md`：三视图和低模 Prompt。
- `三视图生成_独立三张流程.md`：参考图生成时默认交付正视、侧视、背视三张独立图。
- `三视图失败复盘_风格一致性.md`：用户反馈风格不对时必须先读的纠偏规则。
- `Studio_纯色预览棚使用说明.md`：Roblox 预览棚说明。
- `工作记录.md`：每把武器的尝试结果。
- `handoff/NEXT_CHAT_HANDOFF_模型下载直接打包.md`：给新对话复制的交接入口。
- `handoff/NEXT_CHAT_HANDOFF_三视图独立生成.md`：给新对话复制的三视图参考图生成入口。
