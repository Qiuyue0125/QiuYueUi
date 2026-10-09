// 本文件定义通用矢量图标组件
import QtQuick

// 定义加号和关闭等通用图标供图标按钮复用
Item {
    id: root

    // 图标类型 plus 加号 close 关闭
    property string iconType: "plus"
    // 图标颜色
    property color iconColor: AppTheme.text

    // 固定图标绘制区域
    implicitWidth: 16
    implicitHeight: 16

    // 加号 横竖两条短线
    Item {
        visible: root.iconType === "plus"
        anchors.centerIn: parent
        width: 12
        height: 12
        // 横线
        Rectangle {
            anchors.centerIn: parent
            width: 12
            height: 2
            radius: AppTheme.iconRadius
            color: root.iconColor
        }
        // 竖线
        Rectangle {
            anchors.centerIn: parent
            width: 2
            height: 12
            radius: AppTheme.iconRadius
            color: root.iconColor
        }
    }

    // 关闭 叉号
    Item {
        visible: root.iconType === "close"
        anchors.centerIn: parent
        width: 13
        height: 13
        // 斜向叉号一
        Rectangle {
            anchors.centerIn: parent
            width: 12
            height: 2
            radius: AppTheme.iconRadius
            color: root.iconColor
            rotation: 45
        }
        // 斜向叉号二
        Rectangle {
            anchors.centerIn: parent
            width: 12
            height: 2
            radius: AppTheme.iconRadius
            color: root.iconColor
            rotation: -45
        }
    }
}
