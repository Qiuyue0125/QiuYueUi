// 本文件提供波形组件通用的图片导出对话框
import QtQuick
import QtCore
import QtQuick.Dialogs
import "../utils/AnalysisUtils.js" as AnalysisUtils

// 提供波形组件通用的图片导出对话框
FileDialog {
    id: root

    // 截取的可视波形组件，导出时保持其当前宽高比
    required property Item chart

    signal exportSucceeded(string outputPath)
    signal exportFailed(string outputPath)

    // 以波形所在窗口作为原生对话框父窗口，使系统文件对话框居中显示
    parentWindow: chart.Window.window
    title: "导出波形图片"
    fileMode: FileDialog.SaveFile
    nameFilters: ["PNG 图片 (*.png)"]
    defaultSuffix: "png"
    // 使用绝对文件 URL 预填充目录和默认文件名以避免相对路径校验警告
    currentFile: AnalysisUtils.localPathUrl(
                     StandardPaths.writableLocation(StandardPaths.PicturesLocation)
                     + "/waveform.png")

    onAccepted: {
        const outputPath = AnalysisUtils.localFilePath(selectedFile)
        const exportWidth = 2400
        const exportHeight = Math.round(exportWidth * root.chart.height
                                        / root.chart.width)
        root.chart.grabToImage(function(result) {
            if (result.saveToFile(outputPath))
                root.exportSucceeded(outputPath)
            else
                root.exportFailed(outputPath)
        }, Qt.size(exportWidth, exportHeight))
    }
}
