# Tripo 多视图工作流

更新时间：2026-06-23

## 当前固定版本

版本：v1.1

状态：已固定，作为当前 Roblox / Tripo 低模武器多视图生产工作流使用。

固定范围：

1. 先生成并人工确认 1 张同系列改款 `front`。
2. `front` 通过后立刻作为唯一设计锁，不再回原图重新发散。
3. 先判断武器类型，再决定侧视规则：平面型、长柄枪头型、体块型。
4. 平面型侧视必须是真 90 度窄边；长柄枪头型侧视保留枪头结构但不露完整正面宝石；体块型侧视保留体积和侧向结构。
5. 左右侧视如果容易发散，优先生成一张合格侧视，再镜像另一侧。
6. 最终交付图必须是纯色背景，不允许保留视口地面线、渐变、场景、UI、坐标轴、阴影噪点或背景纹理。
7. 平面型武器的 `left / right` 侧视必须垂直居中，不允许继承正面的倾斜姿态、交叉姿态或 3/4 姿态。
8. 输出外层文件夹使用中文命名，内部图片保留 `front / back / left / right` 标准视图名。
9. 图像风格以 Tripo 建模可用为目标：低模大面、结构清楚、少毛刺、少碎裂，方便后续 Blender 精简。
10. 如果 Tripo 生成结果出现灰白素模、碎面、结构脏、材质不明显，不要第一时间判断为面数太低；优先生成一版“建模友好版四视图”作为补救输入。

后续维护原则：

只在出现新的稳定失败类型时更新本文件；单次偶发问题不立即扩展规则，避免工作流变臃肿。

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
侧视主体必须垂直居中，不能倾斜，不能沿用 front 的交叉 / 斜摆姿态。
如果 AI 生成的侧视不是垂直窄边，必须判定失败，不允许交付。
平面型侧视允许用确认后的 front 提取主体并压缩到固定垂直中轴线，再镜像另一侧；这比让 AI 重新猜侧视更稳。
如果是长枪 / 矛 / 戟这类长柄枪头型，侧视不能压成普通细针；枪头长度、护颈 / 枪托轮廓必须保留，只是宽度变窄。
```

### B. 长柄枪头型武器

这是平面型里的特殊类，需要单独处理侧视。

典型例子：

1. 长枪
2. 矛
3. 戟
4. 枪头较长、带宝石或护颈的长柄武器

判断标准：

1. 主体仍然是长杆 + 薄枪头，不是圆体块。
2. 主要识别点集中在枪头、宝石、护颈 / 枪托。
3. 侧视应变窄，但不能变成普通细针。

侧视规则：

```text
left / right 必须是真 90 度侧视。
枪头宽度要变窄，但枪头长度、侧面斜面轮廓、护颈 / 枪托外形必须保留。
正面宝石不能以完整正面形状露出来；只能变成窄边、被护颈遮住，或只露很薄的侧面厚度。
left 和 right 必须是相反方向，不允许两张都像同一侧。
如果左右结构基本对称，优先生成一张合格侧视，再镜像出另一侧。
```

### C. 体块型武器

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

最终交付背景要求：

```text
front / back / left / right 最终文件必须是纯色背景。
不允许出现视口地面线、墙地分界线、渐变背景、投影、坐标轴、UI、文字或背景纹理。
如果生成图背景不是纯色，必须先清理背景或重新生成，不能直接交付。
```

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
front 确认 -> back -> left 垂直细线侧视 -> mirror right
```

长柄枪头型武器：

```text
front 确认 -> back -> 生成一张合格侧视 -> 镜像另一侧
```

体块型武器：

```text
front 确认 -> 结构卡 -> 一张正交多视图板 -> 必要时裁成 back / left / right
```

体块型不建议分三次独立生成 back / left / right，因为每次独立生成都会重新猜测体积和遮挡关系。

确认某张多视图板后，只允许提取原图和裁切视图，不能为了拿到文件路径重新生成。
如果原图没有落盘，先从会话记录提取；提取不到就让用户重新上传确认图。

输出文件夹用中文命名，写清楚武器和类型，例如 `狼牙棒_圆体块四视图`。
内部图片文件保留标准视图名：`front / back / left / right`，方便后续喂给 Tripo 或脚本处理。

### 第 6 步：Tripo 结果不好时做建模友好版四视图

当 Tripo 已经根据四视图生成模型，但结果出现下面问题时，先不要把主因归结为面数太低：

1. 20000 面左右已经接近上限，但模型仍然灰白、材质没吃进去。
2. 武器头部变成脏乱碎面，护架、宝石、枪尖层级混在一起。
3. 正面轮廓基本抓到了，但厚度、插槽、连接关系错乱。
4. 侧视图没有帮助 AI 理解结构，反而让正面装饰被硬挤成立体碎片。

这类问题通常是“参考图结构信息不够建模友好”，不是单纯面数不足。

建模友好版不是更漂亮的概念图，而是给 Tripo 读结构的工程化参考图。

优先做这些简化：

1. 把小装饰、微小尖刺、复杂晶体切面、高频纹理全部减少。
2. 把主体拆成大块低模结构：枪尖是棱柱，护架是连续厚弧，宝石是简单凸起块。
3. 材质分区必须大而清楚：主金属、暗色插槽 / 柄部、发光或宝石色块分开。
4. 侧视图只表达厚度、插槽、连接柱和端帽，不展开正面宽护架。
5. 左右结构对称时，优先生成一张合格侧视，再镜像另一侧。
6. 四张正式图尽量保持相同尺寸；如果差 1px，也要统一后再上传。

触发后的补救流程：

```text
美术版四视图 -> Tripo 结果检查 -> 如果灰白 / 碎面 / 结构脏
-> 生成建模友好 front
-> 以建模友好 front 为唯一设计锁生成 back
-> 生成一张工程侧视 left
-> 镜像 right
-> 统一尺寸
-> 再喂给 Tripo 测试 20000 或 30000 面
```

不要做这些事：

1. 不要只把面数从 20000 往上加，期待它自动修复结构理解。
2. 不要继续增加装饰和复杂切面。
3. 不要让侧视图露出完整正面宝石或完整正面护架。
4. 不要把 contact sheet 当成正式四视图上传；正式上传仍然是四张独立 PNG。

本次霜蓝秘银三叉戟经验：

1. Tripo 生成结果约 18844 triangles / 9391 vertices，20000 面不是主要瓶颈。
2. 主要失败点是材质没有吃进去、头部结构碎裂、正面装饰和厚度关系被混淆。
3. 处理方式是重做一套建模友好版四视图，而不是继续堆面数。
4. 如果建模友好版仍然灰白素模，下一轮优先做“高对比纯色材质版”，而不是继续增加装饰。

建模友好版输出目录示例：

```text
输出内容\霜蓝秘银三叉戟_长柄枪头型建模友好版四视图
```

正式上传文件只用：

```text
*_model_friendly_front.png
*_model_friendly_back.png
*_model_friendly_left.png
*_model_friendly_right.png
```

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

The side profile must stand vertically on a centered vertical axis. Do not inherit the front view's tilted pose, crossed pose, diagonal lean, or spread-out silhouette. The side view should read as one narrow upright edge.

No 3/4 angle, no broad front face, no tilted pose, no diagonal pose, no crossed front pose, no new geometry, no extra side spikes.
```

长柄枪头型补充：

```text
For spear / lance / polearm heads, do not reduce the head into a plain needle. Keep the elongated spearhead length, side bevel silhouette, gold collar / socket outline, and bottom cap. The head should be narrow from the side, but still recognizable as the same spearhead.

Do not show the front-facing gem as a full visible front gem in side view. The gem may appear only as a thin edge, a tiny side sliver, or be hidden by the collar/socket.

Generate one clean true side view first. If the weapon is mostly symmetrical, mirror the approved side view for the opposite side instead of independently inventing another side.
```

### 建模友好版 Prompt 补充

当 Tripo 已经生成过一次，但结果灰白、碎面、材质不明显或结构脏时，在原 prompt 基础上加入下面约束。

Front 补充：

```text
This is a MODELING-FRIENDLY orthographic front view for Tripo.
Use large clean low-poly planes, simple prism blades, one continuous thick guard, clear sockets, simple raised crystal blocks, and readable material zones.
No tiny decorative spikes, no micro notches, no fragmented trim, no noisy texture.
This is an engineering-style 3D modeling reference, not a decorative concept-art upgrade.
```

Back 补充：

```text
It must look like the same simplified model rotated 180 degrees.
Rear details may be simpler, but total height, head position, guard thickness, sockets, grip rings, pommel, and material zones must match the front.
Keep large clean planes and clear object separation.
```

Side 补充：

```text
This is a true 90-degree engineering side view.
The broad front guard becomes a narrow thick edge.
The front crystal appears only as a thin side block.
Show thickness, sockets, collars, and handle alignment.
Do not show the full front spread, full front diamond gem, or broad front-facing guard.
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
SIDE_VIEW_NOT_VERTICAL
SIDE_VIEW_FRONT_POSE_INHERITED
SIDE_TOO_THIN_FOR_VOLUME_WEAPON
SIDE_VOLUME_MISSING
SIDE_SPIKES_MISSING
SIDE_FRONT_GEM_VISIBLE
LEFT_RIGHT_SAME_SIDE
LEFT_RIGHT_MISMATCH
MULTIVIEW_SHEET_INCONSISTENT
TEXT_UI_WATERMARK
BACKGROUND_NOT_SOLID
UNRELATED_IMAGE
TRIPO_GRAY_UNTEXTURED_MODEL
TRIPO_FRAGMENTED_HEAD_STRUCTURE
TRIPO_MATERIAL_ZONE_UNREADABLE
MODEL_FRIENDLY_FOUR_VIEW_REQUIRED
```

## 翠金毒藤双镰杖这次的缺陷记录

问题：

1. `left / right` 虽然被压窄，但继承了 `front` 的交叉和倾斜姿态，不是垂直侧视。
2. 初版背景保留了视口地面线 / 渐变背景，不符合 Tripo 输入的纯色背景要求。
3. AI 独立生成的平面型侧视容易变成 3/4 或斜摆姿态。

修正：

1. 平面型侧视必须垂直居中，主体沿固定中轴线站直。
2. 对平面型薄刃武器，合格侧视应接近一条垂直窄边，只保留厚度、边缘颜色和少量可见材质信息。
3. 如果 AI 侧视不垂直，优先从确认后的 `front` 提取主体并压缩到垂直中轴线，再镜像另一侧。
4. 最终 `front / back / left / right` 必须清理为纯色背景后再交付。

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
这把是平面型武器。先做同系列改款 front，我确认后，再基于它扩 back / left / right。left 和 right 必须是真 90 度、垂直居中、纯色背景的细线侧视；不允许倾斜、交叉姿态或 3/4 视图。
```

体块型武器：

```text
这把是圆体块武器。先做同系列改款 front，我确认后，先写结构卡，再生成一张正交多视图板。left / right 必须是真 90 度厚度侧视，侧面仍要接近圆鼓体积，并保留侧向尖刺。
```

Tripo 建模结果不好时：

```text
Tripo 生成结果灰白、碎面、结构脏。不要先加面数，基于已确认的美术版四视图做一套建模友好版四视图：减少装饰，强化大块低模结构、材质分区、厚度、插槽和连接关系。
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
