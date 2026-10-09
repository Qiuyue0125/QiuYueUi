// 本文件定义窗口控制按钮使用的矢量图标组件
import QtQuick

// 定义最小化最大化还原和关闭四种窗口图标供窗口按钮复用
Item {
    id: root

    // 图标类型 minimize 最小化 maximize 最大化 restore 还原 close 关闭
    property string iconType: "minimize"
    // 图标颜色
    property color iconColor: AppTheme.text

    // 固定图标绘制区域
    implicitWidth: 16
    implicitHeight: 16

    // 最小化 一条水平短线
    Rectangle {
        visible: root.iconType === "minimize"
        anchors.centerIn: parent
        width: 12
        height: 2
        radius: AppTheme.iconRadius
        color: root.iconColor
    }

    // 最大化 方框轮廓
    Rectangle {
        visible: root.iconType === "maximize"
        anchors.centerIn: parent
        width: 12
        height: 12
        radius: AppTheme.iconRadius
        border.width: AppTheme.iconBorderWidth
        border.color: root.iconColor
        color: "transparent"
    }

    // 还原 前后两个方框
    Item {
        visible: root.iconType === "restore"
        anchors.centerIn: parent
        width: 14
        height: 14
        // 后层方框
        Rectangle {
            x: 0
            y: 0
            width: 10
            height: 10
            radius: AppTheme.iconRadius
            border.width: AppTheme.iconBorderWidth
            border.color: root.iconColor
            color: "transparent"
        }
        // 前层方框
        Rectangle {
            x: 4
            y: 4
            width: 10
            height: 10
            radius: AppTheme.iconRadius
            border.width: AppTheme.iconBorderWidth
            border.color: root.iconColor
            color: "transparent"
        }
    }

    // 关闭 叉号
    Item {
        visible: root.iconType === "close"
        anchors.centerIn: parent
        width: 14
        height: 14
        // 斜向叉号一
        Rectangle {
            anchors.centerIn: parent
            width: 13
            height: 2
            radius: AppTheme.iconRadius
            color: root.iconColor
            rotation: 45
        }
        // 斜向叉号二
        Rectangle {
            anchors.centerIn: parent
            width: 13
            height: 2
            radius: AppTheme.iconRadius
            color: root.iconColor
            rotation: -45
        }
    }
}
