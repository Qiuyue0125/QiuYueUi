// 本文件定义编辑页面共用的单选列表面板
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义编辑页面共用的单选列表面板
Rectangle {
    id: root

    required property string title
    required property var model
    property int selectedIndex: -1
    property string primaryTextRole: "name"
    property var secondaryTextProvider: null
    property string emptyText: "暂无内容"
    property string emptyActionText: "新增"
    property string addToolTip: "新增"
    property string removeToolTip: "删除"
    property bool removeEnabled: false
    property string searchPlaceholder: "搜索"
    property string searchText: ""
    property var visibleEntries: []

    signal addRequested()
    signal removeRequested()
    signal selectionRequested(int index)

    Layout.preferredWidth: 300
    Layout.fillHeight: true
    color: AppTheme.sidebar
    border.width: AppTheme.borderWidth
    border.color: AppTheme.border
    radius: AppTheme.smallRadius
    // 返回列表项主要文字
    function primaryText(data) {
        if (!data || data[root.primaryTextRole] === undefined)
            return ""
        return String(data[root.primaryTextRole])
    }

    // 返回列表项辅助文字
    function secondaryText(data) {
        if (!root.secondaryTextProvider)
            return ""
        const value = root.secondaryTextProvider(data)
        return value === undefined || value === null ? "" : String(value)
    }

    // 按输入内容过滤列表并保留原始顺序和下标
    function rebuildVisibleEntries() {
        const keyword = searchText.trim().toLocaleLowerCase()
        let entries = []
        for (let index = 0; index < model.length; ++index) {
            const data = model[index]
            const searchableText = (primaryText(data) + " "
                                    + secondaryText(data)).toLocaleLowerCase()
            if (keyword.length === 0 || searchableText.indexOf(keyword) >= 0)
                entries.push({ sourceIndex: index, data: data })
        }
        visibleEntries = entries
    }

    onModelChanged: rebuildVisibleEntries()
    onSearchTextChanged: rebuildVisibleEntries()
    Component.onCompleted: rebuildVisibleEntries()

    // 列表面板内容布局
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 列表工具栏
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            Layout.leftMargin: 12
            Layout.rightMargin: 8

            // 列表标题
            Label {
                text: root.title
                color: AppTheme.text
                font.pixelSize: AppTheme.fontBody
                font.bold: true
            }

            // 将新增按钮推到标题栏右侧
            Item {
                Layout.fillWidth: true
            }

            // 新增列表项按钮
            IconButton {
                iconType: "plus"
                accent: true
                toolTip: root.addToolTip
                onClicked: root.addRequested()
            }

            // 删除列表项按钮
            IconButton {
                iconType: "close"
                danger: true
                enabled: root.removeEnabled
                toolTip: root.removeToolTip
                onClicked: root.removeRequested()
            }
        }

        // 分隔标题栏和列表内容
        AppDivider {
            Layout.fillWidth: true
        }

        // 列表模糊搜索框
        StyledTextField {
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8
            Layout.bottomMargin: 2
            placeholderText: root.searchPlaceholder
            text: root.searchText
            onTextEdited: root.searchText = text
        }

        // 编辑项目列表
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 6
            model: root.visibleEntries
            clip: true
            spacing: 3
            // 显示垂直滚动条
            ScrollBar.vertical: ThemedScrollBar {
                policy: ScrollBar.AsNeeded
            }

            // 单个编辑列表项
            delegate: Rectangle {
                id: listItem

                required property int index
                required property var modelData
                readonly property int sourceIndex: modelData.sourceIndex
                readonly property var itemData: modelData.data

                width: ListView.view.width
                height: 42
                radius: AppTheme.compactRadius
                color: sourceIndex === root.selectedIndex
                       ? AppTheme.accentSoft
                       : itemHover.hovered ? AppTheme.hover : "transparent"
                border.width: AppTheme.borderWidth
                border.color: sourceIndex === root.selectedIndex
                              ? AppTheme.accent : "transparent"

                // 列表项文字布局
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: AppTheme.spacingMd
                    // 列表项主要文字
                    ElidedLabel {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        text: root.primaryText(listItem.itemData)
                        color: AppTheme.text
                        font.pixelSize: AppTheme.fontBody
                        font.bold: listItem.sourceIndex === root.selectedIndex
                        elide: Text.ElideRight
                        toolTipDelay: 350
                    }

                    // 列表项辅助文字
                    Label {
                        visible: text.length > 0
                        text: root.secondaryText(listItem.itemData)
                        color: AppTheme.muted
                        font.pixelSize: AppTheme.fontBody
                        font.bold: true
                    }
                }

                // 处理列表项选择
                TapHandler {
                    onTapped: root.selectionRequested(listItem.sourceIndex)
                }

                // 跟踪列表项悬浮状态
                HoverHandler {
                    id: itemHover
                }
            }

            // 空列表提示和新增入口
            Column {
                anchors.centerIn: parent
                visible: listView.count === 0
                spacing: AppTheme.spacingMd
                // 空列表提示文字
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.model.length === 0 ? root.emptyText : "没有匹配结果"
                    color: AppTheme.muted
                    font.pixelSize: AppTheme.fontBody
                }

                // 空列表新增按钮
                AppButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.emptyActionText
                    visible: root.model.length === 0
                    onClicked: root.addRequested()
                }
            }
        }
    }
}
