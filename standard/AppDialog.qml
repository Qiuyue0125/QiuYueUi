// 本文件定义通用主题弹窗的背景标题栏和开关动画
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义通用主题弹窗的背景标题栏和开关动画
Dialog {
    id: root

    property string headerSubtitle: ""
    property string headerDetail: ""
    property bool headerVisible: true
    property bool closeButtonVisible: false
    property int headerHeight: AppTheme.dialogHeaderHeight
    property color panelColor: AppTheme.workbench

    parent: Overlay.overlay
    anchors.centerIn: parent
    modal: true
    dim: true
    focus: true
    padding: 18
    closePolicy: Popup.CloseOnEscape
    standardButtons: Dialog.NoButton

    // 播放对话框进入动画
    enter: PopupTransition {
        entering: true
    }
    // 播放对话框退出动画
    exit: PopupTransition {
        entering: false
    }

    // 模态遮罩阻止指针和滚轮事件传递到底层页面
    Overlay.modal: MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true
        preventStealing: true
        propagateComposedEvents: false

        // 绘制弹窗模态遮罩
        Rectangle {
            anchors.fill: parent
            color: AppTheme.dimColor
        }

        // 模态遮罩事件拦截区域
        onPressed: mouse => mouse.accepted = true
        onReleased: mouse => mouse.accepted = true
        onClicked: mouse => mouse.accepted = true
        onWheel: wheel => wheel.accepted = true
    }

    // 统一处理弹窗内容区域的输入框失焦
    FocusDismissHandler {
        parent: root.contentItem
        focusTarget: root.contentItem
    }

    // 定义控件背景
    background: Rectangle {
        color: root.panelColor
        border.color: AppTheme.border
        border.width: AppTheme.borderWidth
        radius: AppTheme.dialogRadius
    }

    // 显示弹窗标题栏
    header: Rectangle {
        visible: root.headerVisible
        implicitHeight: root.headerVisible ? root.headerHeight : 0
        color: AppTheme.sidebar
        border.width: AppTheme.borderWidth
        border.color: AppTheme.borderSoft

        // 横向排列
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 8
            spacing: AppTheme.spacingLg
            // 显示对话框标题
            Label {
                text: root.title
                color: AppTheme.text
                font.pixelSize: AppTheme.fontSection
                font.bold: true
            }
            // 显示对话框副标题
            Label {
                visible: text.length > 0
                text: root.headerSubtitle
                color: AppTheme.muted
                font.pixelSize: AppTheme.fontSmall
            }
            // 分隔内容区域
            AppDivider {
                visible: root.headerSubtitle.length > 0 && root.headerDetail.length > 0
                vertical: true
                Layout.preferredHeight: 18
            }
            // 显示对话框补充信息
            Label {
                visible: text.length > 0
                Layout.maximumWidth: 420
                text: root.headerDetail
                color: AppTheme.muted
                font.pixelSize: AppTheme.fontSmall
                elide: Text.ElideMiddle
            }
            // 将关闭按钮推到标题栏右侧
            Item {
                Layout.fillWidth: true
            }
            // 显示图标操作按钮
            IconButton {
                visible: root.closeButtonVisible
                iconType: "close"
                danger: true
                onClicked: root.close()
            }
        }
    }
}
