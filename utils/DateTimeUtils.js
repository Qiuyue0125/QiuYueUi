// 本文件提供日期时间输入的解析补位和月份切换工具函数
.pragma library

// 将数值补齐为两位文字
function twoDigits(value) {
    return value < 10 ? "0" + value : value.toString()
}

// 解析 yyyy-MM-dd 文本，无效时返回 null
function parseDateText(text) {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(text))
        return null
    const parts = text.split("-")
    return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]))
}

// 解析 HH:mm:ss 文本为时分秒数组，无效时使用备用文本
function parseTimeParts(text, fallbackText) {
    const value = /^\d{2}:\d{2}:\d{2}$/.test(text) ? text : fallbackText
    const parts = value.split(":")
    return parts.length === 3
        ? [Number(parts[0]), Number(parts[1]), Number(parts[2])]
        : [0, 0, 0]
}

// 将日期钳制到指定年月内的有效日期
function clampDay(year, month, day) {
    const lastDay = new Date(year, month, 0).getDate()
    return Math.min(day, lastDay)
}

// 按偏移量切换显示月份
function shiftMonth(year, month, offset) {
    const next = new Date(year, month + offset, 1)
    return { year: next.getFullYear(), month: next.getMonth() }
}
