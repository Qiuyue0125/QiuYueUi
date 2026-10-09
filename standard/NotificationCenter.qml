// 本文件管理可复用消息提示的排列和生命周期
pragma ComponentBehavior: Bound
import QtQuick

// 管理可复用消息提示的排列和生命周期
Item {
    id: root

    property int nextNotificationId: 0
    property int maximumToastWidth: AppTheme.notificationMaximumWidth
    property int toastSpacing: AppTheme.spacingMd

    // 添加一条消息提示
    function show(message, level) {
        if (message.trim().length === 0)
            return
        notificationModel.append({
            "messageText": message,
            "messageLevel": level || "info",
            "displaySlot": findAvailableSlot(),
            "notificationId": nextNotificationId++
        })
    }

    // 返回当前最靠下的空闲位置
    function findAvailableSlot() {
        let slot = 0
        let occupied = true
        while (occupied) {
            occupied = false
            for (let index = 0; index < notificationModel.count; ++index) {
                if (notificationModel.get(index).displaySlot === slot) {
                    occupied = true
                    ++slot
                    break
                }
            }
        }
        return slot
    }

    // 删除指定消息提示
    function removeNotification(notificationId) {
        for (let index = 0; index < notificationModel.count; ++index) {
            if (notificationModel.get(index).notificationId === notificationId) {
                notificationModel.remove(index)
                return
            }
        }
    }

    // 保存当前可见消息提示
    ListModel {
        id: notificationModel
    }

    // 为每条消息创建提示组件
    Repeater {
        model: notificationModel

        // 显示单条消息提示
        delegate: NotificationToast {
            id: toast

            required property int displaySlot
            required property int notificationId

            anchors.right: root.right
            anchors.bottom: root.bottom
            anchors.bottomMargin: toast.displaySlot * (height + root.toastSpacing)
            maximumWidth: root.maximumToastWidth
            onDismissed: root.removeNotification(toast.notificationId)
        }
    }
}
