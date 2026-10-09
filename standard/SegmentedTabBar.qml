// 本文件定义等宽填充样式的分段切换标签栏
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义等宽填充样式的分段切换标签栏
Rectangle {
    id: root

    // 标签文字列表由使用方按页面传入
    property var labels: []
    property int currentIndex: 0
    signal indexRequested(int index)

    implicitHeight: 38
    color: AppTheme.surface
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft

    // 标签均分可用宽度父页面负责保存最终选中下标
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 按标签文字生成重复内容
        Repeater {
            model: root.labels
            // 定义列表项
            delegate: TabButton {
                id: tabButton

                required property int index
                required property string modelData
                readonly property bool selected: tabButton.index === root.currentIndex

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 0
                Layout.preferredWidth: 1
                Layout.horizontalStretchFactor: 1
                text: tabButton.modelData
                hoverEnabled: true
                focusPolicy: Qt.NoFocus
                // 在标签悬浮时显示手形指针
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                onClicked: root.indexRequested(tabButton.index)
                // 定义控件内容
                contentItem: Label {
                    text: tabButton.text
                    color: tabButton.selected ? AppTheme.accentText : AppTheme.text
                    font.pixelSize: AppTheme.fontBody
                    font.bold: tabButton.selected
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                // 定义控件背景
                background: Rectangle {
                    color: tabButton.selected ? AppTheme.accent
                           : tabButton.pressed ? AppTheme.pressed
                                               : tabButton.hovered ? AppTheme.accentSoft : AppTheme.surface
                    border.width: AppTheme.borderWidth
                    border.color: tabButton.selected ? AppTheme.accent : AppTheme.borderSoft
                }
            }
        }
    }
}
