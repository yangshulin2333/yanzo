# VSCode + Rojo 工作流说明

## 是否必须用 VSCode

不是必须，但建议从现在开始使用。

原因很简单：

```text
Rojo 负责同步
VSCode 负责编辑源码
Roblox Studio 负责场景、Play 测试、发布
```

如果继续在 Studio 里大段改脚本，Rojo 的价值会下降，而且容易出现 Studio 版本和本地源码不一致。

## 推荐工作方式

以后改代码按这个顺序：

```text
1. 用 VSCode 打开 D:\AI\Codex\Codex_ProjectFixed\Replica_Demo_RojoKnit
2. 修改 src 里的 .luau 文件
3. 保存文件
4. Rojo 自动/手动同步到 Roblox Studio
5. 在 Studio 里 Play 测试
6. 测试通过后再继续下一步
```

## VSCode 里重点看哪些目录

```text
src/ReplicatedStorage/Shared
src/ServerScriptService/EatDemoServer.server.luau
src/ServerScriptService/Services
src/StarterPlayer/StarterPlayerScripts/EatDemoClient.client.luau
src/StarterPlayer/StarterPlayerScripts/ClientModules
```

## Studio 以后主要做什么

Studio 主要负责：

```text
1. 场景、地图、模型、UI 可视化检查
2. Play 测试
3. Output 报错观察
4. 发布到 Roblox
5. 配置权限、资产、Developer Product
```

不建议在 Studio 里做：

```text
1. 大段改脚本
2. 同时改多个 ModuleScript
3. 临时复制旧代码覆盖新代码
```

## 推荐安装的 VSCode 扩展

优先级从高到低：

| 扩展 | 用途 |
|---|---|
| Luau Language Server | Luau 语法提示、类型提示、跳转定义 |
| Rojo | Rojo 项目辅助 |
| StyLua | Lua/Luau 格式化 |

如果你暂时不想装扩展，也可以先只用 VSCode 当普通文本编辑器。

## 文件修改规则

| 要改什么 | 优先改哪里 |
|---|---|
| 服务端吃食物逻辑 | `src/ServerScriptService/Services/EatService.luau` |
| 玩家数据 / leaderstats | `src/ServerScriptService/Services/DataService.luau` |
| Speed / Size / Auto 服务端 | `src/ServerScriptService/Services/ShopService.luau` |
| Bag / FoodCore 服务端 | `src/ServerScriptService/Services/InventoryService.luau` |
| Reward 服务端 | `src/ServerScriptService/Services/RewardService.luau` |
| UI 样式和布局 | `src/StarterPlayer/StarterPlayerScripts/ClientModules/UIController.luau` |
| 吃食物扫描 | `src/StarterPlayer/StarterPlayerScripts/ClientModules/ScanController.luau` |
| 体型变化 | `src/StarterPlayer/StarterPlayerScripts/ClientModules/CharacterScaleController.luau` |
| 音效/特效反馈 | `src/StarterPlayer/StarterPlayerScripts/ClientModules/FeedbackController.luau` |

## 当前阶段不要做

```text
不要马上引入 Knit
不要马上接 Robux
不要直接删除现有 Remote
不要把旧项目无权限 AssetId 重新塞回来
```

## 判断 VSCode + Rojo 工作流是否正常

做一个小测试即可：

```text
1. 在 VSCode 改一个不会影响玩法的注释
2. 保存
3. Studio Rojo 面板出现同步变化
4. Accept
5. Play 后功能正常
```

## 你现在最容易混淆的点

一句话版本：

```text
VSCode 改本地源码，Rojo 把本地源码同步到 Studio，Studio 负责测试和编辑场景。
```

更准确地说：

| 问题 | 结论 |
|---|---|
| 后续脚本代码在哪里改？ | 优先在 VSCode 里改 `D:\AI\Codex\Codex_ProjectFixed\Replica_Demo_RojoKnit\src` |
| VSCode 新建 Script 会不会进 Studio？ | 会，但前提是文件建在 Rojo 已映射的目录里 |
| VSCode 保存后会不会自动同步？ | Rojo server 正在运行、Studio Rojo 插件已连接时，会同步；有时 Studio 会弹出变更列表让你 Accept |
| Studio 里改脚本会不会自动回到 VSCode？ | 不会。当前工作流是本地文件到 Studio，基本不要反向改大段脚本 |
| Workspace 会不会同步？ | 现在不会，因为 `default.project.json` 没有映射 Workspace |
| 是不是只同步 `src`？ | 当前主要同步 `src`，另外 `Packages` 也映射到了 `ReplicatedStorage/Packages` |

当前 Rojo 配置只同步这些位置：

```text
src/ReplicatedStorage/Shared
→ Studio: ReplicatedStorage/Shared

Packages
→ Studio: ReplicatedStorage/Packages

src/ServerScriptService
→ Studio: ServerScriptService

src/StarterPlayer/StarterPlayerScripts
→ Studio: StarterPlayer/StarterPlayerScripts
```

所以你以后新建脚本时按这个规则：

```text
服务端功能模块
→ 新建在 src/ServerScriptService/Services

客户端功能模块
→ 新建在 src/StarterPlayer/StarterPlayerScripts/ClientModules

客户端入口脚本
→ 改 src/StarterPlayer/StarterPlayerScripts/EatDemoClient.client.luau

服务端入口脚本
→ 改 src/ServerScriptService/EatDemoServer.server.luau

双端共享配置
→ 新建或修改 src/ReplicatedStorage/Shared
```

Workspace 里的地图、模型、Part、装饰物，当前仍然在 Studio 里做。
如果以后要让 Workspace 也由 VSCode/Rojo 管理，需要单独在 `default.project.json` 里加映射；现在先不做，避免 Rojo 接管场景时误删或覆盖 Studio 里的对象。
