// 本文件定义可复用的日期时间输入框和选择弹窗
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils/DateTimeUtils.js" as DateTimeUtils

// 定义可复用的日期时间输入框和选择弹窗
RowLayout {
    id: root

    required property string title
    property string defaultDateText: "1970-01-01"
    property string defaultTimeText: "00:00:00"
    property string dateText: defaultDateText
    property string timeText: defaultTimeText
    property int displayedYear: 0
    property int displayedMonth: 0
    property date pendingDate: new Date()
    property bool editingMonthTitle: false
    property string editYearText: ""
    property string editMonthText: ""

    signal editingFinished

    // 定义可复用的 MutedLabel 组件
    component MutedLabel: Label {
        color: AppTheme.muted
        font.pixelSize: AppTheme.fontBody
    }

    // 定义可复用的 TimeField 组件
    component TimeField: StyledSpinBox {
        Layout.fillWidth: true
        Layout.minimumWidth: 68
        from: 0
    }

    // 统一年份和月份输入框的校验提交与失焦处理
    component MonthTitleField: StyledTextField {
        id: field
        required property bool editsYear
        Layout.preferredWidth: editsYear ? 64 : 44
        Layout.fillHeight: true
        text: editsYear ? root.editYearText : root.editMonthText
        inputMethodHints: Qt.ImhDigitsOnly
        // 限制年份或月份输入范围
        validator: IntValidator {
            bottom: 1
            top: field.editsYear ? 9999 : 12
        }
        horizontalAlignment: TextInput.AlignHCenter
        onTextEdited: {
            if (editsYear)
                root.editYearText = text
            else
                root.editMonthText = text
        }
        onAccepted: root.applyMonthTitleEdit()
        onActiveFocusChanged: if (!activeFocus)
            Qt.callLater(root.applyMonthTitleEditAfterFocusLoss)
    }

    Layout.fillWidth: true
    implicitHeight: 34
    spacing: AppTheme.spacingSm
    // 返回完整的日期时间文字
    function valueText() {
        return dateText.length > 0 && timeText.length > 0 ? dateText + " " + timeText : ""
    }

    // 恢复默认日期和时间
    function resetDefault() {
        dateText = defaultDateText
        timeText = defaultTimeText
    }

    // 将数值补齐为两位文字
    function twoDigits(value) {
        return DateTimeUtils.twoDigits(value)
    }

    // 返回输入框显示文字
    function displayText() {
        return valueText() || "选择日期时间"
    }

    // 使用当前值初始化并打开日期时间选择器
    function openPicker() {
        editingMonthTitle = false
        const selectedDate = DateTimeUtils.parseDateText(dateText) || new Date()

        pendingDate = selectedDate
        displayedYear = selectedDate.getFullYear()
        displayedMonth = selectedDate.getMonth()

        const parts = DateTimeUtils.parseTimeParts(timeText, defaultTimeText)
        hourInput.value = parts[0]
        minuteInput.value = parts[1]
        secondInput.value = parts[2]
        picker.open()
    }

    // 按偏移量切换显示月份
    function changeMonth(offset) {
        const next = DateTimeUtils.shiftMonth(displayedYear, displayedMonth, offset)
        displayedYear = next.year
        displayedMonth = next.month
    }

    // 提交标题编辑后切换显示月份
    function navigateMonth(offset) {
        finishEditing()
        changeMonth(offset)
    }

    // 进入年份和月份标题编辑状态
    function beginMonthTitleEdit() {
        editYearText = displayedYear.toString()
        editMonthText = twoDigits(displayedMonth + 1)
        editingMonthTitle = true
        yearEdit.forceActiveFocus()
        yearEdit.selectAll()
    }

    // 校验并提交年份和月份标题编辑
    function applyMonthTitleEdit() {
        if (!editingMonthTitle)
            return
        const year = Number(editYearText)
        const month = Number(editMonthText)
        if (Number.isInteger(year) && Number.isInteger(month)
                && year >= 1 && year <= 9999 && month >= 1 && month <= 12) {
            displayedYear = year
            displayedMonth = month - 1
            const day = DateTimeUtils.clampDay(year, month, pendingDate.getDate())
            pendingDate = new Date(year, displayedMonth, day)
        }
        editingMonthTitle = false
    }

    // 标题输入框全部失焦后提交编辑
    function applyMonthTitleEditAfterFocusLoss() {
        if (editingMonthTitle && !yearEdit.activeFocus && !monthEdit.activeFocus)
            applyMonthTitleEdit()
    }

    // 提交时分秒输入值
    function commitTimeInputs() {
        hourInput.commitValue()
        minuteInput.commitValue()
        secondInput.commitValue()
    }

    // 完成选择器内当前编辑操作
    function finishEditing() {
        applyMonthTitleEdit()
        commitTimeInputs()
        picker.contentItem.forceActiveFocus()
    }

    // 保存选择结果并关闭弹窗
    function acceptSelection() {
        applyMonthTitleEdit()
        commitTimeInputs()
        dateText = Qt.formatDateTime(pendingDate, "yyyy-MM-dd")
        timeText = twoDigits(hourInput.value) + ":"
                + twoDigits(minuteInput.value) + ":"
                + twoDigits(secondInput.value)
        picker.close()
        editingFinished()
    }

    // 恢复默认值并关闭弹窗
    function resetSelection() {
        editingMonthTitle = false
        resetDefault()
        picker.close()
        editingFinished()
    }

    // 显示日期时间字段名称
    Label {
        Layout.preferredWidth: 30
        text: root.title
        color: AppTheme.muted
        font.pixelSize: AppTheme.fontSmall
        verticalAlignment: Text.AlignVCenter
    }

    // 编辑“选择日期时间”配置
    StyledTextField {
        Layout.fillWidth: true
        text: root.displayText()
        placeholderText: "选择日期时间"
        readOnly: true
        color: root.valueText().length > 0 ? AppTheme.text : AppTheme.muted
        horizontalAlignment: TextInput.AlignLeft

        // 处理点击交互
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.openPicker()
        }
    }

    // 零尺寸宿主隔离 RowLayout，浮层本身挂到全局 Overlay
    Item {
        Layout.preferredWidth: 0
        Layout.preferredHeight: 0

        // 显示轻量浮层
        AppPopup {
            id: picker

            width: 420
            height: 510
            padding: 16
            onClosed: root.editingMonthTitle = false
            onBackgroundPressed: root.finishEditing()

            // 定义控件内容
            contentItem: ColumnLayout {
                spacing: AppTheme.spacingLg
                // 承载选择器标题和分隔线
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 39

                    // 显示日期时间选择器标题
                    Label {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 34
                        text: root.title + "时间"
                        color: AppTheme.accent
                        font.pixelSize: 19
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    // 绘制选择器标题分隔线
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 350
                        height: 2
                        color: AppTheme.border
                    }
                }

                // 横向排列
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34

                    // 显示方向按钮
                    ArrowButton {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 30
                        pointsLeft: true
                        doubleArrow: true
                        bold: true
                        onClicked: root.navigateMonth(-12)
                    }
                    // 显示方向按钮
                    ArrowButton {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 30
                        pointsLeft: true
                        bold: true
                        onClicked: root.navigateMonth(-1)
                    }
                    // 将月份标题推到中间
                    Item {
                        Layout.fillWidth: true
                    }
                    // 承载月份标题及编辑框
                    Item {
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 30

                        // 显示当前年份和月份
                        Label {

                            anchors.fill: parent
                            visible: !root.editingMonthTitle
                            text: root.displayedYear + "年 " + (root.displayedMonth + 1) + "月"
                            color: AppTheme.text
                            font.pixelSize: 17
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            // 处理点击交互
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onDoubleClicked: root.beginMonthTitleEdit()
                            }
                        }

                        // 横向排列
                        RowLayout {
                            anchors.fill: parent
                            visible: root.editingMonthTitle
                            spacing: 3

                            // 编辑当前显示年份
                            MonthTitleField {
                                id: yearEdit
                                editsYear: true
                            }
                            // 显示弱化提示文字
                            MutedLabel {
                                text: "年"
                            }
                            // 编辑当前显示月份
                            MonthTitleField {
                                id: monthEdit
                                editsYear: false
                            }
                            // 显示弱化提示文字
                            MutedLabel {
                                text: "月"
                            }
                        }
                    }
                    // 将右侧月份按钮推到末尾
                    Item {
                        Layout.fillWidth: true
                    }
                    // 显示方向按钮
                    ArrowButton {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 30
                        pointsLeft: false
                        bold: true
                        onClicked: root.navigateMonth(1)
                    }
                    // 显示方向按钮
                    ArrowButton {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 30
                        pointsLeft: false
                        doubleArrow: true
                        bold: true
                        onClicked: root.navigateMonth(12)
                    }
                }

                // 显示星期标题
                DayOfWeekRow {
                    id: dayOfWeekRow

                    locale: Qt.locale()
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    spacing: 0

                    // 定义列表项
                    delegate: Label {
                        required property string narrowName
                        width: dayOfWeekRow.width / 7
                        text: narrowName
                        color: AppTheme.muted
                        font.pixelSize: AppTheme.fontBody
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // 显示月份日期网格
                MonthGrid {
                    id: monthGrid

                    month: root.displayedMonth
                    year: root.displayedYear
                    locale: Qt.locale()
                    Layout.fillWidth: true
                    Layout.preferredHeight: 226
                    Layout.bottomMargin: 12
                    spacing: 0

                    // 定义列表项
                    delegate: Rectangle {
                        id: dayCell

                        required property date date
                        required property int day
                        required property int month
                        readonly property bool selected:
                            dayCell.date.getFullYear() === root.pendingDate.getFullYear()
                            && dayCell.date.getMonth() === root.pendingDate.getMonth()
                            && dayCell.date.getDate() === root.pendingDate.getDate()
                        readonly property bool currentMonth: dayCell.month === monthGrid.month

                        width: monthGrid.width / 7
                        height: monthGrid.height / 6
                        radius: AppTheme.smallRadius
                        color: dayCell.selected ? AppTheme.accent
                                                : dayHover.hovered ? AppTheme.hover : "transparent"

                        // 显示日期数字
                        Label {
                            anchors.centerIn: parent
                            text: dayCell.day
                            color: dayCell.selected ? AppTheme.accentText : AppTheme.text
                            opacity: dayCell.currentMonth ? 1.0 : 0.45
                            font.pixelSize: AppTheme.fontBodyLarge
                        }
                        // 跟踪悬浮状态
                        HoverHandler {
                            id: dayHover
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    onClicked: function (date) {
                        root.finishEditing()
                        root.pendingDate = date
                        root.displayedYear = date.getFullYear()
                        root.displayedMonth = date.getMonth()
                    }
                }

                // 横向排列
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    Layout.bottomMargin: 20
                    spacing: AppTheme.spacingSm
                    // 显示弱化提示文字
                    MutedLabel {
                        text: "时间"
                    }
                    // 编辑时间数值
                    TimeField {
                        id: hourInput
                        to: 23
                    }
                    // 显示弱化提示文字
                    MutedLabel {
                        text: ":"
                    }
                    // 编辑时间数值
                    TimeField {
                        id: minuteInput
                        to: 59
                    }
                    // 显示弱化提示文字
                    MutedLabel {
                        text: ":"
                    }
                    // 编辑时间数值
                    TimeField {
                        id: secondInput
                        to: 59
                    }
                }

                // 横向排列
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: AppTheme.controlHeight
                    spacing: AppTheme.spacingMd
                    // 执行“恢复默认”操作
                    AppButton {
                        text: "恢复默认"
                        onClicked: root.resetSelection()
                    }
                    // 将确认操作推到右侧
                    Item {
                        Layout.fillWidth: true
                    }
                    // 执行“取消”操作
                    AppButton {
                        text: "取消"
                        onClicked: {
                            root.editingMonthTitle = false
                            picker.close()
                        }
                    }
                    // 执行“确定”操作
                    AppButton {
                        text: "确定"
                        primary: true
                        onClicked: root.acceptSelection()
                    }
                }
            }
        }
    }
}
