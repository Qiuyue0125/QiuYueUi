# QiuYueUi

基于 Qt Quick / QML 的界面组件库，包含统一主题、基础控件、窗口与导航、表格分页、通知以及波形图组件。

## 目录

- `standard/`：QML 界面组件。
- `theme/AppTheme.qml`：主题颜色、尺寸、字体和动效配置。
- `utils/`：日期时间、分析和路径转换工具。
- `qmldir`：`QiuYueUi 1.0` 模块声明。

## 接入

1. 使用 Qt 6，并安装 Qt Quick、Qt Quick Controls、Qt Quick Layouts 等模块。部分组件还依赖 Qt Quick Effects、Qt Quick Dialogs 和 Qt Core；使用 Qt Quick Effects 时需要 Qt 6.5 或更新版本。
2. 将本仓库放在名为 `QiuYueUi` 的目录中，将其父目录加入应用的 QML import path。
3. 在宿主应用中提供名为 `AppTheme` 的主题对象。当前 `qmldir` 不注册主题单例；Python 应用可提供 QML 上下文属性，C++ 应用可注册 QML 单例。可参考 `theme/AppTheme.qml` 中的主题接口。
4. 在 QML 中导入组件：

```qml
import QtQuick
import QiuYueUi 1.0

AppButton {
    text: "确定"
}
```

本仓库是组件库，未包含可直接运行的应用入口。窗口、图表等组件的业务数据和宿主交互需要由接入应用配置。

## 组件概览

- 基础控件：AppButton、IconButton、StyledTextField、StyledComboBox、StyledSpinBox、StyledSwitch、StyledCheckBox。
- 窗口与布局：FramelessWindow、AppTitleBar、AppDialog、AppPopup、DraggableSidebar、FormRow。
- 导航：NavigationRail、NavigationButton、SegmentedTabBar、ModuleTabStrip。
- 表格：EditorTable、PagedTable、PaginationBar、SortableTableHeader。
- 通知：NotificationCenter、NotificationToast、ThemedToolTip。
- 波形图：WaveChart、WaveChartDialog、WaveChartLegend、WaveChartToolbar、WaveImageExportDialog。

完整导出列表见 `qmldir`。
