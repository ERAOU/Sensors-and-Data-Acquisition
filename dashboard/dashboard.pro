TEMPLATE = app
TARGET = dashboard
INCLUDEPATH += .
QT += quick
QT += serialport

SOURCES += \
    SerialManager.cpp \
    main.cpp

RESOURCES += \
    dashboard.qrc

OTHER_FILES += \
    qml/dashboard.qml \
    qml/DashboardGaugeStyle.qml \
    qml/IconGaugeStyle.qml \
    qml/TachometerStyle.qml \
    qml/TurnIndicator.qml \
    qml/ValueSource.qml

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/extras/dashboard
INSTALLS += target

HEADERS += \
    SerialManager.h

DISTFILES += \
    qml/ValueSource_copy.qml
