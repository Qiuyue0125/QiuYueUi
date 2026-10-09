// 本文件定义支持增删改名和拖动排序的标签条
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义支持增删改名和拖动排序的标签条
Rectangle {
    id: root

    // tabModel 的每一项必须提供 title 字段
    required property var tabModel
    // currentIndex 由使用者保存组件通过信号请求修改
    property int currentIndex: 0

    signal currentIndexRequested(int index)
    signal addRequested()
    signal closeRequested(int index)
    signal renameRequested(int index, string title)
    signal moveRequested(int from, int to)

    // 返回 ListModel 或普通数组中的标签数量
    function tabCount() {
        return root.tabModel.count !== undefined ? root.tabModel.count : root.tabModel.length
    }

    implicitHeight: 34
    color: AppTheme.sidebar
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft

    // 标签从左到右排列新建按钮紧跟最后一个标签
    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 8
        spacing: 0

        // 按模型生成重复项
        Repeater {
            model: root.tabModel

            // 定义列表项
            delegate: Rectangle {
                id: tab

                required property int index
                required property string title
                readonly property bool selected: tab.index === root.currentIndex
                property bool renaming: false
                // 保存一次拖动的水平距离用于计算目标下标
                property real finalDragX: 0

                Layout.preferredWidth: 164
                Layout.fillHeight: true
                color: tab.selected ? AppTheme.surface
                                    : tabMouse.containsMouse ? AppTheme.accentSoft : "transparent"
                border.width: AppTheme.borderWidth
                border.color: tab.selected ? AppTheme.border : "transparent"

                // 首个标签绘制左侧边界
                Rectangle {
                    visible: tab.index === 0
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: AppTheme.border
                }

                // 每个标签绘制右侧边界形成清晰分隔
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: AppTheme.border
                }

                // 显示标签标题
                Label {
                    visible: !tab.renaming
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: closeButton.left
                    anchors.rightMargin: 3
                    anchors.verticalCenter: parent.verticalCenter
                    text: tab.title
                    color: tab.selected ? AppTheme.text : AppTheme.muted
                    font.pixelSize: AppTheme.fontBody
                    elide: Text.ElideRight
                }

                // 编辑标签标题
                StyledTextField {
                    // 重命名输入框覆盖原标签文字提交后恢复普通显示
                    id: renameField
                    visible: tab.renaming
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.right: closeButton.left
                    anchors.rightMargin: 3
                    anchors.verticalCenter: parent.verticalCenter
                    height: 30
                    text: tab.title
                    onEditingFinished: {
                        root.renameRequested(tab.index, text.trim().length > 0 ? text.trim() : tab.title)
                        tab.renaming = false
                    }
                    Keys.onEscapePressed: tab.renaming = false
                }

                // 显示图标操作按钮
                IconButton {
                    id: closeButton
                    anchors.right: parent.right
                    anchors.rightMargin: 3
                    anchors.verticalCenter: parent.verticalCenter
                    width: 28
                    height: AppTheme.compactControlHeight
                    iconType: "close"
                    danger: true
                    toolTip: "关闭"
                    onClicked: root.closeRequested(tab.index)
                }

                // 处理点击交互
                MouseArea {
                    // 单击切换页面双击进入重命名状态
                    id: tabMouse
                    anchors.fill: parent
                    anchors.rightMargin: closeButton.width
                    enabled: !tab.renaming
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.currentIndexRequested(tab.index)
                    onDoubleClicked: {
                        tab.renaming = true
                        Qt.callLater(function() {
                            renameField.forceActiveFocus()
                            renameField.selectAll()
                        })
                    }
                }

                // 调整元素绘制位置
                transform: Translate {
                    // 拖动期间只显示位移实际模型顺序在释放后修改
                    x: dragHandler.active
                       ? Math.max(-tab.x, Math.min(dragHandler.translation.x, root.width - tab.x - tab.width))
                       : 0
                }

                // 拖动结束后按标签宽度计算新的排列位置
                DragHandler {
                    id: dragHandler
                    target: null
                    acceptedDevices: PointerDevice.Mouse
                    yAxis.enabled: false
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    onTranslationChanged: if (active) tab.finalDragX = translation.x
                    onActiveChanged: {
                        if (active) {
                            tab.finalDragX = 0
                            root.currentIndexRequested(tab.index)
                            return
                        }
                        const step = tab.width
                        const targetIndex = Math.max(0, Math.min(root.tabCount() - 1,
                                                                 Math.round(
                                                                     (tab.index * step + tab.finalDragX)
                                                                     / step)))
                        if (targetIndex !== tab.index)
                            root.moveRequested(tab.index, targetIndex)
                        tab.finalDragX = 0
                    }
                }
            }
        }

        // 显示图标操作按钮
        IconButton {
            // 新建动作由页面处理标签条不创建业务模型
            Layout.preferredWidth: 34
            Layout.fillHeight: true
            iconType: "plus"
            accent: true
            toolTip: "新建"
            onClicked: root.addRequested()
        }

        // 填充标签条剩余宽度
        Item {
            Layout.fillWidth: true
        }
    }
}
