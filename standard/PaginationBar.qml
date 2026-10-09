// 本文件定义可复用的分页操作栏
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 定义可复用的分页操作栏
Rectangle {
    id: root

    // 页码从零开始，pageCount 和 totalCount 使用实际数量
    required property int page
    required property int pageCount
    required property int totalCount
    // 控制跳转提交方式和可选的刷新命令
    property bool commitOnJump: false
    property bool showRefresh: false
    property bool refreshEnabled: true

    signal pageRequested(int page)
    signal jumpRequested(int page)
    signal refreshRequested()

    // 提交输入的页码并转换为零基下标
    function submitJump(committedValue) {
        const value = committedValue === undefined
                      ? (commitOnJump ? pageInput.commitValue() : pageInput.value)
                      : committedValue
        root.jumpRequested(value - 1)
    }

    Layout.fillWidth: true
    color: AppTheme.sidebar
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft

    // 分页按钮布局
    RowLayout {
        anchors.centerIn: parent
        spacing: AppTheme.spacingLg
        // 首页按钮
        AppButton {
            Layout.preferredWidth: 60
            Layout.preferredHeight: AppTheme.compactControlHeight
            text: "首页"
            enabled: root.page > 0
            onClicked: root.pageRequested(0)
        }

        // 上一页按钮
        AppButton {
            Layout.preferredWidth: 72
            Layout.preferredHeight: AppTheme.compactControlHeight
            text: "上一页"
            enabled: root.page > 0
            onClicked: root.pageRequested(root.page - 1)
        }

        // 当前页码和记录数量
        Label {
            text: (root.page + 1) + " / " + root.pageCount
                  + "  共 " + root.totalCount + " 条"
            color: AppTheme.muted
            font.pixelSize: AppTheme.fontSmall
        }

        // 下一页按钮
        AppButton {
            Layout.preferredWidth: 72
            Layout.preferredHeight: AppTheme.compactControlHeight
            text: "下一页"
            enabled: root.page + 1 < root.pageCount
            onClicked: root.pageRequested(root.page + 1)
        }

        // 尾页按钮
        AppButton {
            Layout.preferredWidth: 60
            Layout.preferredHeight: AppTheme.compactControlHeight
            text: "尾页"
            enabled: root.page + 1 < root.pageCount
            onClicked: root.pageRequested(root.pageCount - 1)
        }

        // 显示页码跳转提示
        Label {
            text: "跳转"
            color: AppTheme.muted
            font.pixelSize: AppTheme.fontSmall
        }

        // 跳转页码输入框
        StyledSpinBox {
            id: pageInput
            Layout.preferredWidth: 64
            Layout.preferredHeight: AppTheme.compactControlHeight
            from: 1
            to: root.pageCount
            value: root.page + 1
            onValueCommitted: value => root.submitJump(value)
        }

        // 提交页码跳转按钮
        AppButton {
            Layout.preferredWidth: 52
            Layout.preferredHeight: AppTheme.compactControlHeight
            text: "确定"
            enabled: root.pageCount > 1
            onClicked: root.submitJump()
        }

        // 刷新当前页按钮
        AppButton {
            visible: root.showRefresh
            Layout.preferredWidth: 64
            Layout.preferredHeight: AppTheme.compactControlHeight
            text: "刷新"
            enabled: root.refreshEnabled
            onClicked: root.refreshRequested()
        }
    }
}
