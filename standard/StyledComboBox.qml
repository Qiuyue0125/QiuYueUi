// 本文件定义跟随当前主题的统一下拉选择框
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

// 定义跟随当前主题的统一下拉选择框
ComboBox {
    id: control

    property int popupMaximumHeight: AppTheme.comboPopupMaximumHeight
    property bool popupScrollIndicatorVisible: true
    property string optionToolTipRole: ""
    property string currentToolTipText: ""
    // 阻止统一失焦处理拦截下拉框点击
    property bool preventsFocusDismiss: true

    implicitWidth: 150
    implicitHeight: 32
    rightPadding: 30
    leftPadding: rightPadding
    topPadding: 0
    bottomPadding: 0
    hoverEnabled: true
    focusPolicy: Qt.ClickFocus

    // 在选项框悬浮时显示手形指针
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    // 当前选项在输入区域内水平和垂直居中显示
    contentItem: Label {
        id: contentLabel
        leftPadding: 2
        rightPadding: 2
        text: control.displayText
        color: AppTheme.text
        font.pixelSize: AppTheme.fontBody
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // 悬浮在被截断的当前选项上时显示完整文字
    ThemedToolTip {
        visible: control.hovered
                 && (control.currentToolTipText.length > 0
                     || contentLabel.truncated
                     || contentLabel.implicitWidth > contentLabel.width)
        text: control.currentToolTipText.length > 0
              ? control.currentToolTipText : control.displayText
    }

    // 右侧箭头提示控件可以展开选择
    indicator: Label {
        x: control.width - width - 16
        y: (control.height - height) / 2
        text: "▾"
        color: AppTheme.muted
        font.pixelSize: AppTheme.fontSmall
    }

    // 展开状态按下状态和悬浮状态分别使用对应主题颜色
    background: Rectangle {
        color: control.pressed ? AppTheme.pressed : control.hovered ? AppTheme.hover : AppTheme.surface
        border.width: AppTheme.borderWidth
        border.color: control.popup.visible ? AppTheme.accent : AppTheme.border
        radius: AppTheme.smallRadius
    }

    // 每个选项使用固定行高便于快速扫描和点击
    delegate: ItemDelegate {
        id: optionDelegate

        required property var model
        required property int index
        required property var modelData
        width: control.popup.width
        height: AppTheme.controlHeight
        padding: 0
        highlighted: control.highlightedIndex === index

        readonly property string optionToolTipText: {
            if (control.optionToolTipRole.length === 0)
                return ""
            const value = model[control.optionToolTipRole]
            return value === undefined || value === null ? "" : String(value)
        }
        // 跟踪悬浮状态
        HoverHandler {
            id: optionHover
            cursorShape: Qt.PointingHandCursor
        }
        // 定义控件内容
        contentItem: Label {
            id: optionLabel
            text: optionDelegate.model[control.textRole] === undefined
                  ? optionDelegate.modelData : optionDelegate.model[control.textRole]
            color: AppTheme.text
            font.pixelSize: AppTheme.fontBody
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        // 定义控件背景
        background: Rectangle {
            color: optionDelegate.highlighted
                   ? AppTheme.accentSoft
                   : optionMouse.containsMouse ? AppTheme.hover : AppTheme.surface
        }
        // 显示操作提示（优先用 optionToolTipText，否则在选项文字被截断时显示完整文字）
        ThemedToolTip {
            visible: optionHover.hovered
                     && (optionDelegate.optionToolTipText.length > 0
                         || optionLabel.truncated
                         || optionLabel.implicitWidth > optionLabel.width)
            text: optionDelegate.optionToolTipText.length > 0
                  ? optionDelegate.optionToolTipText : optionLabel.text
        }

        // 独立处理鼠标选择避免外层焦点策略影响控件默认点击
        MouseArea {
            id: optionMouse
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            acceptedButtons: Qt.LeftButton
            onPressed: mouse => {
                mouse.accepted = true
                control.currentIndex = optionDelegate.index
                control.activated(optionDelegate.index)
            }
            onReleased: mouse => {
                mouse.accepted = true
                control.popup.close()
            }
        }
    }

    // 弹出列表限制最大高度选项过多时使用滚动条
    popup: DropdownPopup {
        y: control.height + 2
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight + 2, control.popupMaximumHeight)
        // 保持焦点在组合框以免选项点击被统一清焦拦截
        focus: false
        // 定义控件内容
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            // 使用主题滚动条，避免下拉弹窗沿用系统默认颜色
            ScrollBar.vertical: ThemedScrollBar {
                visible: control.popupScrollIndicatorVisible
                policy: control.popupScrollIndicatorVisible
                        ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }
        }
    }
}
