// 本文件定义统一绘制左右方向箭头的紧凑按钮
import QtQuick
import QtQuick.Controls

// 定义统一绘制左右方向箭头的紧凑按钮
Button {
    id: control

    property bool pointsLeft: false
    property bool doubleArrow: false
    property bool bold: false
    property bool revealOnHover: false
    property string toolTip: ""

    implicitWidth: AppTheme.arrowButtonWidth
    implicitHeight: AppTheme.arrowButtonHeight
    padding: 0
    hoverEnabled: true
    opacity: revealOnHover ? (hovered ? 1 : 0) : 1
    // 平滑切换悬浮显隐状态
    Behavior on opacity {
        // 动画更新按钮透明度
        NumberAnimation {
            duration: AppTheme.effectiveAnimationDuration(
                          AppTheme.controlRevealDuration)
        }
    }
    // 绘制按钮交互背景
    background: Rectangle {
        radius: AppTheme.smallRadius
        color: control.hovered || control.pressed
               ? (control.pressed ? AppTheme.pressed : AppTheme.hover)
               : "transparent"
        border.width: 0
    }

    // 根据可用状态更新鼠标指针
    HoverHandler {
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    // 绘制箭头图形
    Canvas {
        id: controlCanvas
        anchors.centerIn: parent
        width: control.doubleArrow ? 20 : 10
        height: 12

        // 绘制一个指定水平偏移的实心方向箭头
        function drawArrow(context, offsetX) {
            const arrowWidth = 8
            const baseX = 2
            context.beginPath()
            if (control.pointsLeft) {
                context.moveTo(offsetX + arrowWidth, 0.5)
                context.lineTo(offsetX + baseX, height / 2)
                context.lineTo(offsetX + arrowWidth, height - 0.5)
            } else {
                context.moveTo(offsetX + baseX, 0.5)
                context.lineTo(offsetX + arrowWidth, height / 2)
                context.lineTo(offsetX + baseX, height - 0.5)
            }
            context.strokeStyle = control.enabled ? AppTheme.accent : AppTheme.muted
            context.lineWidth = control.bold
                                  ? AppTheme.arrowBoldLineWidth : AppTheme.arrowLineWidth
            context.lineJoin = "miter"
            context.stroke()
        }

        onPaint: {
            const context = getContext("2d")
            context.reset()
            controlCanvas.drawArrow(context, 0)
            if (control.doubleArrow)
                controlCanvas.drawArrow(context, 10)
        }
        // 主题变化后重绘箭头
        Connections {
            target: AppTheme
            // 请求使用新主题颜色绘制箭头
            function onCurrentIndexChanged() { controlCanvas.requestPaint() }
        }
        // 线宽变化后重绘箭头
        Connections {
            target: control
            // 请求使用新线宽绘制箭头
            function onBoldChanged() { controlCanvas.requestPaint() }
        }
    }

    // 显示箭头按钮操作提示
    ThemedToolTip {
        visible: control.toolTip.length > 0 && control.hovered
        text: control.toolTip
    }
}
