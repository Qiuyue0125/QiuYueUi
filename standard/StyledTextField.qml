// 本文件定义跟随当前主题且文字居中的统一输入框
import QtQuick
import QtQuick.Controls

// 定义跟随当前主题且文字居中的统一输入框
TextField {
    id: control

    // 控制回车后是否移走焦点 控制台连续输入时可关闭
    property bool dismissFocusOnAccepted: true

    // 将焦点明确交回窗口内容区避免父控件继续保持焦点态
    function dismissFocus() {
        control.focus = false
        const targetWindow = control.Window.window
        if (targetWindow)
            targetWindow.contentItem.forceActiveFocus(Qt.OtherFocusReason)
    }

    // 固定高度和内边距保证单行文字在各页面中保持居中
    implicitWidth: 150
    implicitHeight: 32
    leftPadding: 9
    rightPadding: 9
    topPadding: 5
    bottomPadding: 3
    color: AppTheme.text
    placeholderTextColor: AppTheme.muted
    selectedTextColor: AppTheme.accentText
    selectionColor: AppTheme.accent
    horizontalAlignment: TextInput.AlignHCenter
    verticalAlignment: TextInput.AlignVCenter
    font.pixelSize: AppTheme.fontBody
    font.letterSpacing: 0

    // 使用独立信号连接防止调用方的 onAccepted 覆盖清焦逻辑
    Connections {
        target: control
        function onAccepted() {
            if (control.dismissFocusOnAccepted)
                control.dismissFocus()
        }
    }

    // 焦点态使用强调色悬浮态只增强普通边框
    background: Rectangle {
        color: AppTheme.surface
        border.color: control.activeFocus
                ? AppTheme.accent
                : control.hovered ? AppTheme.border : AppTheme.borderSoft
        border.width: AppTheme.borderWidth
        radius: AppTheme.smallRadius
    }

    // 悬浮在被截断的输入文字上时显示完整内容
    HoverHandler {
        id: textHover
    }

    // 计算输入内容实际占用宽度
    TextMetrics {
        id: textMetrics
        text: control.text
        font: control.font
    }
    // 显示输入框内容完整文字提示
    ThemedToolTip {
        visible: textHover.hovered
                 && control.text.length > 0
                 && textMetrics.width > Math.max(0,
                                                 control.width
                                                 - control.leftPadding
                                                 - control.rightPadding)
        text: control.text
    }
}
