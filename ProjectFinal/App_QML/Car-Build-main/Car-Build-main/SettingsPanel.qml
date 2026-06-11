import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Particles 2.0

Rectangle {
    id: settingsPanel
    width: 1920
    height: 720
    color: "#050505"
    focus: true
    clip: true

    // ==========================================================
    // 🧠 1. CENTRAL DATA HUB (CORE LOGIC)
    // ==========================================================

    // --- System State & Theme ---
    property bool isDarkTheme: true
    property string currentLanguage: "EN"
    property color accentColor: "#00FF99"
    property int currentTab: 0 // 0:Vehicle, 1:Climate, 2:ADAS, 3:System

    // --- Live Telemetry (Inputs) ---
    property real engineTemp: 75.0
    property real currentBattery: 68.0
    property real currentSpeed: 0
    // [FIX] Property này tự tạo signal driveModeChanged, nên ta không được khai báo signal trùng tên
    property string driveMode: "Normal"
    property bool isCharging: false

    // --- Safety & Inputs ---
    property bool leftSignal: false
    property bool rightSignal: false
    property bool signalBlinkState: false
    property bool doorOpenFL: false
    property bool doorOpenFR: false
    property bool doorOpenRL: false
    property bool doorOpenRR: false

    // --- Simulation States ---
    property bool roadSlippery: false
    property bool roadWet: false
    property bool roadIcy: false

    // --- HVAC State ---
    property bool acActive: false
    property int fanSpeed: 2
    property real cabinTemp: 22.5

    // --- Media State ---
    property bool isMediaPlaying: false
    property string mediaTrack: "Neon Nights"
    property string mediaArtist: "Cyberpunk Orchestra"
    property real mediaProgress: 0.3

    // --- Output Signals (To Main Window) ---
    signal closeSettings()
    signal themeChanged(bool isDark)
    signal languageChanged(string lang)
    // [FIXED] Đổi tên signal để tránh lỗi Duplicate
    signal changeDriveMode(string mode)

    // --- Simulation Triggers ---
    signal toggleRoadSlippery()
    signal toggleRoadWet()
    signal toggleRoadIcy()

    // --- Internal Physics Variables ---
    property var energyHistory: []
    property point gForce: Qt.point(0,0)
    property real rpm: 0

    // ----------------------------------------------------------
    // ⚙️ PHYSICS ENGINE LOOP (High Frequency)
    // ----------------------------------------------------------
    Timer {
        interval: 30 // 33 FPS approx
        running: true
        repeat: true
        onTriggered: {
            // 1. G-Force Simulation (Rung lắc tự nhiên)
            var vibration = (currentSpeed > 5) ? (Math.random() - 0.5) * 0.02 : 0
            var latG = (currentSpeed > 20) ? ((Math.random() - 0.5) * 0.2) : 0
            var longG = (currentSpeed > 0) ? 0.05 : 0
            settingsPanel.gForce = Qt.point(latG + vibration, longG)

            // 2. Energy Graph Logic (Real-time plotting)
            var consumption = isCharging ? -45 : (currentSpeed * 0.5 + (acActive ? 5 : 1))
            consumption += (Math.random() - 0.5) * 2 // Noise
            energyHistory.push(consumption)
            if (energyHistory.length > 80) energyHistory.shift()
            energyGraphCanvas.requestPaint()

            // 3. Climate Physics
            if (acActive) {
                if (cabinTemp > 18.0) cabinTemp -= 0.01 * fanSpeed
            } else {
                if (cabinTemp < 28.0) cabinTemp += 0.005
            }

            // 4. Media Progress
            if (isMediaPlaying) {
                mediaProgress += 0.001
                if (mediaProgress > 1.0) mediaProgress = 0
            }
        }
    }

    // ==========================================================
    // 🎨 2. VISUAL LAYERS (BACKGROUND)
    // ==========================================================

    // Layer 1: Solid Base
    Rectangle { anchors.fill: parent; color: "#080808" }

    // Layer 2: Grid Texture
    Image {
        anchors.fill: parent
        source: "qrc:/assets/background.png"
        fillMode: Image.PreserveAspectCrop
        opacity: isDarkTheme ? 0.25 : 0.05
        visible: true
    }

    // Layer 3: Particle Ambience
    ParticleSystem {
        id: ambientDust
        anchors.fill: parent
        paused: !isDarkTheme

        ImageParticle {
            source: "qrc:/assets/glow_dot.png" // Sử dụng 1 ảnh nhỏ màu trắng làm hạt
            color: settingsPanel.accentColor
            colorVariation: 0.1
            alpha: 0.2
        }
        Emitter {
            anchors.fill: parent
            emitRate: 8
            lifeSpan: 8000
            size: 3
            sizeVariation: 2
            velocity: AngleDirection { angle: 90; magnitude: 5; magnitudeVariation: 5 }
        }
    }

    // Layer 4: Vignette
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.4; color: "transparent" }
            GradientStop { position: 1.0; color: "#000000" }
        }
    }

    // Layer 5: Decorative Vectors
    Image {
        source: "qrc:/assets/Vector 2.svg"
        height: parent.height * 0.9
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        opacity: isDarkTheme ? 0.3 : 0.1
    }
    Image {
        source: "qrc:/assets/Vector 1.svg"
        height: parent.height * 0.9
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        opacity: isDarkTheme ? 0.3 : 0.1
    }

    // ==========================================================
    // 🔝 3. HEADER BAR
    // ==========================================================
    Item {
        id: header
        width: parent.width; height: 80
        anchors.top: parent.top

        // Left: Back Button
        Row {
            anchors.left: parent.left; anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            Rectangle {
                width: 40; height: 40; radius: 20
                color: Qt.rgba(1,1,1,0.1); border.color: "#444"; border.width: 1
                Text { text: "⬅"; color: settingsPanel.accentColor; anchors.centerIn: parent }
                MouseArea { anchors.fill: parent; onClicked: settingsPanel.closeSettings(); cursorShape: Qt.PointingHandCursor }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                Text { text: "SYSTEM CONTROL"; color: "#666"; font.pixelSize: 10; font.bold: true; font.family: "Arial" }
                Text { text: "CONFIGURATION"; color: "white"; font.pixelSize: 14; font.bold: true; font.letterSpacing: 1; font.family: "Arial" }
            }
        }

        // Center: Time
        Column {
            anchors.centerIn: parent; spacing: 2
            Text { text: Qt.formatDateTime(new Date(), "HH:mm"); color: "white"; font.pixelSize: 32; font.bold: true; font.family: "Arial"; anchors.horizontalCenter: parent.horizontalCenter }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 8
                Rectangle { width: 8; height: 8; radius: 4; color: settingsPanel.accentColor; anchors.verticalCenter: parent.verticalCenter }
                Text { text: currentLanguage === "VN" ? "HỆ THỐNG SẴN SÀNG" : "SYSTEM ONLINE"; color: settingsPanel.accentColor; font.pixelSize: 10; font.bold: true; font.family: "Arial" }
            }
        }

        // Right: Notifications
        Row {
            anchors.right: parent.right; anchors.rightMargin: 50
            anchors.verticalCenter: parent.verticalCenter; spacing: 10

            Rectangle {
                width: 180; height: 34; radius: 17
                color: Qt.rgba(1, 0.2, 0.2, 0.15); border.color: "#FF3333"; border.width: 1
                visible: roadSlippery || roadIcy || roadWet
                Row {
                    anchors.centerIn: parent; spacing: 8
                    Text { text: "⚠"; color: "#FF3333"; font.pixelSize: 14 }
                    Text { text: "HAZARD DETECTED"; color: "#FF3333"; font.pixelSize: 10; font.bold: true; font.family: "Arial" }
                }
                SequentialAnimation on opacity {
                    // 1. Property khai báo không dùng dấu chấm phẩy
                    loops: Animation.Infinite

                    // 2. Các Animation con được viết tách dòng, rõ ràng
                    NumberAnimation {
                        to: 0.5
                        duration: 800
                        easing.type: Easing.InOutQuad // Khuyên dùng: Thêm easing để hiệu ứng "thở" mượt hơn
                    }

                    NumberAnimation {
                        to: 1.0
                        duration: 800
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Rectangle { width: parent.width * 0.95; height: 1; color: "#333"; anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter }
    }

    // ==========================================================
    // 🚘 4. CENTER STAGE (DIGITAL TWIN)
    // ==========================================================
    Item {
        id: centerStage
        width: parent.width * 0.4
        height: parent.height * 0.7
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 20

        // A. Radar Pulse Effect (Under Car)
        Item {
            anchors.centerIn: parent; width: 400; height: 400
            visible: currentTab === 2 // ADAS Only

            Repeater {
                model: 3
                Rectangle {
                    width: 100; height: 100; radius: 50
                    color: "transparent"; border.color: settingsPanel.accentColor; border.width: 2
                    anchors.centerIn: parent; opacity: 0
                    SequentialAnimation on width { loops: Animation.Infinite; running: true; NumberAnimation { from: 100; to: 500; duration: 2500; easing.type: Easing.OutQuad } }
                    SequentialAnimation on height { loops: Animation.Infinite; running: true; NumberAnimation { from: 100; to: 500; duration: 2500; easing.type: Easing.OutQuad } }
                    SequentialAnimation on opacity { loops: Animation.Infinite; running: true; NumberAnimation { from: 0.8; to: 0.0; duration: 2500; easing.type: Easing.OutQuad } }
                }
            }
        }

        // B. Vehicle Image
        Image {
            id: carModel
            source: "qrc:/assets/Car.svg"
            width: 280; height: 400
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            opacity: 1.0

            scale: 1.0
            SequentialAnimation on scale {
                running: roadSlippery || roadIcy
                loops: Animation.Infinite
                NumberAnimation { to: 1.02; duration: 200 }
                NumberAnimation { to: 1.0; duration: 200 }
            }
        }

        // C. Door Indicators
        Rectangle { width: 4; height: 70; color: "#FF3333"; anchors.right: carModel.left; anchors.rightMargin: -60; anchors.top: carModel.top; anchors.topMargin: 110; rotation: -25; visible: doorOpenFL }
        Rectangle { width: 4; height: 70; color: "#FF3333"; anchors.left: carModel.right; anchors.leftMargin: -60; anchors.top: carModel.top; anchors.topMargin: 110; rotation: 25; visible: doorOpenFR }

        // D. Turn Signals
        Text { text: "◀"; font.pixelSize: 50; color: settingsPanel.accentColor; anchors.right: carModel.left; anchors.rightMargin: -30; anchors.top: carModel.top; anchors.topMargin: 60; visible: leftSignal; opacity: signalBlinkState ? 1.0 : 0.2 }
        Text { text: "▶"; font.pixelSize: 50; color: settingsPanel.accentColor; anchors.left: carModel.right; anchors.leftMargin: -30; anchors.top: carModel.top; anchors.topMargin: 60; visible: rightSignal; opacity: signalBlinkState ? 1.0 : 0.2 }

        // E. HVAC Flow Particles
        ParticleSystem {
            anchors.fill: parent
            running: acActive && currentTab === 1
            ImageParticle { source: "qrc:/assets/glow_dot.png"; color: cabinTemp < 20 ? "#3399FF" : "#FF6600"; alpha: 0.4 }
            Emitter { x: parent.width / 2; y: parent.height / 2 - 50; width: 40; height: 20; emitRate: fanSpeed * 15; lifeSpan: 1200; size: 8; velocity: AngleDirection { angle: 90; magnitude: 100; magnitudeVariation: 30 } }
        }

        // F. TPMS HUD (Rectangle Lines - Safe Mode)
        TireIndicator { label: "FL"; pressure: "2.4"; temp: "35"; side: "left"; yOffset: 60; carRef: carModel }
        TireIndicator { label: "FR"; pressure: "2.4"; temp: "36"; side: "right"; yOffset: 60; carRef: carModel }
        TireIndicator { label: "RL"; pressure: "2.5"; temp: "38"; side: "left"; yOffset: 240; carRef: carModel }
        TireIndicator { label: "RR"; pressure: "2.5"; temp: "37"; side: "right"; yOffset: 240; carRef: carModel }
    }

    // ==========================================================
    // 🎛️ 5. LEFT PANEL: CONTROLS (TABBED)
    // ==========================================================
    Column {
        id: leftPanel
        width: 380
        anchors.left: parent.left; anchors.leftMargin: 60
        anchors.top: header.bottom; anchors.topMargin: 30
        anchors.bottom: parent.bottom; anchors.bottomMargin: 30
        spacing: 0

        // --- Tab Headers ---
        Row {
            width: parent.width; height: 50; spacing: 5
            TabButton { label: "CAR"; icon: "🚗"; index: 0; isActive: currentTab === 0; onClicked: currentTab = 0 }
            TabButton { label: "AC"; icon: "❄️"; index: 1; isActive: currentTab === 1; onClicked: currentTab = 1 }
            TabButton { label: "ADAS"; icon: "🛡️"; index: 2; isActive: currentTab === 2; onClicked: currentTab = 2 }
            TabButton { label: "SYS"; icon: "⚙️"; index: 3; isActive: currentTab === 3; onClicked: currentTab = 3 }
        }
        Rectangle { width: parent.width; height: 2; color: "#333" }

        // --- Tab Content ---
        Item {
            width: parent.width; height: parent.height - 60; clip: true

            // TAB 0: VEHICLE
            Flickable {
                anchors.fill: parent; visible: currentTab === 0; contentHeight: col0.height + 20; clip: true
                Column {
                    id: col0; width: parent.width; spacing: 20; topPadding: 20

                    ControlGroup {
                        title: "DRIVE MODES"
                        RowLayout {
                            width: parent.width; spacing: 10
                            // [FIXED] Dùng signal changeDriveMode
                            HMIButton { Layout.fillWidth: true; text: "ECO"; isActive: driveMode==="Eco"; accent: "#00FF99"; onClicked: settingsPanel.changeDriveMode("Eco") }
                            HMIButton { Layout.fillWidth: true; text: "SPORT"; isActive: driveMode==="Sport"; accent: "#FF3333"; onClicked: settingsPanel.changeDriveMode("Sport") }
                        }
                    }

                    ControlGroup {
                        title: "DOOR CONTROLS"
                        RowLayout {
                            width: parent.width; spacing: 10
                            HMIButton { Layout.fillWidth: true; text: "LEFT"; isActive: doorOpenFL; accent: "#FF3333"; onClicked: doorOpenFL = !doorOpenFL }
                            HMIButton { Layout.fillWidth: true; text: "RIGHT"; isActive: doorOpenFR; accent: "#FF3333"; onClicked: doorOpenFR = !doorOpenFR }
                        }
                        HMIButton { text: "LOCK ALL"; icon: "🔒"; isIconText: true; onClicked: { doorOpenFL=false; doorOpenFR=false } }
                    }
                }
            }

            // TAB 1: CLIMATE
            Flickable {
                anchors.fill: parent; visible: currentTab === 1; contentHeight: col1.height + 20; clip: true
                Column {
                    id: col1; width: parent.width; spacing: 20; topPadding: 20
                    ControlGroup {
                        title: "A/C POWER"
                        HMIButton { text: acActive ? "CLIMATE ON" : "CLIMATE OFF"; isActive: acActive; accent: "#3399FF"; onClicked: acActive = !acActive }
                    }
                    ControlGroup {
                        title: "FAN SPEED: " + fanSpeed
                        RowLayout {
                            width: parent.width; spacing: 10
                            HMIButton { Layout.fillWidth: true; text: "-"; onClicked: if(fanSpeed>1) fanSpeed-- }
                            Row {
                                Layout.fillWidth: true; spacing: 4
                                Repeater { model: 5; Rectangle { width: (parent.width/5)-4; height: 10; radius: 2; color: index < fanSpeed ? "#3399FF" : "#333" } }
                            }
                            HMIButton { Layout.fillWidth: true; text: "+"; onClicked: if(fanSpeed<5) fanSpeed++ }
                        }
                    }
                    ControlGroup {
                        title: "TARGET TEMP: " + cabinTemp.toFixed(1) + "°C"
                        Slider {
                            width: parent.width; from: 16; to: 30; value: cabinTemp; onMoved: cabinTemp = value
                            handle: Rectangle { width: 24; height: 24; radius: 12; color: "white" }
                            background: Rectangle { width: parent.width; height: 6; color: "#333"; radius: 3; Rectangle { width: parent.visualPosition * parent.width; height: 6; color: settingsPanel.accentColor; radius: 3 } }
                        }
                    }
                }
            }

            // TAB 2: ADAS
            Flickable {
                anchors.fill: parent; visible: currentTab === 2; contentHeight: col2.height + 20; clip: true
                Column {
                    id: col2; width: parent.width; spacing: 20; topPadding: 20
                    ControlGroup {
                        title: "ROAD HAZARDS"
                        HMIButton { text: "SLIPPERY"; icon: "⚠️"; isIconText: true; isActive: roadSlippery; accent: "#FF6600"; onClicked: settingsPanel.toggleRoadSlippery() }
                        HMIButton { text: "WET ROAD"; icon: "🌧️"; isIconText: true; isActive: roadWet; accent: "#3399FF"; onClicked: settingsPanel.toggleRoadWet() }
                        HMIButton { text: "ICY ROAD"; icon: "❄️"; isIconText: true; isActive: roadIcy; accent: "#00FFFF"; onClicked: settingsPanel.toggleRoadIcy() }
                    }
                }
            }

            // TAB 3: SYSTEM
            Flickable {
                anchors.fill: parent; visible: currentTab === 3; contentHeight: col3.height + 20; clip: true
                Column {
                    id: col3; width: parent.width; spacing: 20; topPadding: 20
                    ControlGroup {
                        title: "USER EXPERIENCE"
                        HMIButton { text: isDarkTheme ? "THEME: DARK" : "THEME: LIGHT"; icon: isDarkTheme ? "qrc:/assets/moon.svg" : "qrc:/assets/sun.svg"; isActive: true; accent: settingsPanel.accentColor; onClicked: settingsPanel.themeChanged(!isDarkTheme) }
                        HMIButton { text: currentLanguage === "VN" ? "LANG: TIẾNG VIỆT" : "LANG: ENGLISH"; icon: "qrc:/assets/language.svg"; isActive: true; accent: settingsPanel.accentColor; onClicked: settingsPanel.languageChanged(currentLanguage === "EN" ? "VN" : "EN") }
                    }
                }
            }
        }
    }

    // ==========================================================
    // 📊 6. RIGHT PANEL: TELEMETRY
    // ==========================================================
    Column {
        id: rightPanel
        width: 350
        anchors.right: parent.right; anchors.rightMargin: 60
        anchors.top: header.bottom; anchors.topMargin: 30
        spacing: 25

        // WIDGET 1: LIVE DATA
        Rectangle {
            width: parent.width; height: 100
            color: Qt.rgba(0.1,0.1,0.1,0.5); radius: 10; border.color: settingsPanel.accentColor; border.width: 1
            RowLayout {
                anchors.fill: parent; anchors.margins: 20
                Column {
                    Text { text: Math.round(currentSpeed); font.pixelSize: 42; font.bold: true; color: "white"; font.family: "Arial" }
                    Text { text: "KM/H"; color: "#888"; font.pixelSize: 10; font.bold: true; font.family: "Arial" }
                }
                Item { Layout.fillWidth: true }
                Column {
                    Layout.alignment: Qt.AlignRight
                    Text { text: Math.round(currentBattery) + "%"; font.pixelSize: 32; font.bold: true; color: currentBattery < 20 ? "#FF3333" : settingsPanel.accentColor; horizontalAlignment: Text.AlignRight; width: parent.width; font.family: "Arial" }
                    Text { text: "BATTERY"; color: "#888"; font.pixelSize: 10; font.bold: true; horizontalAlignment: Text.AlignRight; width: parent.width; font.family: "Arial" }
                }
            }
        }

        // WIDGET 2: G-FORCE METER
        Rectangle {
            width: parent.width; height: 160
            color: Qt.rgba(0,0,0,0.5); radius: 8; border.color: "#333"; border.width: 1
            Text { text: "G-FORCE"; color: "#666"; font.pixelSize: 10; anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 10; font.bold: true; font.family: "Arial" }
            Canvas {
                id: gForceCanvas
                anchors.centerIn: parent; width: 120; height: 120
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,width,height)
                    ctx.strokeStyle = "#444"; ctx.lineWidth = 1
                    ctx.beginPath(); ctx.arc(60,60,50,0,6.28); ctx.stroke()
                    ctx.beginPath(); ctx.arc(60,60,25,0,6.28); ctx.stroke()
                    ctx.beginPath(); ctx.moveTo(60,10); ctx.lineTo(60,110); ctx.stroke()
                    ctx.beginPath(); ctx.moveTo(10,60); ctx.lineTo(110,60); ctx.stroke()
                    var x = 60 + (settingsPanel.gForce.x * 200)
                    var y = 60 + (settingsPanel.gForce.y * 200)
                    ctx.fillStyle = settingsPanel.accentColor
                    ctx.beginPath(); ctx.arc(x,y,5,0,6.28); ctx.fill()
                }
            }
            Connections { target: settingsPanel; function onGForceChanged() { gForceCanvas.requestPaint() } }
        }

        // WIDGET 3: ENERGY GRAPH
        Rectangle {
            width: parent.width; height: 120
            color: Qt.rgba(0,0,0,0.5); radius: 8; border.color: "#333"; border.width: 1
            Text { text: "ENERGY FLOW (kW)"; color: "#666"; font.pixelSize: 10; anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 10; font.bold: true; font.family: "Arial" }
            Canvas {
                id: energyGraphCanvas
                anchors.fill: parent; anchors.margins: 10; anchors.topMargin: 25
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,width,height)
                    if(energyHistory.length < 2) return
                    ctx.strokeStyle = settingsPanel.accentColor; ctx.lineWidth = 2
                    ctx.beginPath()
                    var step = width / (energyHistory.length-1)
                    for(var i=0; i<energyHistory.length; i++){
                        var val = energyHistory[i]
                        var y = height/2 - (val / 100 * (height/2))
                        if(i===0) ctx.moveTo(0,y)
                        else ctx.lineTo(i*step, y)
                    }
                    ctx.stroke()
                }
            }
        }

        // WIDGET 4: MEDIA PLAYER
        Rectangle {
            width: parent.width; height: 80
            color: Qt.rgba(0.1,0.1,0.1,0.8); radius: 10; border.color: "#444"; border.width: 1
            RowLayout {
                anchors.fill: parent; anchors.margins: 10
                Rectangle { width: 60; height: 60; color: "#333"; radius: 5; Text { text: "🎵"; font.pixelSize: 30; anchors.centerIn: parent } }
                Column {
                    Layout.fillWidth: true
                    Text { text: mediaTrack; color: "white"; font.bold: true; font.family: "Arial"; elide: Text.ElideRight; width: parent.width }
                    Text { text: mediaArtist; color: "#888"; font.pixelSize: 12; font.family: "Arial"; elide: Text.ElideRight; width: parent.width }
                    Rectangle { width: parent.width; height: 4; color: "#222"; radius: 2; Rectangle { width: parent.width * mediaProgress; height: 4; radius: 2; color: settingsPanel.accentColor } }
                }
                HMIButton { width: 40; height: 40; text: isMediaPlaying ? "⏸" : "▶"; isIconText: true; onClicked: isMediaPlaying = !isMediaPlaying }
            }
        }
    }

    // ==========================================================
    // 🧩 7. UI COMPONENT LIBRARY
    // ==========================================================

    component TabButton: Rectangle {
        property string label
        property string icon
        property int index
        property bool isActive
        signal clicked()

        width: (parent.width / 4) - 5; height: 40; radius: 5
        color: isActive ? Qt.rgba(settingsPanel.accentColor.r, settingsPanel.accentColor.g, settingsPanel.accentColor.b, 0.1) : "transparent"
        border.color: isActive ? settingsPanel.accentColor : "#444"; border.width: 1
        Row {
            anchors.centerIn: parent; spacing: 5
            Text { text: icon; visible: icon !== ""; font.pixelSize: 14 }
            Text { text: label; color: isActive ? "white" : "#888"; font.bold: true; font.pixelSize: 11; font.family: "Arial" }
        }
        MouseArea { anchors.fill: parent; onClicked: parent.clicked(); cursorShape: Qt.PointingHandCursor }
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    component ControlGroup: Column {
        property string title
        default property alias content: container.children
        width: parent.width; spacing: 15
        Text { text: title; color: "#666"; font.bold: true; font.pixelSize: 10; font.family: "Arial" }
        Rectangle { width: parent.width; height: 1; color: "#333" }
        Column { id: container; width: parent.width; spacing: 10 }
    }

    component HMIButton: Rectangle {
        property string text
        property string icon
        property bool isActive: false
        property bool isIconText: false
        property color accent: "#00FF99"
        signal clicked()

        height: 45; radius: 6; border.width: 1
        color: isActive ? Qt.rgba(accent.r, accent.g, accent.b, 0.2) : Qt.rgba(1,1,1,0.05)
        border.color: isActive ? accent : "transparent"
        Row {
            anchors.centerIn: parent; spacing: 10
            Item {
                width: 20; height: 20; visible: icon !== ""
                Image { visible: !isIconText; source: icon; anchors.fill: parent; fillMode: Image.PreserveAspectFit }
                Text { visible: isIconText; text: icon; font.pixelSize: 18; anchors.centerIn: parent }
            }
            Text { text: parent.parent.text; color: isActive ? "white" : "#888"; font.bold: true; font.family: "Arial"; font.pixelSize: 11; verticalAlignment: Text.AlignVCenter }
        }
        MouseArea {
            anchors.fill: parent; onClicked: parent.clicked(); hoverEnabled: true; cursorShape: Qt.PointingHandCursor
            onEntered: parent.border.color = Qt.lighter(parent.accent, 1.5)
            onExited: parent.border.color = parent.isActive ? parent.accent : "transparent"
        }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    component TireIndicator: Item {
        property string label
        property string pressure
        property string temp
        property string side: "left"
        property real yOffset
        property var carRef

        x: side === "left" ? (carRef.x - 90) : (carRef.x + carRef.width + 30)
        y: carRef.y + yOffset
        width: 90; height: 40

        Rectangle {
            id: box
            width: 60; height: 40; color: Qt.rgba(0,0,0,0.8); border.color: "#444"; border.width: 1; radius: 4
            anchors.right: side === "left" ? parent.right : undefined
            anchors.left: side === "right" ? parent.left : undefined
            Column {
                anchors.centerIn: parent
                Text { text: label; color: "#666"; font.pixelSize: 9; font.bold: true; font.family: "Arial" }
                Text { text: pressure + " bar"; color: settingsPanel.accentColor; font.pixelSize: 12; font.bold: true; font.family: "Arial" }
            }
        }
        Rectangle {
            width: 30; height: 1; color: settingsPanel.accentColor; opacity: 0.6
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: side === "left" ? box.left : undefined
            anchors.left: side === "right" ? box.right : undefined
        }
    }
}
