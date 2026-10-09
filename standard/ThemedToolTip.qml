// 本文件定义颜色跟随当前主题的统一悬浮提示框
import QtQuick
import QtQuick.Controls

// 定义颜色跟随当前主题的统一悬浮提示框
ToolTip {
    id: control
    // 短延迟用于快速反馈超时后自动隐藏
    delay: AppTheme.toolTipDelay
    timeout: AppTheme.toolTipTimeout
    padding: AppTheme.spacingMd

    // 提示文字使用主题定义的前景色
    contentItem: Label {
        text: control.text
        width: Math.min(AppTheme.toolTipMaximumWidth, implicitWidth)
        color: AppTheme.tooltipText
        font.pixelSize: AppTheme.fontSmall
        font.letterSpacing: 0
        wrapMode: Text.WrapAnywhere
    }

    // 不透明背景和主题边框保证提示内容不受底层界面干扰
    background: Rectangle {
        color: AppTheme.tooltipBackground
        border.width: AppTheme.borderWidth
        border.color: AppTheme.tooltipBorder
        radius: AppTheme.smallRadius
    }
}
