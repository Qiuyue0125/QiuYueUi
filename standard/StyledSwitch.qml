// 本文件定义指示器在左提示文字在右的统一开关控件
import QtQuick
import QtQuick.Controls

// 定义指示器在左提示文字在右的统一开关控件
Switch {
    id: control

    implicitWidth: indicator.implicitWidth + label.implicitWidth + 12
    implicitHeight: 28
    spacing: AppTheme.spacingMd
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.NoFocus

    // 鼠标悬浮在开关上时显示手形指针
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    // 指示器使用短矩形轨道和可移动滑块表示开关状态
    indicator: Rectangle {
        implicitWidth: 38
        implicitHeight: 20
        x: 0
        y: (control.height - height) / 2
        radius: AppTheme.smallRadius
        color: control.checked ? AppTheme.accent : AppTheme.surface
        border.width: AppTheme.borderWidth
        border.color: control.checked ? AppTheme.accent : control.hovered ? AppTheme.accent : AppTheme.border

        // 根据开关状态移动滑块
        Rectangle {
            width: 14
            height: 14
            radius: AppTheme.compactRadius
            x: control.checked ? parent.width - width - 3 : 3
            y: 3
            color: control.checked ? AppTheme.accentText : AppTheme.muted
            // 平滑切换滑块位置
            Behavior on x {
                // 动画更新滑块横坐标
                NumberAnimation {
                    duration: AppTheme.effectiveAnimationDuration(
                                  AppTheme.controlSlideDuration)
                }
            }
        }
    }

    // 显示开关文字
    contentItem: Label {
        id: label
        leftPadding: control.indicator.width + control.spacing
        text: control.text
        color: AppTheme.text
        font.pixelSize: AppTheme.fontBody
        verticalAlignment: Text.AlignVCenter
    }
}
