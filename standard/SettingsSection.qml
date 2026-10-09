// 本文件定义内容分节标题
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义内容分节标题
Rectangle {
    id: root

    required property string title
    // 分节标题横向占满表单宽度区分相邻配置组
    Layout.fillWidth: true
    Layout.preferredHeight: AppTheme.controlHeight
    color: AppTheme.subgroup
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft
    // 显示分节名称
    Label {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        text: root.title
        color: AppTheme.text
        font.pixelSize: AppTheme.fontBody
        font.bold: true
    }
}
