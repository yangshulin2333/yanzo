# UI 理解清单

读 Roblox GUI 时，必须按这张清单走。

## 1. 总结构

```text
ScreenGui
Root
Page / Window / Popup
TopBar
TabBar
Body
LeftPanel
RightPanel
List / Scroll
Button / Text / Icon
```

要说明哪些是共用层，哪些是页面独有层。

## 2. 当前状态

必须确认：

```text
1. 哪个页面 Visible = true
2. TitleText 当前文字
3. 当前选中 Tab 的 Image
4. 影响切页的 Attribute，例如 TargetAttrContent、CurrentAttrContent
5. 顶部点数区域、关闭按钮、重置按钮是否显示
```

## 3. 布局

必须检查：

```text
1. Position / Size 是否使用 Scale
2. AnchorPoint 是否适合居中
3. LeftPanel / RightPanel 是否基于父框架居中
4. 子控件是否贴边、越界、重叠
5. ZIndex 是否能保证按钮、文字在背景上方
```

## 4. 素材

必须检查：

```text
1. Image AssetId
2. SourceAsset 自定义属性
3. NormalImage / SelectedImage
4. 顶部分割线、面板背景、按钮底图是否漏掉
5. Icon 和 Text 是否分层清楚
```

## 5. Slice / 九宫格

拉伸图片必须检查：

```text
ScaleType = Slice
SliceCenter
SliceScale
```

如果没有美术给 Slice 参数，默认用图片边长的一半作为上下左右偏移，再转换成 Roblox 的 `Rect.new(left, top, imageW - right, imageH - bottom)`。

## 6. 滚动

ScrollingFrame 必须检查：

```text
CanvasSize
AutomaticCanvasSize
ScrollingDirection
ScrollBarThickness
VerticalScrollBarInset
ClipsDescendants
```

如果用户说“滑不到最底部”，优先看：

```text
1. AutomaticCanvasSize 是否为 Y
2. CanvasSize 是否足够
3. 最后一个子节点是否超出 Canvas
4. UIListLayout / UIPadding 是否参与计算
```

## 7. 文字

必须检查：

```text
TextScaled
TextXAlignment
TextYAlignment
TextStrokeTransparency
TextStrokeColor3
TextColor3
TextLabel 自己的 Size 是否够大
```

用户偏好：文字尽量用 Scale，TextSize 可以作为设计参考，但不要靠固定 TextSize 解决适配。

## 8. 编辑态点击切页

如果 Studio 编辑界面可以点按钮切页，要说明清楚来源：

```text
1. 是 Command Bar 脚本临时连接了 Button.Activated
2. 这不是正式运行时逻辑
3. Studio 重新打开后可能失效
4. 正式项目后续要单独做 UI Controller / LocalScript
```

