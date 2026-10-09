// 本文件定义带排序滚动和分页操作的公共只读表格
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义带排序滚动和分页操作的公共只读表格
Rectangle {
    id: root

    required property var columns
    required property var model
    required property Component rowDelegate
    property int rowHeight: AppTheme.controlHeight
    property string emptyText: "暂无数据"
    property bool sortable: false
    property string sortColumn: ""
    property bool sortAscending: true
    property bool showPagination: true
    property bool showRefresh: true
    property bool refreshEnabled: true
    property bool commitOnJump: false
    property int page: 0
    property int pageCount: 1
    property int totalCount: 0
    property color evenRowColor: "transparent"
    property color oddRowColor: AppTheme.hover

    signal sortRequested(string column)
    signal pageRequested(int page)
    signal jumpRequested(int page)
    signal refreshRequested()

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: AppTheme.workbench
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft

    // 表格纵向结构
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 公共可排序表头
        SortableTableHeader {
            columns: root.columns
            sortingEnabled: root.sortable
            sortColumn: root.sortColumn
            sortAscending: root.sortAscending
            onSortRequested: column => root.sortRequested(column)
        }

        // 公共表格数据列表
        ListView {
            id: tableView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.model
            // 显示垂直滚动条
            ScrollBar.vertical: ThemedScrollBar {
                policy: ScrollBar.AsNeeded
            }

            // 统一单行背景并加载页面提供的单元格内容
            delegate: Rectangle {
                id: tableRow

                required property int index
                required property var modelData

                width: ListView.view.width
                height: root.rowHeight
                color: index % 2 === 0 ? root.evenRowColor : root.oddRowColor

                // 将当前行数据同步给页面提供的内容组件
                function updateRowData() {
                    if (rowLoader.item)
                        rowLoader.item.rowData = tableRow.modelData
                }

                // 加载当前页面定义的单元格布局
                Loader {
                    id: rowLoader

                    anchors.fill: parent
                    sourceComponent: root.rowDelegate
                    onLoaded: tableRow.updateRowData()
                }

                onModelDataChanged: updateRowData()
            }

            // 空表格提示
            Label {
                anchors.centerIn: parent
                visible: tableView.count === 0
                text: root.emptyText
                color: AppTheme.muted
                font.pixelSize: AppTheme.fontBody
            }
        }

        // 公共分页和刷新操作栏
        PaginationBar {
            visible: root.showPagination
            Layout.preferredHeight: visible ? 38 : 0
            page: root.page
            pageCount: root.pageCount
            totalCount: root.totalCount
            commitOnJump: root.commitOnJump
            showRefresh: root.showRefresh
            refreshEnabled: root.refreshEnabled
            onPageRequested: page => root.pageRequested(page)
            onJumpRequested: page => root.jumpRequested(page)
            onRefreshRequested: root.refreshRequested()
        }
    }
}
