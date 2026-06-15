# Roblox 导入打包流程

更新时间：2026-06-07

## 什么时候用

用户给出 3D 模型网站下载的武器模型路径时，直接用这个流程。

最高优先级触发语句：

```text
生成可直接导入roblox版本
生成可直接导入 Roblox 版本
生成 Roblox 可导入版
生成 Roblox 可导入 FBX
可直接导入roblox
```

用户只要把这些话和一个本地模型路径一起发来，就不要重新写脚本，不要输出 `Roblox_Ready`，直接运行本流程的一条命令。

适用输入：

1. 下载目录。
2. 真 FBX 文件。
3. 表面是 `.fbx`、实际是 ZIP 压缩包的 Meshy 下载文件。

## 一条命令处理

用户给目录时，直接把目录放进 `-InputPath`：

```powershell
& "D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\scripts\Prepare-RobloxWeaponImport.ps1" `
  -InputPath "C:\Users\14176\Desktop\武器\模型下载\某个下载目录" `
  -Name "武器名或编号" `
  -OutputRoot "C:\Users\14176\Desktop\weapon_upload"
```

用户给具体 FBX 时，也可以直接放进 `-InputPath`：

```powershell
& "D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\scripts\Prepare-RobloxWeaponImport.ps1" `
  -InputPath "C:\Users\14176\Desktop\武器\模型下载\某个下载目录\模型文件.fbx" `
  -Name "武器名或编号" `
  -OutputRoot "C:\Users\14176\Desktop\weapon_upload"
```

换新武器时，通常只改：

```text
-InputPath
-Name
```

如果用户没给 `-Name`，脚本会用目录名或文件名自动生成输出名。

## 脚本现在会做什么

1. 判断 `InputPath` 是目录还是文件。
2. 如果是目录，递归查找主要 `.fbx`，默认选体积最大的 FBX。
3. 查找时排除 `Roblox_Ready`、`Roblox_Import*`、`.fbm`、`*_roblox_direct` 等历史输出目录，避免误选失败文件。
4. 如果是文件，判断是否为 ZIP 伪装包。
5. 如果是 ZIP 伪装包，自动解压并找真正的 FBX。
6. 自动寻找颜色贴图。
7. 贴图选择优先级：
   - 与 FBX 同目录优先。
   - 文件名包含 `basecolor`、`albedo`、`diffuse`、`color`、`texture` 优先。
   - 文件名包含 `normal`、`roughness`、`metallic`、`emissive`、`ao`、`height` 的贴图降权。
8. 把颜色贴图压成 `1024x1024 jpg`。
9. 用 Blender 后台导入 FBX。
10. 重新创建材质并绑定压缩贴图。
11. 加 `Weighted Normal` 预览优化。
12. 导出 Roblox 用文件。

## 输出

输出目录一般是：

```text
C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct
```

里面重点看这几个：

```text
武器名_direct_1024tex.fbx
武器名_direct_1024tex.glb
武器名_mesh_only.fbx
武器名_texture_1024.jpg
README_import_order.txt
```

## Roblox 里怎么导

优先级：

1. 导入 `武器名_direct_1024tex.fbx`。
2. 如果失败，导入 `武器名_direct_1024tex.glb`。
3. 如果还是失败，导入 `武器名_mesh_only.fbx`。
4. 最后再手动上传 `武器名_texture_1024.jpg`。

## Codex 输出给用户时必须这样做

不要只给裸路径。要给可点击链接：

```md
- [打开输出文件夹](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct>)
- [优先导入 FBX](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct\武器名_direct_1024tex.fbx>)
- [备用 GLB](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct\武器名_direct_1024tex.glb>)
- [保底 mesh-only FBX](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct\武器名_mesh_only.fbx>)
- [压缩贴图 JPG](<C:\Users\14176\Desktop\weapon_upload\武器名_roblox_direct\武器名_texture_1024.jpg>)
```

同时报告：

```text
faces=实际面数
texture=1024x1024 RGB JPG
direct_fbx generated
direct_glb generated
mesh_only_fbx generated
```

## 如何判断问题

如果 Roblox 报：

```text
base_color_texture 上传失败
```

优先判断是贴图/材质上传问题。

处理顺序：

1. 先试 `direct_1024tex.fbx`。
2. 再试 `direct_1024tex.glb`。
3. 再试 `mesh_only.fbx + 手动 texture_1024.jpg`。
4. 如果 mesh-only 都导不进去，再考虑面数、FBX 版本、模型结构、Roblox 导入器兼容问题。

## 验证记录放哪里

具体某一把武器的输入、输出、面数、失败原因、解决方式，统一写入：

```text
D:\SVN\Project_Analysis_Package\Roblox 武器模型制作工作流\工作记录.md
```

主流程文档只保留通用规则，不绑定某个具体模型。
