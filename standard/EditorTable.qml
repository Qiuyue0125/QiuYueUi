// 本文件定义工程配置编辑器共用的表头加列表骨架
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义工程配置编辑器共用的表头加列表骨架
ColumnLayout {
    id: root
    spacing: 0

    // 列定义数组，每项包含 title 与 width，width 为 0 表示占满剩余宽度
    required property var columns
    // 表格行数据模型
    required property var model
    // 单行内容委托，由调用方提供并通过 columns 对齐列宽
    required property Component rowDelegate
    // 是否渲染为带边框的列表表格，否则渲染为无边框内联列表
    property bool bordered: true
    // 无数据时的提示文字
    property string emptyText: ""
    // 无数据提示是否可见
    property bool emptyVisible: true
    // 是否在表头显示新增按钮
    property bool showAddButton: false
    // 新增按钮提示文字
    property string addToolTip: ""
    // 表头底部是否绘制等色补丁以隐藏圆角
    property bool headerPatch: false
    // 请求新增一行
    signal addRequested()

    // 无边框内联列表，用于嵌入滚动表单
    ColumnLayout {
        visible: !root.bordered
        Layout.fillWidth: true
        spacing: AppTheme.spacingSm

        // 表头和新增入口
        RowLayout {
            Layout.fillWidth: true
            spacing: AppTheme.spacingSm

            Repeater {
                model: root.columns
                delegate: Label {
                    required property var modelData
                    Layout.preferredWidth: modelData.width > 0 ? modelData.width : 0
                    Layout.fillWidth: modelData.width <= 0
                    text: modelData.title
                    color: AppTheme.muted
                    font.pixelSize: AppTheme.fontSmall
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // 表头新增按钮
            IconButton {
                visible: root.showAddButton
                Layout.preferredWidth: 32
                iconType: "plus"
                accent: true
                toolTip: root.addToolTip
                onClicked: root.addRequested()
            }
        }

        // 行内容 无边框分支仅在内联模式实例化 避免隐藏分支触发 ListView.view 空引用
        Repeater {
            model: root.bordered ? 0 : root.model
            delegate: root.rowDelegate
        }
    }

    // 带边框的列表表格
    Rectangle {
        visible: root.bordered
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: AppTheme.surface
        border.width: AppTheme.borderWidth
        border.color: AppTheme.border
        radius: AppTheme.smallRadius
        antialiasing: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 1
            spacing: 0

            // 表头背景
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                color: AppTheme.sidebar
                radius: AppTheme.compactRadius

                // 表头底部补丁保持分隔边缘平直
                Rectangle {
                    visible: root.headerPatch
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 3
                    color: parent.color
                }

                // 表头列布局
                RowLayout {
                    z: 1
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: AppTheme.spacingMd

                    Repeater {
                        model: root.columns
                        delegate: Label {
                            required property var modelData
                            Layout.preferredWidth: modelData.width > 0 ? modelData.width : 0
                            Layout.fillWidth: modelData.width <= 0
                            text: modelData.title
                            color: AppTheme.muted
                            font.pixelSize: AppTheme.fontSmall
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    // 行操作按钮预留宽度
                    Item {
                        visible: !root.showAddButton
                        Layout.preferredWidth: 32
                    }
                }
            }

            // 表头分隔线
            AppDivider {
                Layout.fillWidth: true
            }

            // 行列表 带边框分支仅在表格模式实例化
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 6
                model: root.bordered ? root.model : 0
                delegate: root.rowDelegate
                clip: true
                spacing: AppTheme.spacingXs

                // 空列表提示
                Label {
                    anchors.centerIn: parent
                    visible: root.emptyVisible
                             && (!root.model || root.model.length === 0)
                    text: root.emptyText
                    color: AppTheme.muted
                    font.pixelSize: AppTheme.fontBody
                }
            }
        }
    }
}
