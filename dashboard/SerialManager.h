#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include "QtSerialPort/qserialport.h"
#include <QObject>
#include <QSerialPort>

class SerialManager : public QObject
{
    Q_OBJECT
public:
    explicit SerialManager(QObject *parent = nullptr);

public slots:
    void openSerialPort(const QString &portName, int baudRate);
    void closeSerialPort();
    void readData();

private:
    //void dataReceived(const QString &data);
    int Speed ;
    int RPM ;
    int SOC ;
    int BattTemp;
    int BattHightestTemp;
    int MotorTemp;
    int Throttle ;
    int CurrLimit;
    int Curr ;
    //void FanMode (const qint16 &data);
    //void DrivingMode (const qint16 &data);
    QSerialPort m_serialPort;
};

#endif // SERIALMANAGER_H
