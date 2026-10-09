// 本文件定义跟随当前主题的统一复选框
import QtQuick
import QtQuick.Controls

// 定义跟随当前主题的统一复选框
CheckBox {
    id: control

    readonly property bool textTruncated: contentLabel.truncated

    implicitHeight: 30
    spacing: 7
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.ClickFocus

    // 鼠标悬浮在复选框上时显示手形指针
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    // 选中标记完全由 QML 绘制避免平台默认样式覆盖主题
    indicator: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        x: 0
        y: (control.height - height) / 2
        radius: AppTheme.compactRadius
        color: control.checked ? AppTheme.accent : control.hovered ? AppTheme.hover : AppTheme.surface
        border.width: AppTheme.borderWidth
        border.color: control.checked || control.hovered ? AppTheme.accent : AppTheme.border

        // 绘制选中标记
        Label {
            anchors.centerIn: parent
            text: "✓"
            visible: control.checked
            color: AppTheme.accentText
            font.pixelSize: AppTheme.fontSmall
            font.bold: true
        }
    }

    // 标签从选择框右侧开始并在空间不足时省略结尾
    contentItem: Label {
        id: contentLabel
        leftPadding: control.indicator.width + control.spacing
        text: control.text
        color: AppTheme.text
        font.pixelSize: AppTheme.fontSmall
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
