// 本文件为被截断的主题文字统一显示完整内容提示
import QtQuick
import QtQuick.Controls

// 为被截断的主题文字统一显示完整内容提示
Label {
    id: root

    // 提示内容默认使用标签全文，可按需覆盖触发条件
    property string toolTipText: text
    property bool toolTipWhenTruncated: true
    // 提示延迟和停留时长与通用提示框默认值一致
    property int toolTipDelay: AppTheme.toolTipDelay
    property int toolTipTimeout: AppTheme.toolTipTimeout

    // 跟踪文字悬浮状态
    HoverHandler {
        id: hover
    }
    // 在文字截断时显示完整内容
    ThemedToolTip {
        visible: hover.hovered && root.toolTipText.length > 0
                 && (!root.toolTipWhenTruncated || root.truncated)
        text: root.toolTipText
        delay: root.toolTipDelay
        timeout: root.toolTipTimeout
    }
}
