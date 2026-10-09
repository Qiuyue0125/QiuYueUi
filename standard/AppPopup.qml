// 本文件定义轻量浮层共用的主题背景和开关动画
import QtQuick
import QtQuick.Controls

// 定义轻量浮层共用的主题背景和开关动画
Popup {
    id: root

    signal backgroundPressed()
    property color panelColor: AppTheme.surface

    parent: Overlay.overlay
    anchors.centerIn: parent
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // 播放浮层进入动画
    enter: PopupTransition {
        entering: true
    }
    // 播放浮层退出动画
    exit: PopupTransition {
        entering: false
    }

    // 绘制浮层背景并接收背景点击
    background: Rectangle {
        color: root.panelColor
        border.color: AppTheme.border
        border.width: AppTheme.borderWidth
        radius: AppTheme.dialogRadius

        // 将背景点击转发给浮层使用者
        MouseArea {
            anchors.fill: parent
            onPressed: root.backgroundPressed()
        }
    }
}
