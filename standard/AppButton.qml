// 本文件定义统一的文字命令按钮及其语义样式
import QtQuick
import QtQuick.Controls

// 定义统一的文字命令按钮及其语义样式
Button {
    id: control

    property bool primary: false
    property bool danger: false
    property bool selected: false
    property bool compact: false
    property string toolTip: ""

    implicitWidth: Math.max(compact ? 62 : 72,
                            contentItem.implicitWidth + (compact ? 14 : 24))
    implicitHeight: compact ? 30 : 32
    leftPadding: compact ? 7 : 12
    rightPadding: compact ? 7 : 12
    topPadding: 0
    bottomPadding: 0
    hoverEnabled: true
    focusPolicy: Qt.ClickFocus
    // 禁用状态降低整体亮度区分不可执行操作
    opacity: enabled ? 1.0 : 0.55

    // 根据可用状态更新鼠标指针
    HoverHandler {
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    // 显示按钮文字
    contentItem: Label {
        text: control.text
        color: control.primary ? AppTheme.accentText
                               : control.danger ? AppTheme.red
                                                : AppTheme.text
        font.pixelSize: AppTheme.fontBody
        font.bold: control.primary || control.selected
        font.letterSpacing: 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // 定义控件背景
    background: Rectangle {
        radius: AppTheme.smallRadius
        border.width: AppTheme.borderWidth
        border.color: control.primary
                ? AppTheme.accent
                : control.danger
                  ? AppTheme.red
                  : control.selected ? AppTheme.accent : AppTheme.border
        color: control.primary
               ? (control.pressed ? AppTheme.accentPressed
                                  : control.hovered ? AppTheme.accentHover : AppTheme.accent)
               : control.danger
                 ? (control.pressed ? AppTheme.dangerPressed
                                    : control.hovered ? AppTheme.dangerHover : AppTheme.surface)
                 : (control.pressed ? AppTheme.pressed
                                    : control.hovered ? AppTheme.hover
                                                      : control.selected ? AppTheme.accentSoft : AppTheme.surface)
    }

    // 显示按钮操作提示
    ThemedToolTip {
        visible: control.toolTip.length > 0 && control.hovered
        text: control.toolTip
    }
}
