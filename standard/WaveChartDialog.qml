// 本文件提供可独立放大的波形图窗口
import QtQuick

// 提供可独立放大的波形图窗口
Window {
    id: root

    property alias seriesModel: fullScreenChart.seriesModel
    property alias pointMode: fullScreenChart.pointMode
    property alias boldPointMode: fullScreenChart.boldPointMode
    property alias samplePointLimit: fullScreenChart.samplePointLimit
    property alias xAxisLabelFormatter: fullScreenChart.xAxisLabelFormatter
    property alias zoomed: fullScreenChart.zoomed
    property alias zoomMinimumY: fullScreenChart.zoomMinimumY
    property alias zoomMaximumY: fullScreenChart.zoomMaximumY

    signal rangeSelected(real minimumX, real maximumX)
    signal rangeReset()
    signal pointModeRequested(bool enabled)
    signal boldPointModeRequested(bool enabled)
    signal exportSucceeded(string outputPath)
    signal exportFailed(string outputPath)

    title: "波形图"
    flags: Qt.Window
    modality: Qt.NonModal
    width: 1100
    height: 720
    minimumWidth: 720
    minimumHeight: 480
    color: AppTheme.workbench

    // 以独立窗口全屏显示波形
    function openFullScreen() {
        showFullScreen()
        raise()
        requestActivate()
    }

    // 大窗口中的波形图复用原始曲线模型
    WaveChart {
        id: fullScreenChart
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.bottomMargin: 12
        anchors.topMargin: 56
        boldPointSize: AppTheme.waveBoldPointSize
        pointBatchSize: AppTheme.wavePointBatchSize
        showToolbar: true
        enableWindowActions: true
        fullScreenEnabled: false
        forceCompactLayout: false
        onRangeSelected: (minimumX, maximumX) =>
            root.rangeSelected(minimumX, maximumX)
        onRangeReset: root.rangeReset()
        onPointModeRequested: enabled => root.pointModeRequested(enabled)
        onBoldPointModeRequested: enabled => root.boldPointModeRequested(enabled)
        onExportSucceeded: outputPath => root.exportSucceeded(outputPath)
        onExportFailed: outputPath => root.exportFailed(outputPath)
    }

    // 右上角关闭按钮，避免占用波形底部空间
    AppButton {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 12
        anchors.rightMargin: 12
        width: 58
        text: "关闭"
        z: 20
        onClicked: root.close()
    }
}
