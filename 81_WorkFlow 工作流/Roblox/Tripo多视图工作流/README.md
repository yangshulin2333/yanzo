# Tripo 多视图工作流

更新时间：2026-06-18

## 这份工作流解决什么问题

当已有一把 Roblox 低模武器，并且想做“同系列改款”后再喂给 Tripo / 3D AI 时，最容易失败的不是画得不够精细，而是视图之间不统一。

常见失败：

1. 原图直接生成四视图，结果每张像不同武器。
2. 还没确认改款正视图，就开始扩背面和侧面。
3. 把所有武器的侧视都当成“一条细线”，导致体块型武器丢结构。
4. “同系列改款”变成原武器复制，或者变成完全新系列。

核心原则：

```text
先锁 1 张同系列改款 front，再根据武器类型决定怎么扩 back / left / right。
```

## 第 0 步：先判断武器类型

扩视图之前，必须先判断这把武器属于哪一类。

### A. 平面型武器

适合原来的四视图 lockstep 流程。

典型例子：

1. 剑
2. 刀
3. 镰刀
4. 斧刃很薄的斧子
5. 主体是大面积薄刃片的法器

判断标准：

1. 正面轮廓是主要识别点。
2. 侧面主要只显示厚度。
3. 90 度侧视从人类视觉上接近一条细线或窄边。

侧视规则：

```text
left / right 必须是真 90 度侧视。
主体应压缩成窄边缘，只保留厚度和边缘细节。
不能出现大面积正面轮廓。
```

### B. 体块型武器

不能直接套“细线侧视”规则。

典型例子：

1. 狼牙棒
2. 锤子
3. 法杖头
4. 圆球 / 圆鼓 / 桶形武器头
5. 环绕尖刺或环绕装饰的武器

判断标准：

1. 主体不是薄片，而是圆柱、圆鼓、球体、盒体或厚重体块。
2. 正面看到的不是唯一轮廓，侧面也应该有体积。
3. 尖刺、金属环、鼓面厚度等结构会围绕主体分布。

侧视规则：

```text
left / right 仍然必须是真 90 度侧视，但不能压成一条线。
侧视要显示主体厚度。
圆体块武器（狼牙棒、球锤、圆鼓锤）侧视也要接近圆鼓体积，宽度只略窄于正面 / 背面。
扁体块武器才允许侧视明显变窄。
环绕结构中真正位于侧面的尖刺必须保留。
正面和背面的尖刺可以被遮挡或压缩，但不能把整套尖刺系统删掉。
```

## 标准流程

### 第 1 步：准备干净原图

要求：

1. 完整武器。
2. 背景干净。
3. 无手、无角色、无多余道具。
4. 尽量接近正视图。
5. 不要叠太多 UI 或文字。

### 第 2 步：只生成 1 张同系列改款 front

这一轮只做一件事：

```text
生成同系列改款 front。
```

同系列改款的判断：

1. 保留家族 DNA。
2. 局部形状明显变化。
3. 一眼能看出是同系列另一把，不是原件。
4. 颜色可以轻微变化，但不要靠颜色掩盖形状没变。

家族 DNA 建议写 4 到 6 条：

```text
长柄
顶部双层重锤头
白色骨刺 / 石刺
木头 + 骨质 + 冷灰金属
上下尖锥端帽
```

### 第 3 步：人工确认 front

front 通过后，立刻把它升级为“唯一设计锁”。

后续规则：

1. 不再回原图重新解释武器。
2. 不再混用之前失败的草图。
3. back / left / right 全部只参考这张确认后的 front。
4. 如果形状已经对了，后面尽量只做颜色微调，不再改大结构。

### 第 4 步：体块型武器先写结构卡

如果武器是狼牙棒、锤子、法杖头这类体块型，front 通过后必须先写结构卡。

结构卡要写清楚：

1. 主体体积是什么形状。
2. 有几层主要结构。
3. 每层尖刺大概分布在哪些方向。
4. 哪些结构在背面必须出现。
5. 侧视时哪些结构必须保留。

狼牙棒结构卡示例：

```text
武器类型：双层长柄狼牙棒。
主体：上下两层木质圆鼓 / 短桶形锤头，上层略大，下层略小。
尖刺：每层都有白色骨质主刺，左右侧各有可见侧向尖刺，前后方向尖刺在侧视中可以被遮挡或压缩。
连接：两层锤头之间有冷灰金属环或短连接颈。
柄部：长直木柄，带少量金属环扣。
端帽：顶部和底部都有灰白尖锥端帽。
禁止：侧视不能删除侧向尖刺，不能把圆鼓锤头压成一条线，不能新增完全不同的刺阵。
```

### 第 5 步：根据类型扩视图

平面型武器：

```text
front 确认 -> back -> left 细线侧视 -> right 细线侧视
```

体块型武器：

```text
front 确认 -> 结构卡 -> 一张正交多视图板 -> 必要时裁成 back / left / right
```

体块型不建议分三次独立生成 back / left / right，因为每次独立生成都会重新猜测体积和遮挡关系。

确认某张多视图板后，只允许提取原图和裁切视图，不能为了拿到文件路径重新生成。
如果原图没有落盘，先从会话记录提取；提取不到就让用户重新上传确认图。

## Prompt 模板

### Front Prompt

```text
Using the uploaded Roblox weapon screenshot as reference, generate ONE independent FRONT VIEW image of a same-series redesigned Roblox low-poly fantasy weapon for Tripo / 3D AI modeling.

Preserve the weapon family identity: <weapon type>, <overall ratio>, <main head/blade structure>, <signature parts>, <material relationship>.

Make it clearly different from the reference, not a near-copy. Change only these local design areas: <change 1>, <change 2>, <change 3>. Keep the same series identity, but make it obviously not the exact original weapon.

Keep the Roblox low-poly viewport screenshot feel: clean faceted planes, hand-painted texture look, readable silhouette, simple lighting, game-ready shape.

Full weapon visible, centered vertical orthographic front view, clean light background.
No text, no watermark, no UI, no character, no hand, no scene clutter, no high-poly ornament.
```

### 平面型 Side Prompt

```text
Using the accepted front-view weapon image as the exact design lock, generate ONE independent LEFT/RIGHT 90-degree side view image of the same Roblox low-poly fantasy weapon.

This is a flat weapon type. The side view should be a true thin side profile. Compress the front-facing blade/head details into a narrow side edge. Keep only thickness and edge details.

No 3/4 angle, no broad front face, no new geometry, no extra side spikes.
```

### 体块型 Side Prompt

```text
Using the accepted front-view weapon image as the exact design lock, generate ONE independent LEFT/RIGHT 90-degree side view image of the same Roblox low-poly fantasy weapon.

This is a volume weapon type, not a flat blade. If the weapon head is a round mace / round drum / ball hammer, the side view must remain bulky and round, with width close to the front/back view, only slightly narrower due to true 90-degree rotation. Do not flatten it into an oval plate or a thin line.

Preserve side-visible structural parts: side-facing spikes, metal rings, handle alignment, top cap, bottom cap, and the same material palette.

Front-facing and back-facing details may be hidden or compressed by the 90-degree rotation, but do not remove the whole spike system or simplify the weapon into a plain stick.

No 3/4 angle, no new spike pattern, no missing side spikes, no broad front face, no concept art style.
```

### 体块型多视图板 Prompt

```text
Using the accepted front-view weapon image as the exact design lock, create one clean orthographic multi-view reference sheet for the same Roblox low-poly weapon.

Show exactly four views in one image: FRONT, BACK, LEFT 90-degree SIDE, RIGHT 90-degree SIDE.

This is one same weapon rotated, not four redesigns. Keep the same total height, handle length, head position, material palette, wood texture, metal rings, bone spikes, top cap, and bottom cap.

Volume structure lock: <paste structure card here>.

For side views, keep round-volume weapons bulky and round. A mace head should still look like a round drum / short cylinder from the side, with width close to the front/back view, not a flat oval plate or thin line. Preserve side-facing spikes. Front-facing and back-facing spikes may be partially hidden or compressed.

Roblox low-poly viewport screenshot feel, clean light background, full weapon visible, centered.
No text labels on the weapon, no watermark, no UI, no character, no hand, no 3/4 views, no new geometry, no missing side spikes.
```

## 失败类型

记录失败时只记主因，方便下一轮修正。

```text
FRONT_VIEW_NOT_APPROVED
VARIANT_DELTA_TOO_WEAK
STYLE_DRIFT
BACK_VIEW_SHAPE_MISMATCH
SIDE_VIEW_NOT_90_DEGREE
SIDE_TOO_THIN_FOR_VOLUME_WEAPON
SIDE_VOLUME_MISSING
SIDE_SPIKES_MISSING
LEFT_RIGHT_MISMATCH
MULTIVIEW_SHEET_INCONSISTENT
TEXT_UI_WATERMARK
UNRELATED_IMAGE
```

## 狼牙棒这次的缺陷记录

问题：

1. left / right 被当成平面型武器处理，侧视压得过细。
2. 侧视 prompt 里强调了 `thin side edge` 和 `no extra side spikes`，导致 AI 把侧向尖刺也删掉。
3. front 只能锁正面轮廓，不能自动锁定环绕尖刺的空间分布。

修正：

1. 狼牙棒归类为圆体块武器，不是扁体块武器。
2. 侧视必须接近圆鼓 / 短圆柱体积，宽度只略窄于正面 / 背面。
3. 侧向尖刺是结构，不是额外装饰，必须保留。
4. 体块型优先生成一张多视图板，再裁图。

## 最短执行口令

平面型武器：

```text
这把是平面型武器。先做同系列改款 front，我确认后，再基于它扩 back / left / right。left 和 right 必须是真 90 度细线侧视。
```

体块型武器：

```text
这把是圆体块武器。先做同系列改款 front，我确认后，先写结构卡，再生成一张正交多视图板。left / right 必须是真 90 度厚度侧视，侧面仍要接近圆鼓体积，并保留侧向尖刺。
```

## 交付边界

这份工作流只负责：

1. 同系列改款参考图。
2. Tripo / 3D AI 建模前的多视图输入。
3. 平面型和体块型武器的视图生成规则。

不负责：

1. Roblox FBX / GLB 打包。
2. Blender 修模。
3. Roblox Studio 导入问题。
