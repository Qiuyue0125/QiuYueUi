// 本文件统一主题弹窗进入和退出时的透明度与缩放动画
import QtQuick

// 统一主题弹窗进入和退出时的透明度与缩放动画
Transition {
    id: root

    // 为 true 时使用进入参数否则使用退出参数
    required property bool entering

    // 同时执行透明度和缩放动画
    ParallelAnimation {
        // 调整弹窗透明度
        NumberAnimation {
            property: "opacity"
            from: root.entering ? 0 : 1
            to: root.entering ? 1 : 0
            duration: AppTheme.effectiveAnimationDuration(
                          root.entering ? AppTheme.popupEnterDuration
                                        : AppTheme.popupExitDuration)
            easing.type: root.entering ? AppTheme.enterEasing : AppTheme.exitEasing
        }
        // 调整弹窗缩放比例
        NumberAnimation {
            property: "scale"
            from: root.entering ? 0.97 : 1
            to: root.entering ? 1 : 0.98
            duration: AppTheme.effectiveAnimationDuration(
                          root.entering ? AppTheme.popupEnterDuration
                                        : AppTheme.popupExitDuration)
            easing.type: root.entering ? AppTheme.enterEasing : AppTheme.exitEasing
        }
    }
}
