---
type: resource
status: processing
source: youtube
tags:
  - type/resource
  - source/youtube
  - status/processing
---

`00_` 只是**排序前缀**。

因为文件夹默认按名字排序，如果不用数字，文件夹会按中文/英文顺序乱排。加数字后，你可以控制顺序：

```text
00_Inbox      永远排最前，方便随手丢东西
10_Projects   排第二
20_Areas      排第三
30_MOC        排第四
...
90_Archive    永远排最后
```

中间故意用 `10、20、30`，不是 `1、2、3`，是为了以后方便插入新分类。比如以后想加一个 `15_Tasks`，不用整体改名。

---

你截图里这个地方有个问题：你现在写的是普通正文，不是 Obsidian 的属性区。

你现在是：

```markdown
tags:
  - type/resource
  - source/youtube
  - status/processing
```

但因为上面没有 `---`，所以 Obsidian 把它当成普通文字显示了。

正确写法应该是放在笔记最顶部：

```markdown
---
type: resource
status: processing
source: youtube
tags:
  - type/resource
  - source/youtube
  - status/processing
---
```

然后下面才是正文：

```markdown
# Obsidian GitHub 免费同步方案

这个视频讲的是用 [[GitHub]]、[[Git]] 和 [[Obsidian Git]] 实现 [[Obsidian]] 免费同步。
```

也就是说，完整应该像这样：

```markdown
---
type: resource
status: processing
source: youtube
tags:
  - type/resource
  - source/youtube
  - status/processing
---

# Obsidian GitHub 免费同步方案

这个视频讲的是用 [[GitHub]]、[[Git]] 和 [[Obsidian Git]] 实现 [[Obsidian]] 免费同步。

## 所属 MOC
- [[Obsidian MOC]]
- [[知识管理 MOC]]
- [[同步与备份 MOC]]
```

---

`type` 是“这篇笔记是什么类型”。

常用就这几个：

```text
resource   外部资料，比如视频、文章、课程、书籍摘录
note       你自己总结出来的知识点
project    正在做的项目
moc        内容地图
area       长期领域
template   模板
```

你这篇 `Obsidian GitHub 免费同步方案` 来自 YouTube 视频，所以它的 `type` 应该是：

```yaml
type: resource
```

意思是：这是一份“外部资料笔记”。

如果你之后根据它总结出自己的方法，比如写一篇：

```text
我的 Obsidian GitHub 同步工作流
```

那篇才更适合：

```yaml
type: note
```

因为那是你自己消化后的知识。

---

`status` 是“这篇笔记现在处理到哪一步”。

常用状态：

```text
inbox        刚收进来，还没整理
processing   正在整理
summarized    已经总结过
evergreen     已经沉淀成长期笔记
done          项目/任务完成
archive       归档
```

你现在这篇视频笔记，如果只是刚开始记，可以是：

```yaml
status: processing
```

如果你已经把视频总结完了，可以改成：

```yaml
status: summarized
```

---

`tags` 是给 Obsidian 搜索和筛选用的标签。

你现在这样写是对的方向：

```yaml
tags:
  - type/resource
  - source/youtube
  - status/processing
```

但注意：`type`、`status`、`source` 已经单独写成属性了，`tags` 里再写一遍不是必须。

你可以先用更简单的版本：

```markdown
---
type: resource
status: processing
source: youtube
tags:
  - obsidian
  - sync
---
```

但我个人更推荐你一开始统一成这样，清晰：

```markdown
---
type: resource
status: processing
source: youtube
tags:
  - type/resource
  - source/youtube
  - status/processing
---
```

---

“挂到 MOC”是什么意思？

MOC 就是“主题目录页”。

比如你有一篇：

```text
30_MOC 内容地图/Obsidian MOC.md
```

里面写：

```markdown
# Obsidian MOC

## 同步与备份
- [[Obsidian GitHub 免费同步方案]]
- [[Obsidian Git]]
- [[GitHub]]
- [[Git]]

## 插件
- [[Custom Attachment Location]]
- [[Enhancing Export]]

## 基础概念
- [[Markdown]]
- [[双向链接]]
- [[Properties 属性]]
```

这就叫“把笔记挂到 MOC”。

不是移动文件。  
不是复制文件。  
只是**在 MOC 这篇目录笔记里，加一个链接指向它**。

你的这篇笔记现在在 `60_Templates 模板` 里，这个位置不太对。它不是模板，而是一篇视频资料笔记。建议移动到：

```text
40_Resources 资料/YouTube/Obsidian GitHub 免费同步方案.md
```

然后在：

```text
30_MOC 内容地图/Obsidian MOC.md
```

里面加一行：

```markdown
- [[Obsidian GitHub 免费同步方案]]
```

这就完成了“挂到 MOC”。

---

你现在可以这样操作：

1. 把这篇笔记从 `60_Templates 模板` 移到：

```text
40_Resources 资料/YouTube/
```

如果没有 `YouTube` 文件夹，就在 `40_Resources 资料` 下面新建一个。

2. 打开这篇笔记，把最顶部改成：

```markdown
---
type: resource
status: processing
source: youtube
tags:
  - type/resource
  - source/youtube
  - status/processing
---

# Obsidian GitHub 免费同步方案
```

3. 正文里写：

```markdown
这个视频讲的是用 [[GitHub]]、[[Git]] 和 [[Obsidian Git]] 实现 [[Obsidian]] 免费同步。
```

4. 打开 `Obsidian MOC`，加上：

```markdown
## 同步与备份
- [[Obsidian GitHub 免费同步方案]]
- [[GitHub]]
- [[Git]]
- [[Obsidian Git]]
```

这样这篇笔记就同时完成了：

```text
文件夹：放在 40_Resources/YouTube
标签：标记它是 YouTube 资料，正在整理
链接：连接 GitHub / Git / Obsidian Git / Obsidian
MOC：出现在 Obsidian MOC 的同步与备份栏目里
```