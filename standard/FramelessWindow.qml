// 本文件定义带自定义标题栏缩放热区和开关动画的无边框窗口
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Window

// 定义带自定义标题栏缩放热区和开关动画的无边框窗口
ApplicationWindow {
    id: root

    default property alias windowContent: contentHost.data
    property string titleText: title
    property url iconSource: ""
    property bool animated: true
    property bool closing: false
    property int resizeBorderWidth: AppTheme.windowResizeBorderWidth
    property int resizeCornerSize: AppTheme.windowResizeCornerSize

    // 覆盖窗口外沿 不拦截鼠标操作 颜色随主题切换
    Rectangle {
        parent: root.contentItem
        anchors.fill: parent
        color: "transparent"
        border.width: AppTheme.borderWidth
        border.color: AppTheme.border
        z: 100
    }

    // 定义可复用的 ResizeHandle 组件
    component ResizeHandle: MouseArea {
        required property int edges

        cursorShape: edges === Qt.LeftEdge || edges === Qt.RightEdge
                     ? Qt.SizeHorCursor
                     : edges === Qt.TopEdge || edges === Qt.BottomEdge
                       ? Qt.SizeVerCursor
                       : edges === (Qt.LeftEdge | Qt.TopEdge) || edges === (Qt.RightEdge | Qt.BottomEdge)
                         ? Qt.SizeFDiagCursor : Qt.SizeBDiagCursor
        onPressed: root.startSystemResize(edges)
    }

    flags: Qt.Window | Qt.FramelessWindowHint
    color: AppTheme.workbench
    opacity: animated && AppTheme.animationsEnabled ? 0 : 1

    // 平滑更新数值属性
    NumberAnimation {
        id: enterAnimation
        target: root
        property: "opacity"
        from: 0
        to: 1
        duration: AppTheme.effectiveAnimationDuration(
                      AppTheme.windowEnterDuration)
        easing.type: AppTheme.enterEasing
    }

    // 平滑更新数值属性
    NumberAnimation {
        id: exitAnimation
        target: root
        property: "opacity"
        to: 0
        duration: AppTheme.effectiveAnimationDuration(
                      AppTheme.windowExitDuration)
        easing.type: AppTheme.windowExitEasing
        onStopped: root.close()
    }

    onVisibleChanged: {
        if (visible && animated && AppTheme.animationsEnabled)
            enterAnimation.restart()
    }

    onClosing: function (close) {
        if (animated && AppTheme.animationsEnabled && !closing) {
            close.accepted = false
            closing = true
            enterAnimation.stop()
            exitAnimation.restart()
        }
    }

    // 判断指定窗口坐标是否落在当前焦点控件内
    function containsActiveFocusItem(position) {
        const focusItem = root.activeFocusItem
        if (!focusItem)
            return false
        const localPosition = focusItem.mapFromItem(root.contentItem, position)
        return focusItem.contains(localPosition)
    }

    // 跟踪指针位置
    PointHandler {
        id: focusClearHandler
        parent: root.contentItem
        acceptedButtons: Qt.LeftButton
        onActiveChanged: {
            if (active && !root.containsActiveFocusItem(focusClearHandler.point.position))
                root.contentItem.forceActiveFocus(Qt.MouseFocusReason)
        }
    }

    // 显示窗口标题栏
    AppTitleBar {
        id: titleBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        targetWindow: root
        titleText: root.titleText
        iconSource: root.iconSource
        z: 2
    }

    // 提供布局容器
    Item {
        id: contentHost
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
    }

    // 提供布局容器
    Item {
        anchors.fill: parent
        z: 1000
        visible: root.visibility !== Window.Maximized

        // 调整窗口上边缘尺寸
        ResizeHandle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.resizeBorderWidth
            edges: Qt.LeftEdge
        }
        // 调整窗口下边缘尺寸
        ResizeHandle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.resizeBorderWidth
            edges: Qt.RightEdge
        }
        // 调整窗口左边缘尺寸
        ResizeHandle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: root.resizeBorderWidth
            edges: Qt.TopEdge
        }
        // 调整窗口右边缘尺寸
        ResizeHandle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: root.resizeBorderWidth
            edges: Qt.BottomEdge
        }
        // 调整窗口左上角尺寸
        ResizeHandle {
            anchors.left: parent.left
            anchors.top: parent.top
            width: root.resizeCornerSize
            height: root.resizeCornerSize
            z: 1
            edges: Qt.LeftEdge | Qt.TopEdge
        }
        // 调整窗口右上角尺寸
        ResizeHandle {
            anchors.right: parent.right
            anchors.top: parent.top
            width: root.resizeCornerSize
            height: root.resizeCornerSize
            z: 1
            edges: Qt.RightEdge | Qt.TopEdge
        }
        // 调整窗口左下角尺寸
        ResizeHandle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: root.resizeCornerSize
            height: root.resizeCornerSize
            z: 1
            edges: Qt.LeftEdge | Qt.BottomEdge
        }
        // 调整窗口右下角尺寸
        ResizeHandle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: root.resizeCornerSize
            height: root.resizeCornerSize
            z: 1
            edges: Qt.RightEdge | Qt.BottomEdge
        }
    }
}
