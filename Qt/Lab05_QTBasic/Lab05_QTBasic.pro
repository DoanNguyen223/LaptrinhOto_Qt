QT += quick quickcontrols2

CONFIG += c++17 console
CONFIG -= app_bundle

SOURCES += \
    main.cpp

RESOURCES += \
    qml.qrc \
    resources.qrc

# Optional: bật debug message trong QML
DEFINES += QT_DEPRECATED_WARNINGS

# Giúp Qt Creator nhận QML import paths
QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

# Đường dẫn cài đặt khi build release
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
