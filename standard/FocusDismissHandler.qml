// 本文件统一处理点击输入框以外区域时清理焦点
import QtQuick

// 统一处理点击输入框以外区域时清理焦点
TapHandler {
    id: root

    property Item focusTarget

    acceptedButtons: Qt.LeftButton

    // 返回指定位置最深层的可视项
    function itemAtPosition(item, x, y) {
        let current = item
        let currentX = x
        let currentY = y
        while (current) {
            const child = current.childAt(currentX, currentY)
            if (!child)
                return current
            const point = child.mapFromItem(current, currentX, currentY)
            current = child
            currentX = point.x
            currentY = point.y
        }
        return null
    }

    // 判断点击项是否要求保留当前焦点
    function preventsDismiss(item) {
        let current = item
        while (current) {
            if (current.preventsFocusDismiss === true)
                return true
            if (current === root.parent)
                break
            current = current.parent
        }
        return false
    }

    // 查找当前焦点项所属的打开下拉框
    function hasVisiblePopup(item) {
        let current = item
        while (current) {
            if (current.popup && current.popup.visible)
                return true
            current = current.parent
        }
        return false
    }

    // 点击输入框以外区域时清理当前编辑焦点
    onTapped: eventPoint => {
        const target = root.focusTarget
        const clickedItem = root.itemAtPosition(root.parent,
                                                eventPoint.position.x,
                                                eventPoint.position.y)
        if (root.preventsDismiss(clickedItem))
            return
        const activeItem = target && target.Window.window
                           ? target.Window.window.activeFocusItem : null
        if (!target || !activeItem || activeItem === target)
            return
        const popupVisible = root.hasVisiblePopup(activeItem)
        if (popupVisible)
            return
        const point = activeItem.mapFromItem(root.parent,
                                             eventPoint.position.x,
                                             eventPoint.position.y)
        if (point.x < 0 || point.y < 0
                || point.x > activeItem.width || point.y > activeItem.height)
            target.forceActiveFocus(Qt.MouseFocusReason)
    }
}
