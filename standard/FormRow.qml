// 本文件定义标签和输入控件组成的统一表单行
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义标签和输入控件组成的统一表单行
RowLayout {
    id: root

    required property string label
    // 所有表单行使用相同的左右留白和控件间距
    Layout.fillWidth: true
    Layout.leftMargin: 20
    Layout.rightMargin: 20
    Layout.topMargin: 6
    Layout.bottomMargin: 6
    spacing: AppTheme.spacingMd
    // 固定标签宽度使各行输入控件从同一位置开始
    Label {
        Layout.preferredWidth: 100
        text: root.label
        color: AppTheme.muted
        font.pixelSize: AppTheme.fontBody
    }
}
