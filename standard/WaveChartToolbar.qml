// 本文件定义波形图表共用的完整工具栏和紧凑按钮组
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// 定义波形图表共用的完整工具栏和紧凑按钮组
Item {
    id: root

    // 是否使用紧凑按钮布局
    property bool compact: false
    // 是否显示工具栏操作按钮
    property bool showButtons: true
    // 窗口相关操作是否可用
    property bool windowActionsEnabled: true
    property bool fullScreenEnabled: true
    property bool fullScreenOpen: false
    property bool showCompactFullscreenButton: true
    // 当前交互状态由使用方绑定
    property bool zoomed: false
    property bool sampleModeFull: false
    property bool pointMode: false
    property bool boldPointMode: false

    signal exportRequested()
    signal fullScreenRequested()
    signal resetRequested()
    signal sampleModeToggleRequested()
    signal pointModeToggleRequested()
    signal boldPointModeToggleRequested()

    implicitWidth: compact ? compactRow.implicitWidth : fullGrid.implicitWidth
    implicitHeight: compact ? compactRow.implicitHeight : fullGrid.implicitHeight

    // 工具按钮以两行紧凑排列，减少对图例和绘图区的占用
    GridLayout {
        id: fullGrid
        visible: !root.compact && root.showButtons
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10
        columns: 3
        rowSpacing: 4
        columnSpacing: 4

        // 执行“导出”操作
        AppButton {
            text: "导出"
            Layout.column: 0
            Layout.row: 0
            visible: root.windowActionsEnabled
            implicitWidth: 52
            implicitHeight: 26
            onClicked: root.exportRequested()
        }
        // 执行“全屏”操作
        AppButton {
            text: "全屏"
            Layout.column: 1
            Layout.row: 0
            visible: root.windowActionsEnabled
            enabled: root.fullScreenEnabled && !root.fullScreenOpen
            implicitWidth: 52
            implicitHeight: 26
            onClicked: root.fullScreenRequested()
        }
        // 执行“恢复”操作
        AppButton {
            text: "恢复"
            Layout.column: 2
            Layout.row: 0
            implicitWidth: 52
            implicitHeight: 26
            enabled: root.zoomed
            onClicked: root.resetRequested()
        }
        // 执行“全量”操作
        AppButton {
            text: "全量"
            selected: root.sampleModeFull
            Layout.column: 0
            Layout.row: 1
            implicitWidth: 52
            implicitHeight: 26
            onClicked: root.sampleModeToggleRequested()
        }
        // 执行“顶点”操作
        AppButton {
            text: "顶点"
            selected: root.pointMode
            Layout.column: 1
            Layout.row: 1
            implicitWidth: 52
            implicitHeight: 26
            onClicked: root.pointModeToggleRequested()
        }
        // 执行“粗点”操作
        AppButton {
            text: "粗点"
            selected: root.boldPointMode
            enabled: root.pointMode
            Layout.column: 2
            Layout.row: 1
            implicitWidth: 52
            implicitHeight: 26
            onClicked: root.boldPointModeToggleRequested()
        }
    }

    // 小尺寸波形只显示紧凑按钮，避免遮挡绘图区
    Row {
        id: compactRow
        visible: root.compact
                 && (root.showButtons || root.showCompactFullscreenButton)
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 4
        anchors.rightMargin: 4
        spacing: 2
        height: 24

        // 提供全屏按钮
        ArrowButton {
            visible: root.showCompactFullscreenButton && root.windowActionsEnabled
            enabled: root.fullScreenEnabled && !root.fullScreenOpen
            pointsLeft: false
            toolTip: "全屏"
            onClicked: root.fullScreenRequested()
        }
        // 提供顶点显示按钮
        IconButton {
            visible: root.showButtons
            text: "顶"
            accent: root.pointMode
            toolTip: "顶点"
            onClicked: root.pointModeToggleRequested()
        }
        // 导出当前波形图片
        IconButton {
            visible: root.showButtons && root.windowActionsEnabled
            text: "↓"
            toolTip: "导出"
            onClicked: root.exportRequested()
        }
        // 切换全量绘制按钮
        IconButton {
            visible: root.showButtons
            text: "全量"
            accent: root.sampleModeFull
            toolTip: root.sampleModeFull ? "恢复默认抽样" : "绘制全部点"
            onClicked: root.sampleModeToggleRequested()
        }
        // 提供粗点显示按钮
        IconButton {
            visible: root.showButtons
            text: "粗"
            accent: root.boldPointMode
            enabled: root.pointMode
            toolTip: "粗点"
            onClicked: root.boldPointModeToggleRequested()
        }
        // 提供恢复按钮
        IconButton {
            visible: root.showButtons
            text: "↺"
            enabled: root.zoomed
            toolTip: "恢复"
            onClicked: root.resetRequested()
        }
    }
}
