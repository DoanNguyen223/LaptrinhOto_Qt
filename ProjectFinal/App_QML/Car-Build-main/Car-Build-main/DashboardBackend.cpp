#include "DashboardBackend.h"
#include <QSerialPortInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

DashboardBackend::DashboardBackend(QObject *parent)
    : QObject(parent),
    m_speed(0),
    m_rpm(0),
    m_temperature(25.0f),
    m_connected(false),
    m_xang(67),
    m_apsuat(35),
    m_leftSignal(false),
    m_rightSignal(false),
    m_dau(false),
    m_denCavang(false),
    m_abs(false),
    m_pha(false),
    m_dayAnToan(false),
    m_duongtron(false),
    m_denCanhbao(false),
    m_distanceCm(0),
    m_obstacleDetected(false),
    m_tirePressureFL(2.4),
    m_tirePressureFR(2.4),
    m_tirePressureRL(2.5),
    m_tirePressureRR(2.5)
{
    m_serial = new QSerialPort(this);
    m_connectionTimer = new QTimer(this);

    connect(m_serial, &QSerialPort::readyRead, this, &DashboardBackend::readData);
    connect(m_serial, &QSerialPort::errorOccurred, this, &DashboardBackend::handleError);
    connect(m_connectionTimer, &QTimer::timeout, this, &DashboardBackend::checkConnection);

    m_connectionTimer->start(2000);
    qDebug() << "DashboardBackend initialized";
}

DashboardBackend::~DashboardBackend()
{
    if (m_serial->isOpen()) {
        m_serial->close();
    }
}

QStringList DashboardBackend::getAvailablePorts()
{
    QStringList ports;
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos) {
        ports << info.portName();
        qDebug() << "Port:" << info.portName() << "Description:" << info.description();
    }
    return ports;
}

void DashboardBackend::connectSerial()
{
    if (m_serial->isOpen()) {
        qDebug() << "Port already connected!";
        return;
    }

    const auto infos = QSerialPortInfo::availablePorts();
    QString portName;

    qDebug() << "=== Scanning for ESP32 ===";

    for (const QSerialPortInfo &info : infos) {
        qDebug() << "Port:" << info.portName()
        << "| VID:PID:" << QString::number(info.vendorIdentifier(), 16)
        << ":" << QString::number(info.productIdentifier(), 16);

        bool isESP32 = false;

        if (info.portName().contains("USB") || info.portName().contains("ACM")) {
            isESP32 = true;
        }

        // CH340
        if (info.vendorIdentifier() == 0x1a86 && info.productIdentifier() == 0x7523) {
            qDebug() << "✓ Found CH340 (ESP32)";
            isESP32 = true;
        }
        // CP2102
        if (info.vendorIdentifier() == 0x10c4 && info.productIdentifier() == 0xea60) {
            qDebug() << "✓ Found CP2102 (ESP32)";
            isESP32 = true;
        }

        if (isESP32) {
            portName = info.portName();
            qDebug() << ">>> Selected port:" << portName;
            break;
        }
    }

    if (portName.isEmpty()) {
        portName = "/dev/ttyUSB0";  // Fallback
        qDebug() << "⚠️  No ESP32 found, trying default:" << portName;
    }

    m_serial->setPortName(portName);
    m_serial->setBaudRate(QSerialPort::Baud115200);
    m_serial->setDataBits(QSerialPort::Data8);
    m_serial->setParity(QSerialPort::NoParity);
    m_serial->setStopBits(QSerialPort::OneStop);
    m_serial->setFlowControl(QSerialPort::NoFlowControl);

    if (m_serial->open(QIODevice::ReadOnly)) {
        qDebug() << "✓ Connected successfully to:" << portName;
        setConnected(true);
        m_buffer.clear();
    } else {
        qDebug() << "✗ Connection error:" << m_serial->errorString();
        emit errorOccurred(m_serial->errorString());
        setConnected(false);
    }
}

void DashboardBackend::disconnectSerial()
{
    if (m_serial->isOpen()) {
        m_serial->close();
        setConnected(false);
        qDebug() << "Disconnected";
    }
}

void DashboardBackend::readData()
{
    if (!m_serial->isOpen()) return;

    QByteArray newData = m_serial->readAll();
    m_buffer.append(newData);

    int newlineIndex;
    while ((newlineIndex = m_buffer.indexOf('\n')) != -1) {
        QByteArray line = m_buffer.left(newlineIndex).trimmed();
        m_buffer.remove(0, newlineIndex + 1);

        if (!line.isEmpty()) {
            parseJsonData(line);
        }
    }

    if (m_buffer.size() > 1024) {
        qDebug() << "Buffer overflow, clearing...";
        m_buffer.clear();
    }
}

void DashboardBackend::parseJsonData(const QByteArray &data)
{
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qDebug() << "JSON parse error:" << parseError.errorString();
        return;
    }

    if (!doc.isObject()) return;

    QJsonObject obj = doc.object();

    // ===== PARSE SPEED =====
    if (obj.contains("speed")) {
        int newSpeed = obj["speed"].toInt();
        if (newSpeed >= 0 && newSpeed <= 200 && newSpeed != m_speed) {
            m_speed = newSpeed;
            emit speedChanged();
            calculateRPMAndTemp();
        }
    }

    // ===== PARSE FUEL & PRESSURE =====
    if (obj.contains("xang")) {
        int newXang = obj["xang"].toInt();
        if (newXang != m_xang) {
            m_xang = newXang;
            emit xangChanged();
        }
    }

    if (obj.contains("apsuat")) {
        int newApsuat = obj["apsuat"].toInt();
        if (newApsuat != m_apsuat) {
            m_apsuat = newApsuat;
            emit apsuatChanged();
        }
    }

    // ===== PARSE CONTROL SIGNALS =====
    if (obj.contains("left")) {
        bool newState = (obj["left"].toInt() == 1);
        if (newState != m_leftSignal) {
            m_leftSignal = newState;
            emit leftSignalChanged();
        }
    }

    if (obj.contains("right")) {
        bool newState = (obj["right"].toInt() == 1);
        if (newState != m_rightSignal) {
            m_rightSignal = newState;
            emit rightSignalChanged();
        }
    }

    if (obj.contains("dau")) {
        bool newState = (obj["dau"].toInt() == 1);
        if (newState != m_dau) {
            m_dau = newState;
            emit dauChanged();
        }
    }

    if (obj.contains("cavang")) {
        bool newState = (obj["cavang"].toInt() == 1);
        if (newState != m_denCavang) {
            m_denCavang = newState;
            emit denCavangChanged();
        }
    }

    if (obj.contains("abs")) {
        bool newState = (obj["abs"].toInt() == 1);
        if (newState != m_abs) {
            m_abs = newState;
            emit absChanged();
        }
    }

    // ===== PARSE TOGGLE STATES =====
    if (obj.contains("pha")) {
        bool newState = (obj["pha"].toInt() == 1);
        if (newState != m_pha) {
            m_pha = newState;
            emit phaChanged();
        }
    }

    if (obj.contains("dayan")) {
        bool newState = (obj["dayan"].toInt() == 1);
        if (newState != m_dayAnToan) {
            m_dayAnToan = newState;
            emit dayAnToanChanged();
        }
    }

    if (obj.contains("duongtron")) {
        bool newState = (obj["duongtron"].toInt() == 1);
        if (newState != m_duongtron) {
            m_duongtron = newState;
            emit duongtronChanged();
        }
    }

    // ===== PARSE WARNINGS =====
    if (obj.contains("warn_led")) {
        bool newState = (obj["warn_led"].toInt() == 1);
        if (newState != m_denCanhbao) {
            m_denCanhbao = newState;
            emit denCanhbaoChanged();
        }
    }

    // ===== PARSE ULTRASONIC =====
    if (obj.contains("distance_cm")) {
        int newDistance = obj["distance_cm"].toInt();
        if (newDistance != m_distanceCm) {
            m_distanceCm = newDistance;
            emit distanceCmChanged();
        }
    }

    if (obj.contains("obstacle")) {
        bool newState = (obj["obstacle"].toInt() == 1);
        if (newState != m_obstacleDetected) {
            m_obstacleDetected = newState;
            emit obstacleDetectedChanged();
        }
    }

    // ===== PARSE TIRE PRESSURE =====
    if (obj.contains("tire_fl")) {
        float newValue = obj["tire_fl"].toDouble();
        if (qAbs(newValue - m_tirePressureFL) > 0.01) {
            m_tirePressureFL = newValue;
            emit tirePressureFLChanged();
        }
    }

    if (obj.contains("tire_fr")) {
        float newValue = obj["tire_fr"].toDouble();
        if (qAbs(newValue - m_tirePressureFR) > 0.01) {
            m_tirePressureFR = newValue;
            emit tirePressureFRChanged();
        }
    }

    if (obj.contains("tire_rl")) {
        float newValue = obj["tire_rl"].toDouble();
        if (qAbs(newValue - m_tirePressureRL) > 0.01) {
            m_tirePressureRL = newValue;
            emit tirePressureRLChanged();
        }
    }

    if (obj.contains("tire_rr")) {
        float newValue = obj["tire_rr"].toDouble();
        if (qAbs(newValue - m_tirePressureRR) > 0.01) {
            m_tirePressureRR = newValue;
            emit tirePressureRRChanged();
        }
    }

    // Status message
    if (obj.contains("status")) {
        QString status = obj["status"].toString();
        qDebug() << "ESP32 status:" << status;
    }
}

void DashboardBackend::calculateRPMAndTemp()
{
    int newRpm = m_speed * 50;
    if (newRpm != m_rpm) {
        m_rpm = newRpm;
        emit rpmChanged();
    }

    float targetTemp = 25.0f + (m_speed / 180.0f) * 75.0f;
    float smoothedTemp = m_temperature * 0.9f + targetTemp * 0.1f;

    if (qAbs(smoothedTemp - m_temperature) > 0.5f) {
        m_temperature = smoothedTemp;
        emit temperatureChanged();
    }
}

void DashboardBackend::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        qDebug() << "Serial connection lost!";
        setConnected(false);
        disconnectSerial();
    } else if (error != QSerialPort::NoError) {
        qDebug() << "Serial error:" << m_serial->errorString();
    }
}

void DashboardBackend::checkConnection()
{
    bool isOpen = m_serial->isOpen();
    if (isOpen != m_connected) {
        setConnected(isOpen);
    }
}

void DashboardBackend::setConnected(bool status)
{
    if (m_connected != status) {
        m_connected = status;
        emit connectedChanged();
        qDebug() << "Connection status:" << (status ? "✓ Connected" : "✗ Disconnected");
    }
}
