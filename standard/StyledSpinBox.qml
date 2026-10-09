// 本文件定义隐藏调节箭头并允许直接编辑的整数输入框
import QtQuick
import QtQuick.Controls

// 定义隐藏调节箭头并允许直接编辑的整数输入框
SpinBox {
    id: control

    // 输入框提交后向使用者返回已经校验和限制范围的数值
    signal valueCommitted(int value)

    // 立即将当前编辑文字转换为数值避免等待失焦后才更新 value
    function commitValue() {
        const parsed = control.valueFromText(editor.text, control.locale)
        control.value = Math.max(control.from, Math.min(control.to, parsed))
        editor.text = String(control.value)
        return control.value
    }

    // 清除内部编辑器和外层数值框的完整焦点链
    function dismissFocus() {
        editor.focus = false
        control.focus = false
        const targetWindow = control.Window.window
        if (targetWindow)
            targetWindow.contentItem.forceActiveFocus(Qt.OtherFocusReason)
    }

    implicitWidth: 88
    implicitHeight: AppTheme.controlHeight
    editable: true
    focusPolicy: Qt.ClickFocus
    locale: Qt.locale("C")

    // 离开输入框时立即同步正在编辑的文字
    onActiveFocusChanged: {
        if (!activeFocus && editor.text !== String(control.value)) {
            const committedValue = control.commitValue()
            control.valueCommitted(committedValue)
        }
    }

    // TextInput 负责数值编辑校验和居中显示
    contentItem: TextInput {
        id: editor
        z: 2
        text: String(control.value)
        color: AppTheme.text
        selectionColor: AppTheme.accent
        selectedTextColor: AppTheme.accentText
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        topPadding: 4
        bottomPadding: 2
        font.pixelSize: AppTheme.fontBody
        validator: control.validator
        inputMethodHints: Qt.ImhDigitsOnly
        readOnly: !control.editable
        onAccepted: {
            const committedValue = control.commitValue()
            control.valueCommitted(committedValue)
            control.dismissFocus()
        }
    }

    // 隐藏系统加减按钮只允许键盘直接编辑数值
    up.indicator: Item {
        // 不为增加按钮预留空间
        implicitWidth: 0
        implicitHeight: 0
    }
    // 隐藏数值减少按钮
    down.indicator: Item {
        // 不为减少按钮预留空间
        implicitWidth: 0
        implicitHeight: 0
    }

    // 输入焦点使用主题强调色边框
    background: Rectangle {
        color: AppTheme.surface
        border.width: AppTheme.borderWidth
        border.color: control.activeFocus ? AppTheme.accent : AppTheme.border
        radius: AppTheme.smallRadius
    }
}
