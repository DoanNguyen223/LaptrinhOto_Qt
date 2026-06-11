#ifndef DASHBOARDCONTROLLER_H
#define DASHBOARDCONTROLLER_H

#include <QHash>
#include <QObject>
#include <QString>

class DashboardController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double tachoAngle READ tachoAngle NOTIFY tachoAngleChanged)
    Q_PROPERTY(double speedAngle READ speedAngle NOTIFY speedAngleChanged)

public:
    explicit DashboardController(QObject *parent = nullptr);

    // Giá trị góc kim
    double tachoAngle() const { return m_tachoAngle; }
    double speedAngle() const { return m_speedAngle; }

    // --- Cập nhật từ QML ---
    Q_INVOKABLE void updateTachoValue(double value);   // 0 -> 200
    Q_INVOKABLE void updateSpeedValue(double value);   // 0 -> 200
    Q_INVOKABLE void toggleButtonState(const QString &buttonName);

signals:
    void tachoAngleChanged();
    void speedAngleChanged();
    void buttonStateChanged(QString buttonName, bool state);

private:
    double m_tachoAngle;
    double m_speedAngle;

    // Trạng thái các nút
    QHash<QString, bool> m_buttonStates;

    // Hàm chuyển đổi giá trị slider -> góc quay
    double convertSliderToAngle(double value, double minValue, double maxValue,
                                double minAngle, double maxAngle);
};

#endif // DASHBOARDCONTROLLER_H
