// 本文件定义内容页面的一级标题
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义内容页面的一级标题
Rectangle {
    id: root

    required property string title
    // 一级标题固定在内容顶部
    Layout.fillWidth: true
    Layout.preferredHeight: 54
    color: AppTheme.surface
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft
    // 显示页面名称
    Label {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        text: root.title
        color: AppTheme.text
        font.pixelSize: AppTheme.fontTitle
        font.bold: true
    }
}
