// 本文件定义可复用的主题化横向和纵向分割线
import QtQuick

// 定义可复用的主题化横向和纵向分割线
Rectangle {
    // 设为 true 时绘制纵向分割线
    property bool vertical: false
    property int thickness: AppTheme.dividerThickness

    implicitWidth: vertical ? thickness : 0
    implicitHeight: vertical ? 0 : thickness
    color: AppTheme.borderSoft
}
