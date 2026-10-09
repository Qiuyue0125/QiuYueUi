// 本文件定义可复用的主题化启动窗口
import QtQuick
import QtQuick.Controls
import QtQuick.Window

// 定义可复用的主题化启动窗口
Window {
    id: root

    property string applicationName: "Application"
    property string loadingText: "正在加载"
    property url iconSource: ""
    // 保存启动窗口初始主题标识
    property string initialThemeName: ""
    property bool closing: false

    width: 420
    height: 220
    x: Math.round((Screen.width - width) / 2)
    y: Math.round((Screen.height - height) / 2)
    visible: true
    flags: Qt.SplashScreen | Qt.FramelessWindowHint
    color: "transparent"
    title: applicationName

    // 窗口创建完成后应用主题并请求激活
    Component.onCompleted: {
        AppTheme.applyName(root.initialThemeName)
        root.raise()
        root.requestActivate()
    }

    // 播放退出动画并关闭启动窗口
    function dismiss() {
        if (!closing) {
            closing = true
            if (AppTheme.animationsEnabled)
                exitAnimation.start()
            else
                root.close()
        }
    }

    // 绘制启动窗口面板
    Rectangle {
        id: panel
        anchors.fill: parent
        color: AppTheme.surface
        border.color: AppTheme.accent
        border.width: AppTheme.borderWidth
        radius: AppTheme.windowRadius
        opacity: AppTheme.animationsEnabled ? 0 : 1

        // 平滑更新透明度
        OpacityAnimator {
            target: panel
            from: 0
            to: 1
            duration: AppTheme.effectiveAnimationDuration(
                          AppTheme.splashEnterDuration)
            easing.type: AppTheme.enterEasing
            running: AppTheme.animationsEnabled
        }

        // 平滑更新透明度
        OpacityAnimator {
            id: exitAnimation
            target: panel
            from: 1
            to: 0
            duration: AppTheme.effectiveAnimationDuration(
                          AppTheme.windowExitDuration)
            easing.type: AppTheme.windowExitEasing
            onStopped: root.close()
        }

        // 纵向排列
        Column {
            anchors.centerIn: parent
            spacing: 20

            // 横向排列
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: AppTheme.spacing2xl
                // 显示界面图像
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 42
                    height: 42
                    visible: root.iconSource.toString().length > 0
                    source: root.iconSource
                    fillMode: Image.PreserveAspectFit
                }

                // 显示应用名称
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.applicationName
                    color: AppTheme.text
                    font.pixelSize: 23
                    font.bold: true
                }
            }

            // 承载启动加载图形
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 48
                height: 48

                // 绘制自定义图形
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        const context = getContext("2d")
                        context.clearRect(0, 0, width, height)
                        context.strokeStyle = AppTheme.accent
                        context.lineWidth = 5
                        context.lineCap = "round"
                        context.beginPath()
                        context.arc(width / 2, height / 2, 16,
                                    -Math.PI * 0.35, Math.PI * 0.95)
                        context.stroke()
                    }

                    RotationAnimator on rotation {
                        from: 0
                        to: 360
                        duration: AppTheme.activityIndicatorDuration
                        loops: Animation.Infinite
                        running: root.visible && AppTheme.animationsEnabled
                    }
                }
            }

            // 显示当前加载状态
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.loadingText
                color: AppTheme.muted
                font.pixelSize: AppTheme.fontBodyLarge
            }
        }
    }
}
