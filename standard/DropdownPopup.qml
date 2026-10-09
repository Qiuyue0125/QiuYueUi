// 本文件定义下拉选择类浮层共用的主题背景
import QtQuick
import QtQuick.Controls

// 下拉浮层沿用 Qt Popup 的既有显示行为，仅统一外观和复用边界
Popup {
    id: root

    property color panelColor: AppTheme.surface
    property color outlineColor: AppTheme.border
    property real panelRadius: AppTheme.smallRadius

    padding: 1

    background: Rectangle {
        color: root.panelColor
        border.width: AppTheme.borderWidth
        border.color: root.outlineColor
        radius: root.panelRadius
    }
}
