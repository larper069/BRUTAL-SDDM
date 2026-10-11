import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#11110f"
    focus: true

    property color ink: "#11110f"
    property color paper: "#FFFDD0"
    property color paper2: "#fff8c2"
    property color red: "#ff4b2b"
    property color muted: "#8b8981"
    property color line: "#373631"
    property string clockTime: Qt.formatTime(new Date(), "HH:mm")
    property string clockDate: Qt.formatDate(new Date(), "dddd / dd MMMM yyyy")
    property int selectedSession: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property bool showPowerMenu: false
    property bool showSessionMenu: false
    property bool authenticating: false
    property string statusMessage: ""

    FontLoader {
        id: monoFont
        source: "assets/DMMono-Regular.ttf"
    }
    FontLoader {
        id: displayFont
        source: "assets/HiJO-Regular.otf"
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.clockTime = Qt.formatTime(new Date(), "HH:mm")
            root.clockDate = Qt.formatDate(new Date(), "dddd / dd MMMM yyyy")
        }
    }

    Canvas {
        anchors.fill: parent
        opacity: 0.18
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "#373631"
            ctx.lineWidth = 1
            for (var x = 0; x < width; x += 58) {
                ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, height); ctx.stroke()
            }
            for (var y = 0; y < height; y += 58) {
                ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke()
            }
        }
    }

    Shape {
        anchors.fill: parent
        opacity: 0.22
        ShapePath {
            strokeColor: root.red
            strokeWidth: 3
            fillColor: "transparent"
            startX: 0
            startY: root.height * 0.24
            PathCubic {
                x: root.width
                y: root.height * 0.28
                control1X: root.width * 0.28
                control1Y: root.height * 0.02
                control2X: root.width * 0.66
                control2Y: root.height * 0.48
            }
        }
    }

    // Header
    Row {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: Math.max(28, root.width * 0.055)
        anchors.rightMargin: Math.max(28, root.width * 0.055)
        anchors.topMargin: Math.max(24, root.height * 0.04)
        spacing: 5
        
        Rectangle { width: 1; height: 24; color: root.line; anchors.verticalCenter: parent.verticalCenter }
        Text {
            text: ""
            color: root.muted
            font.family: monoFont.name
            font.pixelSize: 11
            font.letterSpacing: 1.5
            anchors.verticalCenter: parent.verticalCenter
        }
        Item { width: 1; height: 1; anchors.verticalCenter: parent.verticalCenter }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "AUTHENTICATION READY"
            color: root.paper
            font.family: monoFont.name
            font.pixelSize: 15
            font.letterSpacing: 1
        }
        Rectangle {
            width: 8; height: 12; color: root.red
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Oversized clock
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.height * 0.17
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.clockTime
            color: root.paper
            font.family: displayFont.name
            font.pixelSize: Math.min(root.width * 0.145, root.height * 0.245)
            font.bold: true
            font.letterSpacing: -5
            style: Text.Outline
            styleColor: "#000000"
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            Rectangle { width: 28; height: 3; color: root.red; anchors.verticalCenter: parent.verticalCenter }
            Text {
                text: root.clockDate.toUpperCase()
                color: root.muted
                font.family: monoFont.name
                font.pixelSize: 12
                font.letterSpacing: 1.6
            }
            Rectangle { width: 28; height: 3; color: root.red; anchors.verticalCenter: parent.verticalCenter }
        }
    }

    // Login panel, centered in the lower half
    Rectangle {
        id: loginPanel
        width: Math.min(420, root.width * 0.88)
        height: 252
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(86, root.height * 0.115)
        color: root.ink
        border.width: 1
        border.color: root.line

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.topMargin: 6
            z: -1
            color: root.red
        }

        Column {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 10

            Row {
                width: parent.width
                spacing: 8
                Rectangle { width: 6; height: 18; color: root.red }
                Text {
                    text: "SIGN IN TO YOUR SYSTEM"
                    color: root.paper
                    font.family: monoFont.name
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 1
                }
            }
            Text {
                text: " "
                color: root.paper
                font.family: monoFont.name
                font.pixelSize: 10
                font.letterSpacing: 1.2
            }
            TextField {
                id: userField
                width: parent.width
                height: 38
                text: userModel.lastUser
                placeholderText: "                                                         username"
                color: root.paper
                placeholderTextColor: root.paper
                font.family: monoFont.name
                font.pixelSize: 18
                leftPadding: 12
                rightPadding: 12
                background: Rectangle {
                    color: "#191916"
                    border.width: 2
                    border.color: userField.activeFocus ? root.red : root.line
                }
                onAccepted: passwordField.forceActiveFocus()
            }

            Text {
                text: " "
                color: root.paper
                font.family: monoFont.name
                font.pixelSize: 10
                font.letterSpacing: 1.2
            }
            TextField {
                id: passwordField
                width: parent.width
                height: 38
                placeholderText: "                                                         password"
                color: root.paper
                placeholderTextColor: root.paper
                echoMode: TextInput.Password
                font.family: monoFont.name
                font.pixelSize: 18
                leftPadding: 12
                rightPadding: 12
                background: Rectangle {
                    color: "#191916"
                    border.width: 2
                    border.color: passwordField.activeFocus ? root.red : root.line
                }
                onAccepted: root.doLogin()
            }

            Row {
                width: parent.width
                spacing: 10
                Rectangle {
                    width: 377
                    height: 34
                    color: loginMouse.containsMouse ? root.paper : root.red
                    Text {
                        anchors.centerIn: parent
                        text: root.authenticating ? "PLEASE WAIT" : "LOG IN  →"
                        color: root.ink
                        font.family: monoFont.name
                        font.pixelSize: 10
                        font.bold: true
                    }
                    MouseArea {
                        id: loginMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !root.authenticating
                        onClicked: root.doLogin()
                    }
                }
                Text {
                    width: parent.width - 122
                    height: 34
                    verticalAlignment: Text.AlignVCenter
                    text: root.statusMessage
                    color: root.muted
                    font.family: monoFont.name
                    font.pixelSize: 8
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                }
            }
        }
    }

    // Bottom-left compact session picker
    Rectangle {
        id: sessionButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: Math.max(28, root.width * 0.055)
        anchors.bottomMargin: 24
        width: 204
        height: 36
        color: root.ink
        border.width: 1
        border.color: root.line
        z: 5

        Row {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 8
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "SESSION"
                color: root.red
                font.family: monoFont.name
                font.pixelSize: 10
                font.bold: true
            }
            Text {
                width: 116
                anchors.verticalCenter: parent.verticalCenter
                text: sessionModel.count > 0 ? sessionModel.get(root.selectedSession).name : "DEFAULT"
                color: root.paper
                font.family: monoFont.name
                font.pixelSize: 10
                elide: Text.ElideRight
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.showSessionMenu ? "⌃" : "⌄"
                color: root.paper
                font.pixelSize: 14
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.showSessionMenu = !root.showSessionMenu
                root.showPowerMenu = false
            }
        }

        Column {
            visible: root.showSessionMenu
            anchors.left: parent.left
            anchors.bottom: parent.top
            width: parent.width
            z: 10
            Repeater {
                model: sessionModel
                delegate: Rectangle {
                    required property int index
                    width: sessionButton.width
                    height: 34
                    color: root.selectedSession === index ? root.red : root.ink
                    border.width: 1
                    border.color: root.line
                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        text: sessionModel.get(index).name
                        color: root.paper
                        font.family: monoFont.name
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.selectedSession = index
                            root.showSessionMenu = false
                        }
                    }
                }
            }
        }
    }

    // Bottom-right compact power menu
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: Math.max(28, root.width * 0.055)
        anchors.bottomMargin: 24
        spacing: 6
        z: 5

        Repeater {
            model: [
                { label: "SLEEP", glyph: "☾", action: "suspend" },
                { label: "RESTART", glyph: "↻", action: "reboot" }
            ]
            delegate: Rectangle {
                required property var modelData
                width: modelData.action === "reboot" ? 88 : 76
                height: 36
                color: powerMouse.containsMouse ? root.red : root.ink
                border.width: 1
                border.color: powerMouse.containsMouse ? root.red : root.line
                Row {
                    anchors.centerIn: parent
                    spacing: 5
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.glyph
                        color: root.paper
                        font.pixelSize: 13
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.label
                        color: root.paper
                        font.family: monoFont.name
                        font.pixelSize: 9
                        font.bold: true
                    }
                }
                MouseArea {
                    id: powerMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (modelData.action === "reboot") sddm.reboot()
                        else if (modelData.action === "suspend") sddm.suspend()
                    }
                }
            }
        }

        Rectangle {
            width: 96
            height: 36
            color: powerOffMouse.containsMouse ? root.red : root.ink
            border.width: 1
            border.color: powerOffMouse.containsMouse ? root.red : root.line
            Row {
                anchors.centerIn: parent
                spacing: 5
                Text { anchors.verticalCenter: parent.verticalCenter; text: "⏻"; color: root.paper; font.pixelSize: 13 }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "POWER OFF"
                    color: root.paper
                    font.family: monoFont.name
                    font.pixelSize: 9
                    font.bold: true
                }
            }
            MouseArea {
                id: powerOffMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
        }
    }

    function doLogin() {
        if (userField.text.length === 0) {
            root.statusMessage = "ENTER A USERNAME FIRST"
            userField.forceActiveFocus()
            return
        }
        root.authenticating = true
        root.statusMessage = ""
        sddm.login(userField.text, passwordField.text, root.selectedSession)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            root.authenticating = false
            root.statusMessage = "LOGIN FAILED — CHECK CREDENTIALS"
            passwordField.selectAll()
            passwordField.forceActiveFocus()
        }
        function onLoginSucceeded() {
            root.authenticating = false
            root.statusMessage = "LOGIN ACCEPTED"
        }
    }

    Keys.onReturnPressed: {
        if (passwordField.activeFocus) root.doLogin()
        else if (userField.activeFocus) passwordField.forceActiveFocus()
    }
    Keys.onEnterPressed: {
        if (passwordField.activeFocus) root.doLogin()
        else if (userField.activeFocus) passwordField.forceActiveFocus()
    }
}
