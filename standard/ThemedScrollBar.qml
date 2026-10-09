// 本文件定义跟随主题配色、悬浮渐显的滚动条滑块
import QtQuick
import QtQuick.Controls

ScrollBar {
    id: control

    // 滑块颜色，默认使用主题强调色
    property color thumbColor: AppTheme.accent
    // 滑块粗细
    property real thickness: 6
    // 停止交互后延迟隐藏的时长（防抖，毫秒）
    property int hideDelay: 800

    hoverEnabled: true
    // 不保留平台默认轨道，避免混入系统配色。
    background: Item { }

    // 滚动时临时显示，停止滚动后由计时器隐藏
    property bool showByScroll: false

    onPositionChanged: {
        showByScroll = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: control.hideDelay
        onTriggered: control.showByScroll = false
    }

    contentItem: Rectangle {
        implicitWidth: control.thickness
        implicitHeight: control.thickness
        radius: control.thickness / 2
        color: control.thumbColor
        // 悬浮、拖动或滚动时保持可见
        opacity: (control.policy === ScrollBar.AlwaysOn
                  || control.hovered || control.active || control.showByScroll) ? 1 : 0
        // 平滑切换显隐状态
        Behavior on opacity {
            NumberAnimation {
                duration: AppTheme.effectiveAnimationDuration(
                              AppTheme.scrollBarRevealDuration)
                easing.type: AppTheme.enterEasing
            }
        }
    }
}
