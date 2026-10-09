// 统一承载侧栏内容和边缘宽度拖动行为
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // 侧栏内容通过默认属性注入，使用方不需要额外包一层 Item
    default property alias contentData: contentHost.data

    // width 由 panelWidth 驱动，适合直接放入 RowLayout
    property real panelWidth: AppTheme.sidebarWidth
    property real minimumWidth: AppTheme.sidebarMinimumWidth
    property real maximumWidth: AppTheme.sidebarMaximumWidth
    property real resizeHandleWidth: AppTheme.sidebarResizeHandleWidth
    property bool resizeFromLeft: false
    property bool resizeEnabled: true
    property bool externalWidthControl: false

    // 用户完成拖动后通知外层保存宽度，保留外层宽度状态的绑定
    signal resizeRequested(real width)

    implicitWidth: panelWidth
    Layout.preferredWidth: panelWidth
    Layout.minimumWidth: minimumWidth
    Layout.maximumWidth: maximumWidth

    Item {
        id: contentHost
        anchors.fill: parent
    }

    // 覆盖在侧栏边缘的热区不占用布局空间
    Item {
        id: resizeHandle
        z: 100
        width: root.resizeHandleWidth
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: root.resizeFromLeft ? undefined : parent.right
        anchors.left: root.resizeFromLeft ? parent.left : undefined
        visible: root.resizeEnabled

        HoverHandler {
            cursorShape: Qt.SizeHorCursor
        }

        DragHandler {
            id: resizeDrag
            target: null
            acceptedButtons: Qt.LeftButton
            xAxis.enabled: true
            yAxis.enabled: false

            property real initialWidth: root.panelWidth

            onActiveChanged: {
                if (active)
                    initialWidth = root.panelWidth
            }

            onTranslationChanged: {
                if (!active)
                    return
                const direction = root.resizeFromLeft ? -1 : 1
                const nextWidth = Math.max(root.minimumWidth,
                                           Math.min(root.maximumWidth,
                                                    initialWidth + direction * translation.x))
                if (!root.externalWidthControl)
                    root.panelWidth = nextWidth
                root.resizeRequested(nextWidth)
            }
        }
    }
}
