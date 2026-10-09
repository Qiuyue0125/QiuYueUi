// 本文件集中提供全部主题配色和控件交互状态颜色
pragma Singleton

import QtQuick

// 集中提供全部主题配色和控件交互状态颜色
QtObject {
    // 公共窗口和浮层统一使用这些尺寸
    readonly property int windowRadius: 6
    readonly property int dialogRadius: 6
    // Shared component defaults
    readonly property int windowResizeBorderWidth: 6
    readonly property int windowResizeCornerSize: 10
    readonly property int titleBarHeight: 42
    readonly property int dialogHeaderHeight: 44
    readonly property int notificationMaximumWidth: 360
    readonly property int notificationDisplayDuration: 2250
    readonly property int toolTipDelay: 100
    readonly property int toolTipTimeout: 5000
    readonly property int sidebarWidth: 270
    readonly property int sidebarMinimumWidth: 180
    readonly property int sidebarMaximumWidth: 480
    readonly property int sidebarResizeHandleWidth: 8
    readonly property int comboPopupMaximumHeight: 260
    readonly property int dividerThickness: 2
    readonly property int iconButtonSize: 30
    readonly property int navigationButtonSize: 44
    readonly property int windowButtonSize: 40
    readonly property int compactRadius: 3
    readonly property int iconRadius: 1
    readonly property int toolTipMaximumWidth: 520
    readonly property real borderWidth: 1.0
    readonly property real iconBorderWidth: 1.5
    // 全局间距令牌，保持页面控件之间的节奏一致
    readonly property int spacingXs: 4
    readonly property int spacingSm: 6
    readonly property int spacingMd: 8
    readonly property int spacingLg: 10
    readonly property int spacingXl: 12
    readonly property int spacing2xl: 14
    readonly property int spacing3xl: 18
    // 全局文字尺寸令牌，替代页面中的重复字面量
    readonly property int fontCaption: 11
    readonly property int fontMicro: 10
    readonly property int fontSmall: 12
    readonly property int fontBody: 13
    readonly property int fontBodyLarge: 14
    readonly property int fontSection: 15
    readonly property int fontPanelTitle: 16
    readonly property int fontTitle: 18
    readonly property int fontDisplay: 22
    // 等宽字体用于时间戳和数值对齐
    readonly property string monoFontFamily: "Consolas"
    // 常用控件尺寸和小圆角
    readonly property int controlHeight: 32
    readonly property int compactControlHeight: 28
    // 表单控件统一高度
    readonly property int formControlHeight: 36
    readonly property int arrowButtonWidth: 26
    readonly property int arrowButtonHeight: 26
    readonly property real arrowLineWidth: 1.0
    readonly property real arrowBoldLineWidth: 1.5
    readonly property int smallRadius: 4
    readonly property int controlRadius: 5
    // 全局动效开关，关闭后所有受控动画立即完成或停止循环
    property bool animationsEnabled: true
    // 语义化动效令牌
    readonly property int windowEnterDuration: 450
    readonly property int windowExitDuration: 300
    readonly property int splashEnterDuration: 160
    readonly property int popupEnterDuration: 160
    readonly property int popupExitDuration: 140
    readonly property int controlRevealDuration: 160
    readonly property int controlSlideDuration: 70
    readonly property int scrollBarRevealDuration: 300
    readonly property int notificationEnterDuration: 200
    readonly property int notificationExitDuration: 420
    readonly property int attentionGrowDuration: 120
    readonly property int attentionSettleDuration: 160
    readonly property int activityIndicatorDuration: 720
    readonly property int enterEasing: Easing.OutCubic
    readonly property int exitEasing: Easing.InOutCubic
    readonly property int windowExitEasing: Easing.InCubic

    // 动画关闭时保留相同状态流转，但让有限动画在零时长内完成
    function effectiveAnimationDuration(duration) {
        return animationsEnabled ? duration : 0
    }
    // 波形组件默认每条曲线保留的绘制点数，零表示不抽样
    readonly property int waveSamplePointLimit: 1000
    // 波形粗点三角形的外接尺寸
    readonly property real waveBoldPointSize: 3.0
    // 单批提交点数
    readonly property int wavePointBatchSize: 4000

    // 主题顺序 浅色 深色 暖色 科技 粉色 撞色 霓虹 清新
    property int currentIndex: 0
    // 配置文件使用的稳定主题标识
    readonly property var identifiers: ["light", "dark", "warm", "technology", "pink", "dopamine", "cyberNeon", "mint"]
    readonly property var names: ["浅色", "深色", "暖色", "科技", "粉色", "撞色", "霓虹", "清新"]
    // 主题选择卡片按照主题顺序显示对应的代表色
    readonly property var previewColors: ["#38444f", "#11171d", "#8a6848", "#051119", "#c85b88", "#ff5d5d", "#ff2bd6", "#176b5c"]

    // 将主题稳定标识转换为主题下标
    function indexForName(name) {
        const index = identifiers.indexOf(name)
        return index < 0 ? 0 : index
    }

    // 按主题稳定标识应用配色
    function applyName(name) {
        currentIndex = indexForName(name)
    }

    // 根据当前主题索引返回对应颜色
    function pick(values) {
        return values[Math.max(0, Math.min(currentIndex, values.length - 1))]
    }

    // 页面背景由工作区内容表面和侧栏三个层级组成
    readonly property color workbench: pick(["#f3f3f3", "#20252b", "#f7f3ed", "#08131c", "#fff2f7", "#f7f7fb", "#080713", "#f2f8f6"])
    readonly property color surface: pick(["#ffffff", "#252b33", "#fffdfa", "#0d1a24", "#fffafd", "#ffffff", "#151126", "#ffffff"])
    readonly property color sidebar: pick(["#f7f7f7", "#1c2229", "#f4eee5", "#0a1520", "#fcebf3", "#fff2d9", "#100b20", "#e4f3ee"])
    // 主导航使用独立颜色保证深浅主题下图标和选中标记清晰可见
    readonly property color activity: pick(["#38444f", "#11171d", "#8a6848", "#0a1520", "#c85b88", "#ff5d5d", "#0b0618", "#176b5c"])
    readonly property color activityHover: pick(["#485765", "#2b333d", "#76583d", "#12242f", "#ad4773", "#ed474d", "#3a1557", "#12594d"])
    readonly property color activityPressed: pick(["#202b35", "#354454", "#65472f", "#162c39", "#96365f", "#d9363e", "#64156e", "#0d4b41"])
    readonly property color activityMarker: pick(["#d6e5f0", "#77bce8", "#f2dfcc", "#54ddf5", "#ffe3ee", "#fff0a8", "#00f5ff", "#c9fff0"])
    readonly property color activityIcon: pick(["#c3ced8", "#a9b5c1", "#eadccc", "#86aeb9", "#ffe5f0", "#ffd8a8", "#d85cff", "#b9e2d6"])
    // 边框正文和次要文字用于建立统一的信息层级
    readonly property color border: pick(["#d4d4d4", "#3e4a57", "#d9cfc2", "#477484", "#e6bfd0", "#ded8e8", "#00cfe8", "#c6dcd5"])
    readonly property color borderSoft: pick(["#e8e8e8", "#323c47", "#e9e0d6", "#34515d", "#f1d8e3", "#eeeaf4", "#49306b", "#dcebe6"])
    readonly property color text: pick(["#242424", "#eef3f8", "#2f302f", "#e9fbff", "#3c2832", "#25222b", "#f8f4ff", "#20302c"])
    readonly property color muted: pick(["#616161", "#a9b5c1", "#6f6b65", "#92b2bb", "#7a5f6b", "#6e6877", "#b8a9cf", "#63756f"])
    // 强调色及交互状态用于主按钮选中项输入焦点和悬浮反馈
    readonly property color accent: pick(["#0078d4", "#4aa3df", "#9a6a3a", "#26cbe8", "#c85d87", "#f24f57", "#ff2bd6", "#168a76"])
    readonly property color accentText: "#ffffff"
    readonly property color accentHover: pick(["#1687d8", "#61afe2", "#aa7845", "#55ddf2", "#d8749c", "#ff7076", "#ff62e3", "#25a18b"])
    readonly property color accentPressed: pick(["#006cbe", "#358bc4", "#7f522d", "#1394ad", "#a9446c", "#d93d44", "#c70eaa", "#0e6f60"])
    readonly property color accentSoft: pick(["#e6f2fb", "#1f4056", "#f1e5d6", "#163442", "#f7dae6", "#ffe4e5", "#4d173f", "#cfe8e1"])
    readonly property color hover: pick(["#eef3f8", "#303944", "#eee5db", "#1c3a49", "#fae4ee", "#fff1c7", "#29204a", "#d8ede7"])
    readonly property color pressed: pick(["#e1e9f1", "#394552", "#e4d8ca", "#264958", "#f3d0df", "#ffd98a", "#4c286e", "#c5e4db"])
    // 分组颜色区分一级分组和消息子分组
    readonly property color section: pick(["#c9d9e5", "#344454", "#ddc1a6", "#12313c", "#e8afc7", "#ffcf5a", "#6127a8", "#b9e2d6"])
    readonly property color subgroup: pick(["#dfe8ef", "#2c3742", "#ead9c8", "#0d2530", "#f2cfde", "#ffe39a", "#123f59", "#d5e9e3"])
    readonly property color sectionText: pick(["#242424", "#ffffff", "#2f302f", "#ffffff", "#3c2832", "#3a2b16", "#ffffff", "#20302c"])
    // 语义色分别表示成功错误和警告状态
    readonly property color green: pick(["#18864b", "#53c18a", "#4d8b58", "#4ce0a5", "#41845a", "#13a56f", "#59ff7a", "#23866e"])
    readonly property color red: pick(["#c42b1c", "#f37f6d", "#b34e42", "#ff6f86", "#c94062", "#d9304f", "#ff4d6d", "#d6535b"])
    readonly property color warning: pick(["#9a6700", "#e2b85a", "#a87827", "#ffd166", "#a76d24", "#b56f00", "#ffe600", "#8c701a"])
    readonly property color warningHover: pick(["#fff2cc", "#4b4230", "#f3e5ca", "#2e2a1a", "#f4e2c9", "#fff0cc", "#4d4708", "#f3ebd2"])
    readonly property color dangerHover: pick(["#fde9e7", "#4a2d31", "#f3d8d3", "#4a2a35", "#f9dce5", "#ffe5ea", "#4c1833", "#f9e3e4"])
    readonly property color dangerPressed: pick(["#f8d4d0", "#633138", "#e9c1ba", "#5c3642", "#f2becd", "#ffcbd5", "#771e44", "#efc9cb"])
    // 悬浮提示使用不透明背景避免底层文字影响可读性
    readonly property color tooltipBackground: pick(["#25313b", "#eef3f8", "#6f5138", "#0c2632", "#a93f6e", "#33303d", "#25103f", "#235047"])
    readonly property color tooltipText: pick(["#ffffff", "#20252b", "#ffffff", "#ffffff", "#ffffff", "#ffffff", "#ffffff", "#ffffff"])
    readonly property color tooltipBorder: pick(["#465866", "#b8c5d1", "#967250", "#42cfe8", "#d978a1", "#ffcf5a", "#00f5ff", "#6bcab5"])
    // 模态弹窗遮罩颜色
    readonly property color dimColor: "#52000000"
}
