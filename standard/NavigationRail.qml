// 本文件定义可切换路由的左侧导航栏
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// 定义可切换路由的左侧导航栏
Rectangle {
    id: rail

    // 当前路由控制选中状态
    required property string currentRoute
    // 每项提供 route、icon 和 tip，最后一项固定在导航栏底部
    required property var items
    // 用户点击按钮时请求外层容器切换路由
    signal routeRequested(string route)

    implicitWidth: AppTheme.navigationButtonSize
    color: AppTheme.activity

    // 首项之外的入口靠上排列最后一项固定在底部
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 生成顶部业务模块入口
        Repeater {
            model: rail.items.slice(0, -1)
            // 显示单个业务模块入口
            delegate: NavigationButton {
                required property var modelData
                iconSource: modelData.icon
                route: modelData.route
                currentRoute: rail.currentRoute
                toolTip: modelData.tip
                onClicked: rail.routeRequested(route)
            }
        }

        // 将最后一个入口推到导航栏底部
        Item {
            Layout.fillHeight: true
        }

        // 显示固定在底部的配置入口
        NavigationButton {
            readonly property var item: rail.items[rail.items.length - 1]
            iconSource: item.icon
            route: item.route
            currentRoute: rail.currentRoute
            toolTip: item.tip
            onClicked: rail.routeRequested(route)
        }
    }
}
