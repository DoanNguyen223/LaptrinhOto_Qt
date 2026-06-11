#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QTimer>
#include "radialbar.h"
#include "DashboardBackend.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    qDebug() << "=== Dashboard Application Starting ===";

    DashboardBackend myBackend;

    // Debug connections
    QObject::connect(&myBackend, &DashboardBackend::speedChanged, [&]() {
        qDebug() << "🚗 Speed:" << myBackend.speed();
    });

    QObject::connect(&myBackend, &DashboardBackend::connectedChanged, [&]() {
        qDebug() << "🔌" << (myBackend.connected() ? "CONNECTED ✓" : "DISCONNECTED ✗");
    });

    QObject::connect(&myBackend, &DashboardBackend::errorOccurred, [](const QString &error) {
        qDebug() << "❌ Error:" << error;
    });

    // ✅ AUTO-RETRY CONNECTION
    QTimer *retryTimer = new QTimer(&app);
    QObject::connect(retryTimer, &QTimer::timeout, [&]() {
        if (!myBackend.connected()) {
            qDebug() << "🔄 Retrying connection...";
            myBackend.connectSerial();
        } else {
            qDebug() << "✓ Connection stable";
        }
    });
    retryTimer->start(5000);  // Retry every 5 seconds

    // Lần kết nối đầu tiên sau 1 giây
    QTimer::singleShot(1000, [&]() {
        qDebug() << "📡 Attempting initial connection...";
        myBackend.connectSerial();
    });

    // QML Engine
    QQmlApplicationEngine engine;
    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    engine.rootContext()->setContextProperty("carSystem", &myBackend);

    qDebug() << "📦 Loading QML...";
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl) {
                             qDebug() << "❌ Failed to load QML!";
                             QCoreApplication::exit(-1);
                         } else {
                             qDebug() << "✓ QML loaded successfully";
                         }
                     }, Qt::QueuedConnection);

    engine.load(url);

    qDebug() << "🚀 Application running...";
    qDebug() << "\n=== Available Serial Ports ===";
    QStringList ports = myBackend.getAvailablePorts();
    if (ports.isEmpty()) {
        qDebug() << "⚠️  No serial ports found!";
        qDebug() << "Please connect ESP8266 via USB";
    } else {
        for (const QString &port : ports) {
            qDebug() << "   -" << port;
        }
    }
    qDebug() << "==============================\n";

    return app.exec();
}
