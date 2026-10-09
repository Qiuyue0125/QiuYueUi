// 本文件定义可复用的主题消息提示
import QtQuick
import QtQuick.Controls

// 定义可复用的主题消息提示
Rectangle {
    id: root

    required property string messageText
    required property string messageLevel
    property int maximumWidth: AppTheme.notificationMaximumWidth
    property int displayDuration: AppTheme.notificationDisplayDuration

    signal dismissed()

    width: Math.min(root.maximumWidth, messageLabel.implicitWidth + 32)
    height: 40
    color: root.messageLevel === "error" ? AppTheme.dangerHover
                                          : root.messageLevel === "warning"
                                            ? AppTheme.warningHover : AppTheme.surface
    border.width: AppTheme.borderWidth
    border.color: root.messageLevel === "error" ? AppTheme.red
                                                 : root.messageLevel === "warning"
                                                   ? AppTheme.warning : AppTheme.accent
    radius: AppTheme.smallRadius
    opacity: 0

    // 提供提示进入时的垂直位移
    transform: Translate {
        id: notificationOffset
        y: 8
    }

    Component.onCompleted: showAnimation.start()

    // 显示消息正文
    Label {
        id: messageLabel
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        text: root.messageText
        color: AppTheme.text
        font.pixelSize: AppTheme.fontBody
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    // 同时执行提示淡入和上移动画
    ParallelAnimation {
        id: showAnimation
        // 淡入提示
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0
            to: 1
            duration: AppTheme.effectiveAnimationDuration(
                          AppTheme.notificationEnterDuration)
            easing.type: AppTheme.enterEasing
        }
        // 将提示移动到最终位置
        NumberAnimation {
            target: notificationOffset
            property: "y"
            from: 8
            to: 0
            duration: AppTheme.effectiveAnimationDuration(
                          AppTheme.notificationEnterDuration)
            easing.type: AppTheme.enterEasing
        }
    }

    // 依次执行淡出和销毁通知
    SequentialAnimation {
        id: hideAnimation
        // 淡出提示
        NumberAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: AppTheme.effectiveAnimationDuration(
                          AppTheme.notificationExitDuration)
            easing.type: AppTheme.exitEasing
        }
        // 请求消息中心移除当前提示
        ScriptAction {
            script: root.dismissed()
        }
    }

    // 到达显示时长后启动淡出动画
    Timer {
        interval: root.displayDuration
        running: true
        onTriggered: hideAnimation.start()
    }
}
