// 本文件组合波形曲线坐标图例和框选交互
pragma ComponentBehavior: Bound
import QtQuick

// 组合波形曲线坐标图例和框选交互
Rectangle {
    id: root

    property var seriesModel: null
    property bool zoomed: false
    property bool pointMode: false
    property bool boldPointMode: false
    property int samplePointLimit: AppTheme.waveSamplePointLimit
    property real boldPointSize: AppTheme.waveBoldPointSize
    property int pointBatchSize: AppTheme.wavePointBatchSize
    property int seriesCount: 0
    property bool forceCompactLayout: false
    property bool showToolbar: true
    property bool showLegend: true
    property bool enableWindowActions: true
    property bool fullScreenEnabled: true
    property bool showCompactFullscreenButton: true
    // 页面可选的横轴文字格式化函数；为空时保持原有绝对秒显示
    property var xAxisLabelFormatter: null
    // 横轴文字超过相邻刻度可用宽度时自动分成两行
    property bool xAxisLabelsWrapped: false
    // 框选纵轴范围用于普通图与全屏图保持一致
    property real zoomMinimumY: 0
    property real zoomMaximumY: 0
    readonly property bool compactLayout: forceCompactLayout || height < 220
    readonly property bool fullScreenOpen: fullScreenLoader.item !== null
                                          && fullScreenLoader.item.visible
    readonly property bool showXAxisLabels:
        width - 20 - plotLeft - plotRight >= 260
    readonly property real plotLeft: 52
    readonly property real plotRight: 14
    readonly property real plotTop: compactLayout ? 16 : 82
    readonly property real plotBottom: compactLayout
                                           ? (showXAxisLabels
                                              ? (xAxisLabelsWrapped ? 58 : 38)
                                              : 14)
                                           : (xAxisLabelsWrapped ? 64 : 48)

    signal rangeSelected(real minimumX, real maximumX)
    signal rangeReset()
    signal pointModeRequested(bool enabled)
    signal boldPointModeRequested(bool enabled)
    signal exportSucceeded(string outputPath)
    signal exportFailed(string outputPath)

    // 组件内部统一打开全屏窗口
    function openFullScreen() {
        if (!enableWindowActions || !fullScreenEnabled || fullScreenOpen)
            return

        if (!fullScreenLoader.active) {
            fullScreenLoader.active = true
            return
        }

        if (fullScreenLoader.item)
            fullScreenLoader.item.openFullScreen()
    }

    // 组件内部打开图片导出对话框
    function exportImage() {
        if (!enableWindowActions)
            return

        imageExportDialog.open()
    }

    // 在默认抽样和全量绘制之间切换
    function toggleSampleMode() {
        samplePointLimit = samplePointLimit === 0
                           ? AppTheme.waveSamplePointLimit : 0
    }

    // 清除框选状态并请求恢复完整波形数据
    function resetZoom() {
        const rangeWasSelected = zoomed
        zoomed = false
        if (rangeWasSelected)
            rangeReset()
    }

    // 根据共享的框选状态应用或清除纵轴范围
    function synchronizeVerticalZoom() {
        if (zoomed && zoomMaximumY > zoomMinimumY)
            wavePlot.setVerticalRange(zoomMinimumY, zoomMaximumY)
        else if (!zoomed)
            wavePlot.resetVerticalRange()
    }

    // 返回便于坐标和图例显示的短数值
    function formatNumber(value) {
        const number = Number(value)
        if (!isFinite(number))
            return "--"
        const absolute = Math.abs(number)
        if ((absolute > 0 && absolute < 0.001) || absolute >= 1000000)
            return number.toExponential(2)
        return Number(number.toPrecision(5)).toString()
    }

    // 返回保留毫秒精度的绝对秒时间
    function formatAbsoluteSeconds(value) {
        const number = Number(value)
        if (!isFinite(number))
            return "--"
        if (typeof xAxisLabelFormatter === "function")
            return String(xAxisLabelFormatter(number))
        return number.toFixed(3)
    }

    // 根据曲线模型更新框选交互的可用状态
    function updateSeriesCount() {
        seriesCount = seriesModel && seriesModel.rowCount
                      ? seriesModel.rowCount() : 0
    }

    onSeriesModelChanged: {
        updateSeriesCount()
        if (fullScreenLoader.item)
            fullScreenLoader.item.seriesModel = root.seriesModel
    }
    onZoomedChanged: {
        synchronizeVerticalZoom()
        if (fullScreenLoader.item
                && fullScreenLoader.item.zoomed !== root.zoomed)
            fullScreenLoader.item.zoomed = root.zoomed
    }
    onZoomMinimumYChanged: {
        synchronizeVerticalZoom()
        if (fullScreenLoader.item)
            fullScreenLoader.item.zoomMinimumY = root.zoomMinimumY
    }
    onZoomMaximumYChanged: {
        synchronizeVerticalZoom()
        if (fullScreenLoader.item)
            fullScreenLoader.item.zoomMaximumY = root.zoomMaximumY
    }
    onXAxisLabelsWrappedChanged: gridCanvas.requestPaint()
    onXAxisLabelFormatterChanged: {
        if (gridCanvas)
            gridCanvas.requestPaint()
        if (fullScreenLoader.item)
            fullScreenLoader.item.xAxisLabelFormatter = root.xAxisLabelFormatter
    }
    onSamplePointLimitChanged: {
        if (fullScreenLoader.item)
            fullScreenLoader.item.samplePointLimit = root.samplePointLimit
    }
    onPointModeChanged: {
        if (fullScreenLoader.item)
            fullScreenLoader.item.pointMode = root.pointMode
    }
    onBoldPointModeChanged: {
        if (fullScreenLoader.item)
            fullScreenLoader.item.boldPointMode = root.boldPointMode
    }

    color: AppTheme.surface
    border.width: AppTheme.borderWidth
    border.color: AppTheme.borderSoft

    // 动态加载全屏窗口，避免 WaveChart 和 WaveChartDialog 静态互相引用
    Loader {
        id: fullScreenLoader
        active: false
        source: "WaveChartDialog.qml"
        onLoaded: {
            item.seriesModel = root.seriesModel
            item.pointMode = root.pointMode
            item.boldPointMode = root.boldPointMode
            item.samplePointLimit = root.samplePointLimit
            item.xAxisLabelFormatter = root.xAxisLabelFormatter
            item.zoomed = root.zoomed
            item.zoomMinimumY = root.zoomMinimumY
            item.zoomMaximumY = root.zoomMaximumY
            item.openFullScreen()
        }
    }

    // 响应目标对象状态变化
    Connections {
        target: fullScreenLoader.item
        ignoreUnknownSignals: true
        // 转发波形范围选择事件
        function onRangeSelected(minimumX, maximumX) {
            root.rangeSelected(minimumX, maximumX)
        }
        // 转发波形范围重置事件
        function onRangeReset() { root.rangeReset() }
        // 保持主图和全屏图的框选状态一致，使全屏“恢复”按钮可用
        function onZoomedChanged() {
            if (fullScreenLoader.item)
                root.zoomed = fullScreenLoader.item.zoomed
        }
        function onZoomMinimumYChanged() {
            if (fullScreenLoader.item)
                root.zoomMinimumY = fullScreenLoader.item.zoomMinimumY
        }
        function onZoomMaximumYChanged() {
            if (fullScreenLoader.item)
                root.zoomMaximumY = fullScreenLoader.item.zoomMaximumY
        }
        function onSamplePointLimitChanged() {
            if (fullScreenLoader.item)
                root.samplePointLimit = fullScreenLoader.item.samplePointLimit
        }
        function onPointModeChanged() {
            if (fullScreenLoader.item)
                root.pointMode = fullScreenLoader.item.pointMode
        }
        function onBoldPointModeChanged() {
            if (fullScreenLoader.item)
                root.boldPointMode = fullScreenLoader.item.boldPointMode
        }
        // 转发数据点显示模式变化
        function onPointModeRequested(enabled) {
            root.pointMode = enabled
            root.pointModeRequested(enabled)
        }
        // 转发醒目数据点模式变化
        function onBoldPointModeRequested(enabled) {
            root.boldPointMode = enabled
        }
        // 转发图片导出成功结果
        function onExportSucceeded(outputPath) {
            root.exportSucceeded(outputPath)
        }
        // 转发图片导出失败结果
        function onExportFailed(outputPath) {
            root.exportFailed(outputPath)
        }
    }

    // 选择波形图片导出位置
    WaveImageExportDialog {
        id: imageExportDialog
        chart: root
        onExportSucceeded: outputPath => root.exportSucceeded(outputPath)
        onExportFailed: outputPath => root.exportFailed(outputPath)
    }

    // 绘制自定义图形
    Canvas {
        id: gridCanvas
        anchors.fill: parent
        anchors.margins: 10

        // 绘制不包含曲线的坐标网格和刻度文字
        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            const plotWidth = Math.max(1, width - root.plotLeft - root.plotRight)
            const plotHeight = Math.max(1, height - root.plotTop - root.plotBottom)
            const xDivisionCount = plotWidth < 480 ? 3 : plotWidth < 760 ? 4 : 6
            const yDivisionCount = Math.max(2, Math.min(5, Math.floor(plotHeight / 28)))
            ctx.lineWidth = 1
            ctx.strokeStyle = AppTheme.borderSoft
            for (let index = 0; index <= xDivisionCount; ++index) {
                const x = root.plotLeft + index * plotWidth / xDivisionCount
                ctx.beginPath()
                ctx.moveTo(x, root.plotTop)
                ctx.lineTo(x, root.plotTop + plotHeight)
                ctx.stroke()
            }
            for (let index = 0; index <= yDivisionCount; ++index) {
                const y = root.plotTop + index * plotHeight / yDivisionCount
                ctx.beginPath()
                ctx.moveTo(root.plotLeft, y)
                ctx.lineTo(root.plotLeft + plotWidth, y)
                ctx.stroke()
            }
            ctx.fillStyle = AppTheme.muted
            ctx.font = "11px sans-serif"
            ctx.textAlign = "right"
            ctx.textBaseline = "middle"
            for (let index = 0; index <= yDivisionCount; ++index) {
                const value = wavePlot.maximumY
                              - index * (wavePlot.maximumY - wavePlot.minimumY)
                                / yDivisionCount
                ctx.fillText(root.formatNumber(value), root.plotLeft - 7,
                             root.plotTop + index * plotHeight / yDivisionCount)
            }
            if (root.showXAxisLabels) {
                ctx.textBaseline = "top"
                const labels = []
                for (let index = 0; index <= xDivisionCount; ++index) {
                    const seconds = wavePlot.visibleStartX
                                  + index * (wavePlot.visibleEndX
                                             - wavePlot.visibleStartX)
                                    / xDivisionCount
                    const label = root.formatAbsoluteSeconds(seconds)
                    labels.push(label)
                }
                const shouldWrap = labels.some(label => label.indexOf(" ") >= 0)
                if (root.xAxisLabelsWrapped !== shouldWrap)
                    root.xAxisLabelsWrapped = shouldWrap

                for (let index = 0; index <= xDivisionCount; ++index) {
                    ctx.textAlign = index === 0 ? "left"
                                  : index === xDivisionCount ? "right" : "center"
                    const x = root.plotLeft + index * plotWidth / xDivisionCount
                    const label = labels[index]
                    const separator = label.indexOf(" ")
                    if (shouldWrap && separator >= 0) {
                        ctx.fillText(label.substring(0, separator), x,
                                     root.plotTop + plotHeight + 7)
                        ctx.fillText(label.substring(separator + 1), x,
                                     root.plotTop + plotHeight + 20)
                    } else {
                        ctx.fillText(label, x, root.plotTop + plotHeight + 7)
                    }
                }
                ctx.textAlign = "right"
                ctx.fillText("时间 / s", root.plotLeft + plotWidth,
                             root.plotTop + plotHeight + (shouldWrap ? 39 : 25))
            }
        }

        // 响应目标对象状态变化
        Connections {
            target: AppTheme
            // 主题变化后重绘网格
            function onCurrentIndexChanged() { gridCanvas.requestPaint() }
        }
        // 响应目标对象状态变化
        Connections {
            target: wavePlot
            // 波形范围变化后重绘网格
            function onRangeChanged() { gridCanvas.requestPaint() }
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    // 绘制波形曲线和坐标轴
    WavePlotItem {
        id: wavePlot
        anchors.fill: gridCanvas
        seriesModel: root.seriesModel
        plotLeft: root.plotLeft
        plotRight: root.plotRight
        plotTop: root.plotTop
        plotBottom: root.plotBottom
        pointMode: root.pointMode
        boldPointMode: root.boldPointMode
        boldPointSize: root.boldPointSize
        pointBatchSize: root.pointBatchSize
        samplePointLimit: root.samplePointLimit
    }

    // 响应目标对象状态变化
    Connections {
        target: root.seriesModel
        ignoreUnknownSignals: true
        // 插入序列后同步序列数量
        function onRowsInserted() { root.updateSeriesCount() }
        // 删除序列后同步序列数量
        function onRowsRemoved() { root.updateSeriesCount() }
        // 模型重置后同步序列数量
        function onModelReset() { root.updateSeriesCount() }
    }

    // 处理点击交互
    MouseArea {
        id: selectionArea
        x: gridCanvas.x + root.plotLeft
        y: gridCanvas.y + root.plotTop
        width: Math.max(1, gridCanvas.width - root.plotLeft - root.plotRight)
        height: Math.max(1, gridCanvas.height - root.plotTop - root.plotBottom)
        z: 20
        // 迷你波形只用于概览，不提供框选缩放交互
        enabled: root.seriesCount > 0 && !root.compactLayout
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.CrossCursor
        property real pressX: 0
        property real pressY: 0
        property real dragX: 0
        property real dragY: 0

        onPressed: function(mouse) {
            selectionArea.pressX = mouse.x
            selectionArea.pressY = mouse.y
            selectionArea.dragX = mouse.x
            selectionArea.dragY = mouse.y
            selectionBox.visible = true
        }
        onPositionChanged: function(mouse) {
            if (selectionArea.pressed) {
                selectionArea.dragX = Math.max(0, Math.min(selectionArea.width, mouse.x))
                selectionArea.dragY = Math.max(0, Math.min(selectionArea.height, mouse.y))
            }
        }
        onReleased: {
            selectionBox.visible = false
            if (Math.abs(selectionArea.dragX - selectionArea.pressX) < 8
                    || Math.abs(selectionArea.dragY - selectionArea.pressY) < 8)
                return
            const left = Math.min(selectionArea.pressX, selectionArea.dragX)
                         / selectionArea.width
            const right = Math.max(selectionArea.pressX, selectionArea.dragX)
                          / selectionArea.width
            const top = Math.min(selectionArea.pressY, selectionArea.dragY)
                        / selectionArea.height
            const bottom = Math.max(selectionArea.pressY, selectionArea.dragY)
                           / selectionArea.height
            const xRange = wavePlot.visibleEndX - wavePlot.visibleStartX
            const yRange = wavePlot.maximumY - wavePlot.minimumY
            const minimumY = wavePlot.maximumY - bottom * yRange
            const maximumY = wavePlot.maximumY - top * yRange
            // 先固定本地纵轴范围，再通知外部切换数据视图，避免外部模型刷新时
            // 避免先绘制一帧旧比例曲线而产生抖动
            root.zoomMinimumY = minimumY
            root.zoomMaximumY = maximumY
            root.zoomed = true
            root.rangeSelected(wavePlot.visibleStartX + left * xRange,
                               wavePlot.visibleStartX + right * xRange)
        }
        onCanceled: selectionBox.visible = false

        // 绘制波形框选区域
        Rectangle {
            id: selectionBox
            visible: false
            x: Math.min(selectionArea.pressX, selectionArea.dragX)
            y: Math.min(selectionArea.pressY, selectionArea.dragY)
            width: Math.abs(selectionArea.dragX - selectionArea.pressX)
            height: Math.abs(selectionArea.dragY - selectionArea.pressY)
            color: Qt.rgba(AppTheme.accent.r, AppTheme.accent.g, AppTheme.accent.b, 0.18)
            border.color: AppTheme.accent
            border.width: AppTheme.borderWidth
        }
    }

    // 波形操作工具栏在完整和紧凑布局之间自动切换
    WaveChartToolbar {
        z: 30
        anchors.top: parent.top
        anchors.right: parent.right
        compact: root.compactLayout
        showButtons: root.showToolbar
        windowActionsEnabled: root.enableWindowActions
        fullScreenEnabled: root.fullScreenEnabled
        fullScreenOpen: root.fullScreenOpen
        showCompactFullscreenButton: root.showCompactFullscreenButton
        zoomed: root.zoomed
        sampleModeFull: root.samplePointLimit === 0
        pointMode: root.pointMode
        boldPointMode: root.boldPointMode
        onExportRequested: root.exportImage()
        onFullScreenRequested: root.openFullScreen()
        onResetRequested: root.resetZoom()
        onSampleModeToggleRequested: root.toggleSampleMode()
        onPointModeToggleRequested: {
            root.pointMode = !root.pointMode
            if (!root.pointMode)
                root.boldPointMode = false
            root.pointModeRequested(root.pointMode)
        }
        onBoldPointModeToggleRequested: root.boldPointMode = !root.boldPointMode
    }

    // 曲线名称和数值范围图例
    WaveChartLegend {
        anchors.fill: parent
        seriesModel: root.seriesModel
        showLegend: root.showLegend
        compact: root.compactLayout
        seriesCount: root.seriesCount
        rightReserved: root.showToolbar ? 184 : 14
        numberFormatter: function(value) { return root.formatNumber(value) }
    }
}
