import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Rectangle {
    id: iviScreen
    anchors.fill: parent
    color: "#000000"
    focus: true

    // ===== PROPERTIES =====
    property real speed: 0
    property real fuel: 68  // ✅ THAY ĐỔI: battery -> fuel
    property real tirePressureFL: 2.4
    property real tirePressureFR: 2.4
    property real tirePressureRL: 2.5
    property real tirePressureRR: 2.5
    property bool slipperyRoadWarning: false
    property bool tirePressureWarning: false

    // Settings
    property bool isDarkMode: true
    property string language: "en" // "en" or "vi"

    // Boot animation
    property bool systemBooted: false
    property int bootProgress: 0

    signal closeIVI()

    // Translation function
    function t(key) {
        var translations = {
            "en": {
                "system_check": "SYSTEM CHECK",
                "boot_complete": "BOOT COMPLETE",
                "front_left": "FRONT LEFT",
                "front_right": "FRONT RIGHT",
                "rear_left": "REAR LEFT",
                "rear_right": "REAR RIGHT",
                "bar": "bar",
                "road_condition": "ROAD CONDITION",
                "optimal": "OPTIMAL",
                "slippery": "SLIPPERY - DRIVE CAREFULLY",
                "tire_pressure": "TIRE PRESSURE MONITORING",
                "all_normal": "All tires normal",
                "low_pressure": "Low pressure detected",
                "language": "LANGUAGE",
                "english": "English",
                "vietnamese": "Tiếng Việt",
                "theme": "THEME",
                "dark_mode": "Dark Mode",
                "light_mode": "Light Mode",
                "safety": "SAFETY MONITORING",
                "settings": "SETTINGS",
                "fuel": "FUEL"  // ✅ THÊM
            },
            "vi": {
                "system_check": "KIỂM TRA HỆ THỐNG",
                "boot_complete": "KHỞI ĐỘNG HOÀN TẤT",
                "front_left": "TRƯỚC TRÁI",
                "front_right": "TRƯỚC PHẢI",
                "rear_left": "SAU TRÁI",
                "rear_right": "SAU PHẢI",
                "bar": "bar",
                "road_condition": "TÌNH TRẠNG ĐƯỜNG",
                "optimal": "TỐI ƯU",
                "slippery": "TRƠN TRƯỢT - LÁI CẨN THẬN",
                "tire_pressure": "GIÁM SÁT ÁP SUẤT LỐP",
                "all_normal": "Tất cả lốp bình thường",
                "low_pressure": "Phát hiện áp suất thấp",
                "language": "NGÔN NGỮ",
                "english": "English",
                "vietnamese": "Tiếng Việt",
                "theme": "GIAO DIỆN",
                "dark_mode": "Chế độ tối",
                "light_mode": "Chế độ sáng",
                "safety": "GIÁM SÁT AN TOÀN",
                "settings": "CÀI ĐẶT",
                "fuel": "XĂNG"  // ✅ THÊM
            }
        }
        return translations[language][key] || key
    }

    // ===== BACKGROUND =====
    Rectangle {
        anchors.fill: parent
        color: isDarkMode ? "#0a0a0a" : "#f5f5f5"
    }

    Image {
        anchors.fill: parent
        source: "qrc:/assets/background.png"
        fillMode: Image.PreserveAspectCrop
        opacity: isDarkMode ? 0.15 : 0.05
    }

    // ===== BOOT ANIMATION =====
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        visible: !systemBooted
        z: 1000

        Column {
            anchors.centerIn: parent
            spacing: 40

            Text {
                text: "⚡"
                font.pixelSize: 80
                color: "#00FFFF"
                anchors.horizontalCenter: parent.horizontalCenter

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }

            Column {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: t("system_check")
                    font.pixelSize: 24
                    font.bold: true
                    color: "#00FFFF"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                }

                Rectangle {
                    width: 400
                    height: 12
                    radius: 6
                    color: "#222222"
                    border.color: "#00FFFF"
                    border.width: 1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: parent.width * (bootProgress / 100)
                        height: parent.height
                        radius: 6
                        color: "#00FFFF"

                        Behavior on width {
                            NumberAnimation { duration: 50 }
                        }
                    }
                }

                Text {
                    text: bootProgress + "%"
                    font.pixelSize: 18
                    color: "#888888"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                }
            }
        }
    }

    // ===== MAIN CONTENT =====
    Item {
        anchors.fill: parent
        visible: systemBooted

        // ===== KEYBOARD SHORTCUTS HELP =====
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 20
            width: 280
            height: showHelp ? 380 : 50
            radius: 10
            color: isDarkMode ? "#1a1a1aCC" : "#ffffffCC"
            border.color: isDarkMode ? "#00FFFF" : "#0066ff"
            border.width: 2
            z: 999

            property bool showHelp: false

            Behavior on height {
                NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
            }

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "⌨️"
                        font.pixelSize: 20
                    }

                    Text {
                        text: "SHORTCUTS"
                        font.pixelSize: 16
                        font.bold: true
                        color: isDarkMode ? "#00FFFF" : "#0066ff"
                        font.family: "Arial"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item { Layout.fillWidth: true; width: 50 }

                    Text {
                        text: parent.parent.parent.showHelp ? "▼" : "▶"
                        font.pixelSize: 16
                        color: isDarkMode ? "#00FFFF" : "#0066ff"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: isDarkMode ? "#333333" : "#cccccc"
                    visible: parent.parent.showHelp
                }

                Column {
                    width: parent.width
                    spacing: 8
                    visible: parent.parent.showHelp

                    ShortcutItem { key: "ESC"; desc: "Close IVI" }
                    ShortcutItem { key: "D"; desc: "Toggle Dark/Light" }
                    ShortcutItem { key: "L"; desc: "Toggle EN/VI" }
                    ShortcutItem { key: "W"; desc: "Toggle Road Warning" }
                    ShortcutItem { key: "T"; desc: "Test Random Tire" }
                    ShortcutItem { key: "R"; desc: "Reset All Tires" }
                    ShortcutItem { key: "1-4"; desc: "Test Tire (FL/FR/RL/RR)" }
                    ShortcutItem { key: "F"; desc: "Decrease Fuel" }
                    ShortcutItem { key: "G"; desc: "Increase Fuel" }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.showHelp = !parent.showHelp
                cursorShape: Qt.PointingHandCursor
            }
        }

        component ShortcutItem: Row {
            property string key: ""
            property string desc: ""
            spacing: 10

            Rectangle {
                width: 50
                height: 24
                radius: 4
                color: isDarkMode ? "#2a2a2a" : "#e0e0e0"
                border.color: isDarkMode ? "#00FFFF" : "#0066ff"
                border.width: 1

                Text {
                    text: key
                    font.pixelSize: 12
                    font.bold: true
                    color: isDarkMode ? "#00FFFF" : "#0066ff"
                    anchors.centerIn: parent
                    font.family: "Courier"
                }
            }

            Text {
                text: desc
                font.pixelSize: 12
                color: isDarkMode ? "#CCCCCC" : "#666666"
                anchors.verticalCenter: parent.verticalCenter
                font.family: "Arial"
            }
        }

        // ===== HEADER =====
        Rectangle {
            id: header
            width: parent.width
            height: 100
            color: isDarkMode ? "#1a1a1a" : "#ffffff"
            border.color: isDarkMode ? "#333333" : "#cccccc"
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: "IVI SYSTEM"
                        font.pixelSize: 24
                        font.bold: true
                        color: isDarkMode ? "#00FFFF" : "#0066ff"
                        font.family: "Arial"
                    }

                    Text {
                        text: "In-Vehicle Infotainment"
                        font.pixelSize: 12
                        color: isDarkMode ? "#888888" : "#666666"
                        font.family: "Arial"
                    }
                }
            }

            Row {
                anchors.centerIn: parent
                spacing: 15

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: "#00FF99"
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 1000 }
                        NumberAnimation { to: 1.0; duration: 1000 }
                    }
                }

                Text {
                    id: timeLabel
                    text: Qt.formatDateTime(new Date(), "HH:mm")
                    font.pixelSize: 32
                    font.bold: true
                    color: isDarkMode ? "white" : "#333333"
                    font.family: "Arial"
                }
            }

            Rectangle {
                width: 60
                height: 60
                radius: 30
                color: isDarkMode ? "#2a2a2a" : "#e0e0e0"
                border.color: isDarkMode ? "#00FFFF" : "#0066ff"
                border.width: 2
                anchors.right: parent.right
                anchors.rightMargin: 40
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "✕"
                    font.pixelSize: 28
                    font.bold: true
                    color: isDarkMode ? "white" : "#333333"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: iviScreen.closeIVI()
                    cursorShape: Qt.PointingHandCursor
                }

                scale: closeMouse.containsMouse ? 1.1 : 1.0
                Behavior on scale { NumberAnimation { duration: 200 } }
                HoverHandler { id: closeMouse }
            }
        }

        // ===== MAIN LAYOUT =====
        Row {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 0

            // ===== LEFT PANEL - SETTINGS =====
            Rectangle {
                id: leftPanel
                width: parent.width * 0.25
                height: parent.height
                color: isDarkMode ? "#0f0f0f" : "#fafafa"
                border.color: isDarkMode ? "#333333" : "#cccccc"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 30

                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            text: "⚙️"
                            font.pixelSize: 24
                        }

                        Text {
                            text: t("settings")
                            font.pixelSize: 20
                            font.bold: true
                            color: isDarkMode ? "#00FFFF" : "#0066ff"
                            font.family: "Arial"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: isDarkMode ? "#333333" : "#cccccc"
                    }

                    // Language Setting
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: t("language")
                            font.pixelSize: 14
                            font.bold: true
                            color: isDarkMode ? "#888888" : "#666666"
                            font.family: "Arial"
                        }

                        Rectangle {
                            width: parent.width
                            height: 60
                            radius: 8
                            color: language === "en" ? (isDarkMode ? "#00FFFF33" : "#0066ff33") : (isDarkMode ? "#2a2a2a" : "#e0e0e0")
                            border.color: language === "en" ? (isDarkMode ? "#00FFFF" : "#0066ff") : "transparent"
                            border.width: 2

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: "🇬🇧"
                                    font.pixelSize: 24
                                }

                                Text {
                                    text: t("english")
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: language === "en" ? (isDarkMode ? "#00FFFF" : "#0066ff") : (isDarkMode ? "#666666" : "#999999")
                                    font.family: "Arial"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: language = "en"
                                cursorShape: Qt.PointingHandCursor
                            }

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        Rectangle {
                            width: parent.width
                            height: 60
                            radius: 8
                            color: language === "vi" ? (isDarkMode ? "#00FFFF33" : "#0066ff33") : (isDarkMode ? "#2a2a2a" : "#e0e0e0")
                            border.color: language === "vi" ? (isDarkMode ? "#00FFFF" : "#0066ff") : "transparent"
                            border.width: 2

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: "🇻🇳"
                                    font.pixelSize: 24
                                }

                                Text {
                                    text: t("vietnamese")
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: language === "vi" ? (isDarkMode ? "#00FFFF" : "#0066ff") : (isDarkMode ? "#666666" : "#999999")
                                    font.family: "Arial"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: language = "vi"
                                cursorShape: Qt.PointingHandCursor
                            }

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: isDarkMode ? "#333333" : "#cccccc"
                    }

                    // Theme Setting
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: t("theme")
                            font.pixelSize: 14
                            font.bold: true
                            color: isDarkMode ? "#888888" : "#666666"
                            font.family: "Arial"
                        }

                        Rectangle {
                            width: parent.width
                            height: 60
                            radius: 8
                            color: isDarkMode ? (isDarkMode ? "#00FFFF33" : "#0066ff33") : (isDarkMode ? "#2a2a2a" : "#e0e0e0")
                            border.color: isDarkMode ? (isDarkMode ? "#00FFFF" : "#0066ff") : "transparent"
                            border.width: 2

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: "🌙"
                                    font.pixelSize: 24
                                }

                                Text {
                                    text: t("dark_mode")
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: isDarkMode ? (isDarkMode ? "#00FFFF" : "#0066ff") : (isDarkMode ? "#666666" : "#999999")
                                    font.family: "Arial"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: isDarkMode = true
                                cursorShape: Qt.PointingHandCursor
                            }

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        Rectangle {
                            width: parent.width
                            height: 60
                            radius: 8
                            color: !isDarkMode ? (isDarkMode ? "#00FFFF33" : "#0066ff33") : (isDarkMode ? "#2a2a2a" : "#e0e0e0")
                            border.color: !isDarkMode ? (isDarkMode ? "#00FFFF" : "#0066ff") : "transparent"
                            border.width: 2

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: "☀️"
                                    font.pixelSize: 24
                                }

                                Text {
                                    text: t("light_mode")
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: !isDarkMode ? (isDarkMode ? "#00FFFF" : "#0066ff") : (isDarkMode ? "#666666" : "#999999")
                                    font.family: "Arial"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: isDarkMode = false
                                cursorShape: Qt.PointingHandCursor
                            }

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }
            }

            // ===== CENTER PANEL - VEHICLE INFO =====
            Rectangle {
                id: centerPanel
                width: parent.width * 0.5
                height: parent.height
                color: isDarkMode ? "#000000" : "#ffffff"

                Column {
                    anchors.centerIn: parent
                    spacing: 40

                    // Vehicle Image
                    Image {
                        source: "qrc:/assets/Car.svg"
                        width: 300
                        height: 400
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // Speed and Fuel (✅ THAY ĐỔI)
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 80

                        Column {
                            spacing: 5

                            Text {
                                text: Math.round(speed)
                                font.pixelSize: 64
                                font.bold: true
                                color: isDarkMode ? "#00FFFF" : "#0066ff"
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: "Arial"
                            }

                            Text {
                                text: "KM/H"
                                font.pixelSize: 18
                                color: isDarkMode ? "#888888" : "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: "Arial"
                            }
                        }

                        Rectangle {
                            width: 2
                            height: 80
                            color: isDarkMode ? "#333333" : "#cccccc"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            spacing: 5

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                Text {
                                    text: "⛽"
                                    font.pixelSize: 48
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: Math.round(fuel) + "%"
                                    font.pixelSize: 64
                                    font.bold: true
                                    color: fuel < 20 ? "#FF3333" : (isDarkMode ? "#00FF99" : "#00AA44")
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.family: "Arial"
                                }
                            }

                            Text {
                                text: t("fuel")
                                font.pixelSize: 18
                                color: isDarkMode ? "#888888" : "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: "Arial"
                            }
                        }
                    }
                }
            }

            // ===== RIGHT PANEL - SAFETY =====
            Rectangle {
                id: rightPanel
                width: parent.width * 0.25
                height: parent.height
                color: isDarkMode ? "#0f0f0f" : "#fafafa"
                border.color: isDarkMode ? "#333333" : "#cccccc"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 30

                    Text {
                        text: t("safety")
                        font.pixelSize: 20
                        font.bold: true
                        color: isDarkMode ? "#00FFFF" : "#0066ff"
                        font.family: "Arial"
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: isDarkMode ? "#333333" : "#cccccc"
                    }

                    // Road Condition
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: t("road_condition")
                            font.pixelSize: 14
                            font.bold: true
                            color: isDarkMode ? "#888888" : "#666666"
                            font.family: "Arial"
                        }

                        Rectangle {
                            width: parent.width
                            height: 120
                            radius: 12
                            color: slipperyRoadWarning ? "#FF660033" : (isDarkMode ? "#00FF9933" : "#00AA4433")
                            border.color: slipperyRoadWarning ? "#FF6600" : (isDarkMode ? "#00FF99" : "#00AA44")
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: slipperyRoadWarning ? "⚠️" : "✅"
                                    font.pixelSize: 48
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: slipperyRoadWarning ? t("slippery") : t("optimal")
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: slipperyRoadWarning ? "#FF6600" : (isDarkMode ? "#00FF99" : "#00AA44")
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.family: "Arial"
                                    horizontalAlignment: Text.AlignHCenter
                                    width: parent.parent.width - 20
                                    wrapMode: Text.WordWrap
                                }
                            }

                            SequentialAnimation on opacity {
                                running: slipperyRoadWarning
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.6; duration: 800 }
                                NumberAnimation { to: 1.0; duration: 800 }
                            }

                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }

                            Behavior on border.color {
                                ColorAnimation { duration: 300 }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: isDarkMode ? "#333333" : "#cccccc"
                    }

                    // Tire Pressure
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: t("tire_pressure")
                            font.pixelSize: 14
                            font.bold: true
                            color: isDarkMode ? "#888888" : "#666666"
                            font.family: "Arial"
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        Rectangle {
                            width: parent.width
                            height: 60
                            radius: 8
                            color: tirePressureWarning ? "#FF333333" : (isDarkMode ? "#2a2a2a" : "#e0e0e0")
                            border.color: tirePressureWarning ? "#FF3333" : (isDarkMode ? "#444444" : "#cccccc")
                            border.width: 1

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: tirePressureWarning ? "⚠️" : "✅"
                                    font.pixelSize: 28
                                }

                                Text {
                                    text: tirePressureWarning ? t("low_pressure") : t("all_normal")
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: tirePressureWarning ? "#FF3333" : (isDarkMode ? "#00FF99" : "#00AA44")
                                    font.family: "Arial"
                                }
                            }

                            SequentialAnimation on opacity {
                                running: tirePressureWarning
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.6; duration: 500 }
                                NumberAnimation { to: 1.0; duration: 500 }
                            }
                        }

                        // Tire Pressure Details
                        Grid {
                            width: parent.width
                            columns: 2
                            spacing: 10

                            TirePressureIndicator {
                                label: t("front_left")
                                pressure: tirePressureFL
                                isLowPressure: tirePressureFL < 2.2
                            }

                            TirePressureIndicator {
                                label: t("front_right")
                                pressure: tirePressureFR
                                isLowPressure: tirePressureFR < 2.2
                            }

                            TirePressureIndicator {
                                label: t("rear_left")
                                pressure: tirePressureRL
                                isLowPressure: tirePressureRL < 2.2
                            }

                            TirePressureIndicator {
                                label: t("rear_right")
                                pressure: tirePressureRR
                                isLowPressure: tirePressureRR < 2.2
                            }
                        }
                    }
                }
            }
        }
    }

    // ===== TIRE PRESSURE INDICATOR COMPONENT =====
    component TirePressureIndicator: Item {
        property string label: ""
        property real pressure: 2.4
        property bool isLowPressure: pressure < 2.2

        width: 130
        height: 70

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: isLowPressure ? "#FF333333" : (isDarkMode ? "#2a2a2a" : "#e0e0e0")
            border.color: isLowPressure ? "#FF6666" : (isDarkMode ? "#00FFFF" : "#0066ff")
            border.width: 2

            Behavior on color {
                ColorAnimation { duration: 300 }
            }

            SequentialAnimation on opacity {
                running: isLowPressure
                loops: Animation.Infinite
                NumberAnimation { to: 0.6; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }

            Column {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    text: label
                    font.pixelSize: 10
                    color: isDarkMode ? "#888888" : "#666666"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                }

                Text {
                    text: pressure.toFixed(1) + " " + t("bar")
                    font.pixelSize: 16
                    font.bold: true
                    color: isLowPressure ? "#FFFFFF" : (isDarkMode ? "#00FFFF" : "#0066ff")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                }
            }

            // Warning indicator for low pressure
            Text {
                text: "⚠️"
                font.pixelSize: 18
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 5
                opacity: isLowPressure ? 1.0 : 0.0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }
    }

    // ===== BOOT ANIMATION TIMER =====
    Timer {
        id: bootTimer
        interval: 50
        running: !systemBooted
        repeat: true
        onTriggered: {
            if (bootProgress < 100) {
                bootProgress += 2
            } else {
                systemBooted = true
                bootTimer.stop()
            }
        }
    }

    // ===== TIME UPDATE TIMER =====
    Timer {
        interval: 1000
        running: systemBooted
        repeat: true
        onTriggered: {
            timeLabel.text = Qt.formatDateTime(new Date(), "HH:mm")
        }
    }

    // ===== AUTOMATIC TIRE PRESSURE WARNING =====
    onTirePressureFLChanged: checkTirePressure()
    onTirePressureFRChanged: checkTirePressure()
    onTirePressureRLChanged: checkTirePressure()
    onTirePressureRRChanged: checkTirePressure()

    function checkTirePressure() {
        tirePressureWarning = (tirePressureFL < 2.2 || tirePressureFR < 2.2 ||
                               tirePressureRL < 2.2 || tirePressureRR < 2.2)
    }

    // ===== KEYBOARD SHORTCUTS =====
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            iviScreen.closeIVI()
        } else if (event.key === Qt.Key_D) {
            isDarkMode = !isDarkMode
        } else if (event.key === Qt.Key_L) {
            language = (language === "en") ? "vi" : "en"
        } else if (event.key === Qt.Key_W) {
            slipperyRoadWarning = !slipperyRoadWarning
        } else if (event.key === Qt.Key_T) {
            // Test áp suất lốp - giảm ngẫu nhiên 1 lốp
            var randomTire = Math.floor(Math.random() * 4)
            if (randomTire === 0) tirePressureFL = tirePressureFL > 2.0 ? 2.0 : 2.5
            else if (randomTire === 1) tirePressureFR = tirePressureFR > 2.0 ? 2.0 : 2.5
            else if (randomTire === 2) tirePressureRL = tirePressureRL > 2.0 ? 2.0 : 2.5
            else tirePressureRR = tirePressureRR > 2.0 ? 2.0 : 2.5
        } else if (event.key === Qt.Key_R) {
            // Reset tất cả áp suất lốp về bình thường
            tirePressureFL = 2.4
            tirePressureFR = 2.4
            tirePressureRL = 2.5
            tirePressureRR = 2.5
        } else if (event.key === Qt.Key_1) {
            // Test lốp trước trái
            tirePressureFL = tirePressureFL > 2.0 ? 2.0 : 2.5
        } else if (event.key === Qt.Key_2) {
            // Test lốp trước phải
            tirePressureFR = tirePressureFR > 2.0 ? 2.0 : 2.5
        } else if (event.key === Qt.Key_3) {
            // Test lốp sau trái
            tirePressureRL = tirePressureRL > 2.0 ? 2.0 : 2.5
        } else if (event.key === Qt.Key_4) {
            // Test lốp sau phải
            tirePressureRR = tirePressureRR > 2.0 ? 2.0 : 2.5
        } else if (event.key === Qt.Key_F) {
            // Giảm xăng
            fuel = Math.max(0, fuel - 10)
        } else if (event.key === Qt.Key_G) {
            // Tăng xăng
            fuel = Math.min(100, fuel + 10)
        }
    }

    // ===== SMOOTH TRANSITIONS =====
    Behavior on opacity {
        NumberAnimation { duration: 500 }
    }
}
