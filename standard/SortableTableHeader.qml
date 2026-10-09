// 本文件定义表格共用的可排序列标题栏
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义表格共用的可排序列标题栏
Rectangle {
    id: root

    // 每列提供 title、column，并可选提供 width 或 fill
    required property var columns
    // 空 sortColumn 表示当前没有排序列
    property bool sortingEnabled: false
    property string sortColumn: ""
    property bool sortAscending: true
    property int contentRightMargin: 12
    property color outlineColor: AppTheme.borderSoft

    signal sortRequested(string column)

    Layout.fillWidth: true
    Layout.preferredHeight: 34
    color: AppTheme.sidebar
    border.width: AppTheme.borderWidth
    border.color: root.outlineColor

    // 横向排列
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: root.contentRightMargin

        // 按模型生成重复项
        Repeater {
            model: root.columns
            // 定义列表项
            delegate: Label {
                id: columnLabel

                required property var modelData

                readonly property string columnKey:
                    columnLabel.modelData.column || ""
                readonly property bool sortable:
                    root.sortingEnabled && columnKey.length > 0
                    && columnLabel.modelData.sortable === true
                readonly property bool active: columnLabel.sortable
                                               && root.sortColumn === columnLabel.columnKey

                Layout.preferredWidth: columnLabel.modelData.width || -1
                Layout.fillWidth: columnLabel.modelData.fill === true
                text: columnLabel.modelData.title + (columnLabel.active
                      ? (root.sortAscending ? "  ↑" : "  ↓") : "")
                color: columnLabel.active ? AppTheme.accent : AppTheme.muted
                font.pixelSize: AppTheme.fontSmall
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                // 处理可排序表头点击
                MouseArea {
                    anchors.fill: parent
                    enabled: columnLabel.sortable
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.sortRequested(columnLabel.columnKey)
                }
            }
        }
    }
}
