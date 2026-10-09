// 本文件提供时间和本地文件 URL 转换工具函数
.pragma library

// 把 Unix 时间戳微秒转换成可读时间
function formatTimestamp(timestampUs) {
    return Qt.formatDateTime(new Date(Math.floor(Number(timestampUs) / 1000)),
                             "yyyy-MM-dd hh:mm:ss.zzz")
}

// 把 file:// 格式的 URL 转成本地文件路径
function localFilePath(fileUrl) {
    const value = fileUrl.toString()
    if (!value.startsWith("file://"))
        return decodeURIComponent(value)

    let path = decodeURIComponent(value.substring(7))
    if (Qt.platform.os !== "windows")
        return path
    if (/^\/[A-Za-z]:/.test(path))
        return path.substring(1)
    return path.startsWith("/") ? path : "//" + path
}

// 把本地文件路径转换成 file:// URL
function localPathUrl(path) {
    const normalized = path.replace(/\\/g, "/")
    const encoded = encodeURI(normalized)
            .replace(/#/g, "%23")
            .replace(/\?/g, "%3F")
    if (normalized.startsWith("//"))
        return "file:" + encoded
    return normalized.startsWith("/") ? "file://" + encoded : "file:///" + encoded
}
