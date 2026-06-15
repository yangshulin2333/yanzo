# 当前状态

更新时间：2026-06-15

## 当前流程状态

Roblox 武器模型打包流程已经升级为通用流程：

```text
用户给下载目录 / 真 FBX / 伪 FBX ZIP
-> Codex 运行脚本自动识别
-> 自动找主要 FBX 和颜色贴图
-> 压缩贴图到 1024 JPG
-> Blender 后台重新绑定材质
-> 输出 Roblox 直接导入 FBX / GLB / mesh-only 保底
```

新对话里，用户只要给 3D 模型网站下载路径，Codex 应该直接按这个流程处理，不要重新讲教程，也不要要求用户手动找文件。

具体模型案例只写在 `工作记录.md`，不要让主流程依赖某个具体模型。

## 已验证能力

已验证脚本可以处理：

1. 下载目录：目录里包含 `.fbx` 和贴图。
2. 真 FBX 文件：同目录或子目录有颜色贴图。
3. 伪 FBX ZIP：表面扩展名是 `.fbx`，实际文件头是 `PK`。

已验证脚本会输出：

```text
*_direct_1024tex.fbx
*_direct_1024tex.glb
*_mesh_only.fbx
*_texture_1024.jpg
README_import_order.txt
```

## 当前固定规则

0. 看到用户发模型路径并说“生成可直接导入roblox版本 / Roblox 可导入版 / 可直接导入 Roblox”时，必须直接进入本流程。
1. 用户给模型路径后，先直接运行脚本，不要让用户自己拆包、找贴图、分开导入。
2. `InputPath` 可以是目录、真 FBX 文件、或 Meshy 伪 FBX ZIP 包。
3. 优先给用户 `*_direct_1024tex.fbx`。
4. FBX 不行再试 `*_direct_1024tex.glb`。
5. 分开导入模型和贴图只是最后保底。
6. 最终回复必须给可点击链接，不要只给裸路径。
7. 每次成功或失败都要更新 `工作记录.md`。

## 三视图生成状态

参考图生成流程已升级为“独立三张优先”：

```text
用户给武器截图并要求同系列改款三视图
-> Codex 先写共用设计锁定
-> 分别生成 front / side / back 三张独立图
-> 合图只作为可选人工检查图
-> 输出可点击链接并更新工作记录
```

固定流程文档：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\三视图生成_独立三张流程.md
```

默认输出目录：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\generated_views\武器名_日期_three_views
```

2026-06-15 已补充错误图隔离与风格保护规则：三视图正式交付不再默认先调用内置图像生成。若出现无关信息图、图表、人物、咖啡、税表、文字海报或武器风格明显漂移，立即废弃候选并切换到本地可控渲染 / 绘制流程；重生成版本使用 `_v2_`、`_v3_` 目录保留追溯。

## 下一把武器怎么做

用户可能会直接发：

```text
C:\Users\14176\Desktop\武器\模型下载\某个下载目录
```

Codex 执行：

```powershell
& "D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\scripts\Prepare-RobloxWeaponImport.ps1" `
  -InputPath "用户给的文件或目录路径" `
  -Name "武器名或编号" `
  -OutputRoot "C:\Users\14176\Desktop\weapon_upload"
```

然后验证：

```text
ROBLOX_WEAPON_EXPORT_OK
faces=实际面数
texture=1024x1024 RGB JPG
direct_fbx generated
direct_glb generated
mesh_only_fbx generated
```

最后回复：

```md
- [打开输出文件夹](<...>)
- [优先导入 FBX](<...direct_1024tex.fbx>)
- [备用 GLB](<...direct_1024tex.glb>)
- [保底 mesh-only FBX](<...mesh_only.fbx>)
- [压缩贴图 JPG](<...texture_1024.jpg>)
```

## 关键路径

总流程：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\README.md
```

打包脚本：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\scripts\Prepare-RobloxWeaponImport.ps1
```

打包细节：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\Roblox导入_直接可用打包流程.md
```

新对话交接：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\handoff\NEXT_CHAT_HANDOFF_模型下载直接打包.md
```
