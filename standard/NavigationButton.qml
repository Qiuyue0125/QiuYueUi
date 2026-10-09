// 本文件定义带主题图标和选中标记的主导航按钮
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

// 定义带主题图标和选中标记的主导航按钮
Button {
    id: control

    required property url iconSource
    required property string route
    required property string currentRoute
    property string toolTip: ""

    implicitWidth: AppTheme.navigationButtonSize
    implicitHeight: AppTheme.navigationButtonSize
    width: 44
    height: 44
    padding: 0
    flat: true
    hoverEnabled: true
    focusPolicy: Qt.NoFocus

    display: AbstractButton.IconOnly

    // 禁用 Qt 默认内容绘制图标由下方 Image 独立渲染
    contentItem: Item {
        // 禁止默认内容占用布局
    }

    // 选中项使用左侧短色条悬浮和按下只改变按钮底色
    background: Rectangle {
        anchors.margins: 2
        radius: AppTheme.smallRadius
        color: control.pressed ? AppTheme.activityPressed
                               : control.hovered ? AppTheme.activityHover : "transparent"

        // 标记当前选中的路由
        Rectangle {
            visible: control.currentRoute === control.route
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.verticalCenter: parent.verticalCenter
            width: 4
            height: 18
            radius: 1
            color: AppTheme.activityMarker
        }
    }

    // 图标直接锚定按钮中心不受 Qt Controls 内部内容布局影响
    Image {
        anchors.centerIn: control
        width: control.route === "settings" ? 23 : 20
        height: width
        source: control.iconSource
        sourceSize.width: 128
        sourceSize.height: 128
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        layer.enabled: true
        // 使用主题色渲染单色导航图标
        layer.effect: MultiEffect {
            brightness: 1.0
            colorization: 1.0
            colorizationColor: control.currentRoute === control.route
                               ? AppTheme.activityMarker : AppTheme.activityIcon
        }
    }

    // 显示导航入口名称
    ThemedToolTip {
        visible: control.hovered
        text: control.toolTip
        x: control.width + 5
        y: (control.height - height) / 2
    }
}
