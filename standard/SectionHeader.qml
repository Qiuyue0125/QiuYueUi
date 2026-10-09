// 本文件定义支持展开折叠和全选操作的分组标题
import QtQuick
import QtQuick.Controls

// 定义支持展开折叠和全选操作的分组标题
Rectangle {
    id: root

    required property string title
    property bool compact: false
    property bool collapsible: true
    property bool expanded: true
    property bool showSelectAll: true
    property bool showExpansionToggle: false
    property bool allExpanded: true
    property bool allSelected: false
    property bool expansionToggleEnabled: true
    signal expansionRequested()
    signal selectAllRequested()
    signal expansionToggleRequested()

    implicitHeight: compact ? 32 : 40
    color: compact ? AppTheme.subgroup : AppTheme.section
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft

    // 展开箭头与标题共同组成可点击区域
    Label {
        visible: root.collapsible
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: root.expanded ? "▾" : "▸"
        color: root.compact ? AppTheme.muted : AppTheme.sectionText
        font.pixelSize: AppTheme.fontSmall
    }

    // 显示自动省略的长文字
    ElidedLabel {
        anchors.left: parent.left
        anchors.leftMargin: root.collapsible ? 29 : 12
        anchors.right: expansionButton.left
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        text: root.title
        color: root.compact ? AppTheme.text : AppTheme.sectionText
        font.pixelSize: root.compact ? 12 : 13
        font.bold: true
        elide: Text.ElideRight

    }

    // 在全选按钮左侧统一展开或折叠下面的全部子分组
    AppButton {
        id: expansionButton
        visible: root.showExpansionToggle
        enabled: root.expansionToggleEnabled
        anchors.right: selectButton.left
        anchors.rightMargin: visible ? 4 : 0
        anchors.verticalCenter: parent.verticalCenter
        width: visible ? 48 : 0
        height: root.compact ? 23 : 26
        leftPadding: 6
        rightPadding: 6
        // 全部展开时按钮负责折叠全部子分组
        text: root.allExpanded ? "折叠" : "展开"
        z: 2
        onClicked: root.expansionToggleRequested()
    }

    // 全选按钮独立处理点击不触发展开或折叠
    AppButton {
        id: selectButton
        visible: root.showSelectAll
        anchors.right: parent.right
        anchors.rightMargin: root.compact ? 10 : 8
        anchors.verticalCenter: parent.verticalCenter
        width: 48
        height: root.compact ? 23 : 26
        leftPadding: 6
        rightPadding: 6
        // 全部选中时按钮负责取消全部选择
        text: root.allSelected ? "全选" : "全选"
        z: 2
        onClicked: root.selectAllRequested()
    }

    // 点击按钮以外的标题区域时请求切换展开状态
    MouseArea {
        anchors.left: parent.left
        anchors.right: expansionButton.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: {
            if (root.collapsible)
                root.expansionRequested()
        }
    }
}
