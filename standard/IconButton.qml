// 本文件定义统一的图标命令按钮及其语义样式
import QtQuick
import QtQuick.Controls

// 定义统一的图标命令按钮及其语义样式
ToolButton {
    id: control

    property bool danger: false
    property bool accent: false
    property string toolTip: ""
    // 矢量图标类型 为空时回退为文本标签渲染
    property string iconType: ""

    implicitWidth: AppTheme.iconButtonSize
    implicitHeight: AppTheme.iconButtonSize
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.ClickFocus
    // 禁用状态降低整体亮度区分不可执行操作
    opacity: enabled ? 1.0 : 0.80

    // 根据可用状态更新鼠标指针
    HoverHandler {
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    // 有图标类型时绘制矢量图标 否则渲染文本标签
    contentItem: Item {
        anchors.fill: parent
        // 矢量图标分支 避免字体符号在不同平台渲染不一致
        VectorIcon {
            visible: control.iconType.length > 0
            anchors.centerIn: parent
            iconType: control.iconType
            iconColor: control.danger
                       ? AppTheme.red
                       : control.accent ? AppTheme.accent : AppTheme.muted
        }
        // 文本标签分支 用于顶全量等文字按钮
        Label {
            visible: control.iconType.length === 0
            anchors.fill: parent
            text: control.text
            color: control.danger
                   ? AppTheme.red
                   : control.accent ? AppTheme.accent : AppTheme.muted
            font.pixelSize: 16
            font.letterSpacing: 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // 定义控件背景
    background: Rectangle {
        anchors.margins: control.danger ? 3 : 1
        radius: AppTheme.smallRadius
        border.width: 0
        color: control.pressed
                ? (control.danger ? AppTheme.dangerPressed : AppTheme.pressed)
                : control.hovered
                  ? (control.danger
                     ? AppTheme.dangerHover
                     : control.accent ? AppTheme.accentSoft : AppTheme.hover)
                  : "transparent"
    }

    // 显示图标按钮操作提示
    ThemedToolTip {
        visible: control.toolTip.length > 0 && control.hovered
        text: control.toolTip
    }
}
