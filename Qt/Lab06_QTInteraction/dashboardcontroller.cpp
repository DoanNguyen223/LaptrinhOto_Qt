#include "dashboardcontroller.h"
#include <QDebug>

DashboardController::DashboardController(QObject *parent)
    : QObject(parent),
    m_tachoAngle(-120), m_speedAngle(-120)
{
}

void DashboardController::updateTachoValue(double value)
{
    // Slider 0 → 200 tương ứng 0 → 8 (vòng tua)
    m_tachoAngle = convertSliderToAngle(value, 0, 200, -120, 120);
    emit tachoAngleChanged();
    qDebug() << "Tacho updated:" << m_tachoAngle;
}

void DashboardController::updateSpeedValue(double value)
{
    m_speedAngle = convertSliderToAngle(value, 0, 200, -120, 120);
    emit speedAngleChanged();
    qDebug() << "Speed updated:" << m_speedAngle;
}

void DashboardController::toggleButtonState(const QString &buttonName)
{
    bool state = !m_buttonStates.value(buttonName, false);
    m_buttonStates[buttonName] = state;

    emit buttonStateChanged(buttonName, state);
    qDebug() << buttonName << "is now" << (state ? "ON" : "OFF");
}

double DashboardController::convertSliderToAngle(double value,
                                                 double minValue, double maxValue,
                                                 double minAngle, double maxAngle)
{
    double ratio = (value - minValue) / (maxValue - minValue);
    return minAngle + ratio * (maxAngle - minAngle);
}
