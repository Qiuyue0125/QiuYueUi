// 本文件定义最小化最大化还原和关闭使用的窗口按钮
import QtQuick
import QtQuick.Controls

// 定义最小化最大化还原和关闭使用的窗口按钮
ToolButton {
    id: control

    // 关闭按钮设置 danger 后使用危险色悬浮和按下效果
    property bool danger: false
    property string toolTip: ""
    // 按钮图标类型 由调用方按窗口状态设置
    property string iconType: "minimize"

    implicitWidth: AppTheme.windowButtonSize
    implicitHeight: AppTheme.windowButtonSize
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.NoFocus

    // 使用矢量图标绘制 避免字体符号在不同平台渲染大小不一致
    contentItem: WindowIcon {
        iconType: control.iconType
        iconColor: control.danger ? AppTheme.red : AppTheme.text
    }

    // 定义控件背景
    background: Rectangle {
        color: control.pressed
                ? (control.danger ? AppTheme.dangerPressed : AppTheme.pressed)
                : control.hovered
                  ? (control.danger ? AppTheme.dangerHover : AppTheme.hover)
                  : "transparent"
    }

    // 显示窗口操作提示
    ThemedToolTip {
        visible: control.toolTip.length > 0 && control.hovered
        text: control.toolTip
        y: control.height + 4
    }
}
