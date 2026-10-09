// 本文件定义无边框窗口的标题栏拖动区域和窗口按钮
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

// 定义无边框窗口的标题栏拖动区域和窗口按钮
Rectangle {
    id: root

    required property ApplicationWindow targetWindow
    property string titleText: targetWindow.title
    property url iconSource: ""

    implicitHeight: AppTheme.titleBarHeight
    color: AppTheme.sidebar
    border.width: AppTheme.borderWidth
    border.color: AppTheme.border

    // 左侧显示应用标识窗口控制按钮固定在最右侧
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        spacing: AppTheme.spacingXl
        // 显示应用图标
        Image {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            visible: root.iconSource.toString().length > 0
            source: root.iconSource
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
        // 显示窗口标题
        Label {
            text: root.titleText
            color: AppTheme.text
            font.pixelSize: AppTheme.fontBody
            font.bold: true
        }
        // 将窗口按钮推到标题栏右侧
        Item {
            Layout.fillWidth: true
        }
        // 三个按钮分别控制最小化最大化或还原以及关闭
        RowLayout {
            spacing: 0
            // 最小化目标窗口
            WindowButton {
                iconType: "minimize"
                onClicked: root.targetWindow.showMinimized()
            }
            // 切换目标窗口最大化状态
            WindowButton {
                iconType: root.targetWindow.visibility === Window.Maximized
                          ? "restore" : "maximize"
                onClicked: root.targetWindow.visibility === Window.Maximized
                           ? root.targetWindow.showNormal() : root.targetWindow.showMaximized()
            }
            // 关闭目标窗口
            WindowButton {
                iconType: "close"
                danger: true
                onClicked: root.targetWindow.close()
            }
        }
    }

    // 仅空白标题区域响应拖动右侧按钮仍保持正常点击
    DragHandler {
        target: null
        acceptedButtons: Qt.LeftButton
        onActiveChanged: if (active) root.targetWindow.startSystemMove()
    }
}
