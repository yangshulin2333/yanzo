# default.project.json 入门说明

## 它是干什么的

`default.project.json` 是 Rojo 的同步配置文件。

它不运行游戏。

它只告诉 Rojo：

```text
本地文件夹 A
同步到 Roblox Studio 里的位置 B
```

可以把它理解成一张“同步路线图”。

## 当前项目的配置

```json
{
  "name": "EatDemoReplica",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "Shared": {
        "$path": "src/ReplicatedStorage/Shared"
      },
      "Packages": {
        "$path": "Packages"
      }
    },
    "ServerScriptService": {
      "$path": "src/ServerScriptService"
    },
    "StarterPlayer": {
      "StarterPlayerScripts": {
        "$path": "src/StarterPlayer/StarterPlayerScripts"
      }
    }
  }
}
```

## 逐句解释

### name

```json
"name": "EatDemoReplica"
```

项目名字。

这个名字主要给 Rojo 显示用，不影响游戏逻辑。

### tree

```json
"tree": {
  "$className": "DataModel"
}
```

`DataModel` 就是 Roblox Studio 里的整个游戏根对象。

你在 Explorer 里看到的：

```text
Workspace
Players
ReplicatedStorage
ServerScriptService
StarterPlayer
StarterGui
...
```

这些都在 `DataModel` 下面。

## 当前真正同步了哪些地方

### ReplicatedStorage/Shared

```json
"ReplicatedStorage": {
  "Shared": {
    "$path": "src/ReplicatedStorage/Shared"
  }
}
```

意思是：

```text
本地:
D:\AI\Codex\Codex_ProjectFixed\Replica_Demo_RojoKnit\src\ReplicatedStorage\Shared

同步到 Studio:
ReplicatedStorage/Shared
```

所以这些文件会同步：

```text
src/ReplicatedStorage/Shared/EatDemoConfig.luau
src/ReplicatedStorage/Shared/InstanceUtil.luau
src/ReplicatedStorage/Shared/RemoteNames.luau
```

### ServerScriptService

```json
"ServerScriptService": {
  "$path": "src/ServerScriptService"
}
```

意思是：

```text
本地:
D:\AI\Codex\Codex_ProjectFixed\Replica_Demo_RojoKnit\src\ServerScriptService

同步到 Studio:
ServerScriptService
```

所以这些文件会同步：

```text
src/ServerScriptService/EatDemoServer.server.luau
src/ServerScriptService/Services/DataService.luau
src/ServerScriptService/Services/EatService.luau
src/ServerScriptService/Services/ShopService.luau
```

### StarterPlayer/StarterPlayerScripts

```json
"StarterPlayer": {
  "StarterPlayerScripts": {
    "$path": "src/StarterPlayer/StarterPlayerScripts"
  }
}
```

意思是：

```text
本地:
D:\AI\Codex\Codex_ProjectFixed\Replica_Demo_RojoKnit\src\StarterPlayer\StarterPlayerScripts

同步到 Studio:
StarterPlayer/StarterPlayerScripts
```

所以这些文件会同步：

```text
src/StarterPlayer/StarterPlayerScripts/EatDemoClient.client.luau
src/StarterPlayer/StarterPlayerScripts/ClientModules/UIController.luau
src/StarterPlayer/StarterPlayerScripts/ClientModules/ScanController.luau
```

## 为什么 test.lua 没同步

判断一个文件会不会同步，只看两个条件：

```text
1. 文件有没有保存到磁盘
2. 文件路径是不是在 default.project.json 的 $path 下面
```

### 不会同步的例子

```text
src/ReplicatedStorage/test.lua
```

不会同步。

原因：

```text
当前配置没有映射 src/ReplicatedStorage 整个目录。
当前只映射了 src/ReplicatedStorage/Shared。
```

### 会同步的例子

```text
src/ReplicatedStorage/Shared/test.luau
```

会同步。

它会出现在 Studio：

```text
ReplicatedStorage
└─ Shared
   └─ test
```

### 项目里建议用 luau

Roblox 新项目建议统一用：

```text
.luau
```

不要一会儿 `.lua`，一会儿 `.luau`。

当前项目统一用 `.luau`。

## 文件名怎么决定 Script 类型

| 本地文件名 | Studio 对象类型 |
|---|---|
| `Test.server.luau` | Script |
| `Test.client.luau` | LocalScript |
| `Test.luau` | ModuleScript |

例子：

```text
src/ServerScriptService/Test.server.luau
```

会变成：

```text
ServerScriptService/Test
类型：Script
```

```text
src/StarterPlayer/StarterPlayerScripts/Test.client.luau
```

会变成：

```text
StarterPlayer/StarterPlayerScripts/Test
类型：LocalScript
```

```text
src/ReplicatedStorage/Shared/Test.luau
```

会变成：

```text
ReplicatedStorage/Shared/Test
类型：ModuleScript
```

## 以后你新建文件怎么判断放哪里

| 目的 | 放哪里 |
|---|---|
| 服务端功能 | `src/ServerScriptService/Services/xxx.luau` |
| 服务端入口 Script | `src/ServerScriptService/xxx.server.luau` |
| 客户端功能 | `src/StarterPlayer/StarterPlayerScripts/ClientModules/xxx.luau` |
| 客户端入口 LocalScript | `src/StarterPlayer/StarterPlayerScripts/xxx.client.luau` |
| 双端共享配置 | `src/ReplicatedStorage/Shared/xxx.luau` |
| 地图和模型 | 现在先在 Roblox Studio 里做 |

## 正常启动流程

每次重新打开 Studio 前，先启动 Rojo server：

```powershell
cd D:\AI\Codex\Codex_ProjectFixed\Replica_Demo_RojoKnit
rojo serve default.project.json --address 127.0.0.1 --port 34872
```

然后：

```text
1. 打开 Roblox Studio
2. 打开项目
3. 打开 Rojo 插件
4. 点 Connect
5. 如果弹出同步列表，确认是当前项目后点 Accept
6. Play 测试
```

