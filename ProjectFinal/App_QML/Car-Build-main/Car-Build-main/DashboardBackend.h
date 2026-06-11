#ifndef DASHBOARDBACKEND_H
#define DASHBOARDBACKEND_H

#include <QObject>
#include <QSerialPort>
#include <QTimer>

class DashboardBackend : public QObject
{
    Q_OBJECT

    // ===== DASHBOARD DATA =====
    Q_PROPERTY(int speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(int rpm READ rpm NOTIFY rpmChanged)
    Q_PROPERTY(float temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)

    // ===== CONTROL SIGNALS (NÚT NHẤN) =====
    Q_PROPERTY(bool leftSignal READ leftSignal NOTIFY leftSignalChanged)
    Q_PROPERTY(bool rightSignal READ rightSignal NOTIFY rightSignalChanged)
    Q_PROPERTY(bool dau READ dau NOTIFY dauChanged)
    Q_PROPERTY(bool abs READ abs NOTIFY absChanged)
    Q_PROPERTY(bool denCavang READ denCavang NOTIFY denCavangChanged)

    // ===== TOGGLE BUTTONS =====
    Q_PROPERTY(bool pha READ pha NOTIFY phaChanged)
    Q_PROPERTY(bool dayAnToan READ dayAnToan NOTIFY dayAnToanChanged)
    Q_PROPERTY(bool duongtron READ duongtron NOTIFY duongtronChanged)

    // ===== WARNINGS =====
    Q_PROPERTY(bool denCanhbao READ denCanhbao NOTIFY denCanhbaoChanged)

    // ===== FUEL & PRESSURE =====
    Q_PROPERTY(int xang READ xang NOTIFY xangChanged)
    Q_PROPERTY(int apsuat READ apsuat NOTIFY apsuatChanged)

    // ===== IVI DATA =====
    Q_PROPERTY(float tirePressureFL READ tirePressureFL NOTIFY tirePressureFLChanged)
    Q_PROPERTY(float tirePressureFR READ tirePressureFR NOTIFY tirePressureFRChanged)
    Q_PROPERTY(float tirePressureRL READ tirePressureRL NOTIFY tirePressureRLChanged)
    Q_PROPERTY(float tirePressureRR READ tirePressureRR NOTIFY tirePressureRRChanged)
    Q_PROPERTY(bool roadSlippery READ roadSlippery NOTIFY roadSlipperyChanged)
    Q_PROPERTY(bool obstacleDetected READ obstacleDetected NOTIFY obstacleDetectedChanged)
    Q_PROPERTY(int distanceCm READ distanceCm NOTIFY distanceCmChanged)

public:
    explicit DashboardBackend(QObject *parent = nullptr);
    ~DashboardBackend();

    // Getters
    int speed() const { return m_speed; }
    int rpm() const { return m_rpm; }
    float temperature() const { return m_temperature; }
    bool connected() const { return m_connected; }

    bool leftSignal() const { return m_leftSignal; }
    bool rightSignal() const { return m_rightSignal; }
    bool dau() const { return m_dau; }
    bool abs() const { return m_abs; }
    bool denCavang() const { return m_denCavang; }

    bool pha() const { return m_pha; }
    bool dayAnToan() const { return m_dayAnToan; }
    bool duongtron() const { return m_duongtron; }

    bool denCanhbao() const { return m_denCanhbao; }

    int xang() const { return m_xang; }
    int apsuat() const { return m_apsuat; }

    float tirePressureFL() const { return m_tirePressureFL; }
    float tirePressureFR() const { return m_tirePressureFR; }
    float tirePressureRL() const { return m_tirePressureRL; }
    float tirePressureRR() const { return m_tirePressureRR; }
    bool roadSlippery() const { return m_roadSlippery; }
    bool obstacleDetected() const { return m_obstacleDetected; }
    int distanceCm() const { return m_distanceCm; }

    Q_INVOKABLE void connectSerial();
    Q_INVOKABLE void disconnectSerial();
    Q_INVOKABLE QStringList getAvailablePorts();

signals:
    void speedChanged();
    void rpmChanged();
    void temperatureChanged();
    void connectedChanged();

    void leftSignalChanged();
    void rightSignalChanged();
    void dauChanged();
    void absChanged();
    void denCavangChanged();

    void phaChanged();
    void dayAnToanChanged();
    void duongtronChanged();

    void denCanhbaoChanged();

    void xangChanged();
    void apsuatChanged();

    void tirePressureFLChanged();
    void tirePressureFRChanged();
    void tirePressureRLChanged();
    void tirePressureRRChanged();
    void roadSlipperyChanged();
    void obstacleDetectedChanged();
    void distanceCmChanged();

    void errorOccurred(QString error);

private slots:
    void readData();
    void handleError(QSerialPort::SerialPortError error);
    void checkConnection();

private:
    QSerialPort *m_serial;
    QTimer *m_connectionTimer;
    QByteArray m_buffer;

    // Data
    int m_speed;
    int m_rpm;
    float m_temperature;
    bool m_connected;

    bool m_leftSignal;
    bool m_rightSignal;
    bool m_dau;
    bool m_abs;
    bool m_denCavang;

    bool m_pha;
    bool m_dayAnToan;
    bool m_duongtron;

    bool m_denCanhbao;

    int m_xang;
    int m_apsuat;

    float m_tirePressureFL;
    float m_tirePressureFR;
    float m_tirePressureRL;
    float m_tirePressureRR;
    bool m_roadSlippery;
    bool m_obstacleDetected;
    int m_distanceCm;

    void parseJsonData(const QByteArray &data);
    void setConnected(bool status);
    void calculateRPMAndTemp();
};

#endif // DASHBOARDBACKEND_H
