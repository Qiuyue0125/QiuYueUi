// 本文件定义波形图表共用的图例列表
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

// 定义波形图表共用的图例列表
Item {
    id: root

    // 显示图例使用的曲线模型
    property var seriesModel: null
    // 是否显示图例
    property bool showLegend: true
    // 是否使用紧凑布局
    property bool compact: false
    // 当前曲线数量
    property int seriesCount: 0
    // 图例右侧为工具栏预留的宽度
    property int rightReserved: 14
    // 图例左侧与坐标轴的距离
    property int leftMargin: 62
    // 数值格式化回调
    property var numberFormatter: function(value) { return String(value) }

    visible: root.showLegend && !root.compact && root.seriesCount > 0

    // 提供可滚动内容区域
    Flickable {
        anchors.left: parent.left
        anchors.leftMargin: root.leftMargin
        anchors.right: parent.right
        anchors.rightMargin: root.rightReserved
        anchors.top: parent.top
        anchors.topMargin: 14
        height: 60
        clip: true
        contentWidth: width
        contentHeight: legendFlow.implicitHeight
        boundsBehavior: Flickable.StopAtBounds
        // 显示垂直滚动条（可滚动时始终显示，否则隐藏）
        ScrollBar.vertical: ThemedScrollBar {
            policy: legendFlow.implicitHeight > parent.height
                    ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }

        // 流式排列子元素
        Flow {
            id: legendFlow
            width: parent.width
            spacing: AppTheme.spacingMd
            // 按模型生成重复项
            Repeater {
                model: root.seriesModel
                // 定义列表项
                delegate: Row {
                    id: legendRow

                    required property string messageName
                    required property string fieldName
                    required property color seriesColor
                    required property real minimumValue
                    required property real maximumValue

                    spacing: AppTheme.spacingSm
                    height: 22
                    // 显示序列颜色标记
                    Rectangle {
                        width: 18
                        height: 3
                        anchors.verticalCenter: parent.verticalCenter
                        color: legendRow.seriesColor
                    }
                    // 显示曲线名称和数值范围
                    ElidedLabel {
                        width: Math.min(230, implicitWidth)
                        text: legendRow.messageName + "." + legendRow.fieldName + "  ["
                              + root.numberFormatter(legendRow.minimumValue) + ", "
                              + root.numberFormatter(legendRow.maximumValue) + "]"
                        color: AppTheme.muted
                        font.pixelSize: AppTheme.fontCaption
                        elide: Text.ElideMiddle
                    }
                }
            }
        }
    }
}
