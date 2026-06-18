# Tripo多视图工作流

更新时间：2026-06-18

## 这份工作流解决什么问题

当你已经有一把 Roblox 低模武器，并且想做：

1. 同系列改款
2. 再生成稳定的 `front / back / left / right`
3. 最后喂给 `Tripo / 3D AI`

最容易出问题的地方不是提示词太短，而是流程顺序错了。

最常见错误：

1. 直接拿原图同时生成四视图，结果每张都像不同武器。
2. 还没确认改款正视图，就先扩其他视图。
3. 侧视图做成了半侧面，能看到大片正面轮廓。
4. “同系列改款”做成了“原武器复制”或者“完全换系列”。

## 一句话原则

```text
先锁一张改款正视图，再扩三张其他视图。
```

不要这样：

```text
原图 -> 同时生成 front/back/left/right
```

要这样：

```text
原图 -> 生成 1 张同系列改款 front -> 人工确认 -> 用这张 front 做唯一设计锁 -> 生成 back -> 生成 left -> 生成 right
```

## 什么叫“同系列改款”

不是：

1. 原武器换个角度。
2. 原武器只换一点颜色。
3. 完全做成另一类武器。

而是：

1. 保留家族 DNA。
2. 局部形状明显变化。
3. 一眼看出是同系列另一把，不是原件。

### 家族 DNA

每把武器先写 4 到 6 个必须保留的识别点。

例如：

```text
长柄
顶部双层重锤头
白色骨刺/石刺
木头 + 骨质 + 冷灰金属
上下尖锥端帽
```

### 改款位

每次只改 2 到 3 处：

1. 头部轮廓
2. 刺的数量和节奏
3. 金属连接结构
4. 柄部环扣
5. 配色轻微变化

如果一口气改太多，就会换系列。
如果几乎不改，就还是原武器。

## 标准流程

### 第 1 步：准备干净原图

要求：

1. 完整武器
2. 背景干净
3. 无手、无角色、无杂物
4. 尽量正视图
5. 不要叠太多文字和 UI

### 第 2 步：只做 1 张改款正视图

这一轮只做一件事：

```text
生成同系列改款 front
```

不要一开始就做：

1. 三视图
2. 四视图
3. 多个角度混合

#### 正视图目标

1. 还是同系列
2. 形状改得够明显
3. 颜色只轻微变化也可以
4. 保留 Roblox 低模截图感

### 第 3 步：人工确认正视图

确认标准：

1. 还是同一系列
2. 明显不是原件
3. 不会被误认成完全新系列
4. 低模感还在

如果形状已经对了，后面尽量不要再改形状。
只允许做轻微颜色微调。

### 第 4 步：把确认后的正视图当唯一设计锁

一旦 front 通过：

1. 不再回原图重新解释武器
2. 不再同时参考旧废稿
3. 后面的 back / left / right 全部只参考这张 front

## 其他三张怎么做

### Back

要求：

1. 必须是同一把武器的背面
2. 不是新设计
3. 不是重新发散
4. 允许背面贴图略简化
5. 但主结构、比例、位置、配色关系必须一致

### Left / Right

这是最容易错的地方。

真正的 `90°` 侧视图应该是：

1. 只看厚度
2. 接近一条竖线或窄轮廓
3. 不应该看到大片正面轮廓
4. 不应该是 `3/4` 视角

如果武器正面有大面积刃面、锤面、护手展开，到了侧视图必须压缩掉。
只能保留厚度和边缘信息。

## Prompt 写法

Prompt 不要只写：

```text
帮我做同系列改款
```

要拆成 4 段：

1. 任务是什么
2. 必须保留什么
3. 只改哪些地方
4. 明确禁止什么

### Front Prompt 模板

```text
Using the uploaded Roblox weapon screenshot as reference, generate ONE independent FRONT VIEW image of a same-series redesigned Roblox low-poly fantasy weapon for Tripo / 3D AI modeling.

Preserve the weapon family identity: <weapon type>, <overall ratio>, <main head/blade structure>, <signature parts>, <material relationship>.

Make it clearly different from the reference, not a near-copy. Change only these local design areas: <change 1>, <change 2>, <change 3>. Keep the same series identity, but make it obviously not the exact original weapon.

Keep the Roblox low-poly viewport screenshot feel: clean faceted planes, hand-painted texture look, readable silhouette, simple lighting, game-ready shape.

Full weapon visible, centered vertical orthographic front view, clean light background.
No text, no watermark, no UI, no character, no hand, no scene clutter, no high-poly ornament.
```

### Back Prompt 模板

```text
Using the accepted front-view weapon image as the exact design lock, generate ONE independent BACK VIEW image of the same Roblox low-poly fantasy weapon.

It must look like the same weapon rotated 180 degrees, not a new weapon. Preserve the same total height, proportions, major structure, material palette, and Roblox low-poly viewport screenshot feel.

The rear texture may be simpler, but the shape and skin must match the accepted front view.
```

### Side Prompt 模板

```text
Using the accepted front-view weapon image as the exact design lock, generate ONE independent LEFT/RIGHT 90-DEGREE SIDE VIEW image of the same Roblox low-poly fantasy weapon.

This must be a true orthographic 90-degree side profile, not a 3/4 view. Compress the front-facing structure into narrow side thickness only.

Do not show broad front faces. Keep only side-visible thickness and edge details.
```

## 失败类型

如果失败，优先给失败命名，不要整套一起推倒：

```text
FRONT_VIEW_NOT_APPROVED
VARIANT_DELTA_TOO_WEAK
STYLE_DRIFT
BACK_VIEW_SHAPE_MISMATCH
SIDE_VIEW_NOT_90_DEGREE
LEFT_RIGHT_MISMATCH
TEXT_UI_WATERMARK
UNRELATED_IMAGE
```

## 快速修正规则

1. Front 不对，只重做 front。
2. Front 一旦通过，不再改它。
3. Back 不对，只重做 back。
4. Left 不对，只重做 left。
5. Right 不对，只重做 right。
6. 侧视图一旦不是细线厚度，就说明它不是 90° 侧视，要重来。

## 两个已验证结论

### 结论 1

“同系列改款”阶段，最重要的是先把形状锁定。
颜色只要轻微变化就够了。

### 结论 2

很多武器的 `left / right` 真的应该非常窄。
如果侧视图还能看到正面大片轮廓，通常就是错的。

## 最短执行口令

下次你可以直接这样说：

```text
用这张武器图做同系列改款。
先只出 1 张 front。
我确认后，再基于它补 back / left / right。
left 和 right 必须是真正 90° 细线侧视。
```

## 交付边界

这份工作流只负责：

1. 同系列改款参考图
2. 四视图稳定生成
3. 给 Tripo / 3D AI 做输入

不负责：

1. Roblox FBX / GLB 打包
2. Blender 修模
3. Roblox Studio 导入问题
