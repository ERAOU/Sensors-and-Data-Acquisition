#include "SerialManager.h"
#include "qdebug.h"

SerialManager::SerialManager(QObject *parent) : QObject(parent)
{
    connect(&m_serialPort, &QSerialPort::readyRead, this, &SerialManager::readData);
}

void SerialManager::openSerialPort(const QString &portName, int baudRate)
{
    m_serialPort.setPortName("COM6");
    m_serialPort.setBaudRate(QSerialPort::Baud115200); // Set the baud rate

    if (m_serialPort.open(QIODevice::ReadWrite)) {
        qDebug() << "Serial port opened";
    } else {
        qWarning() << "Failed to open serial port";
    }
}

void SerialManager::closeSerialPort()
{
    m_serialPort.close();
    qDebug() << "Serial port closed";
}

void SerialManager::readData()
{
    QByteArray startByte = m_serialPort.read(1);
    QByteArray data;
    if (startByte == QByteArray::fromHex("8A")) // Adjust the start byte value
    {
        data = m_serialPort.read(11); // Read the remaining 11 bytes

        int MSG_ID = (quint16(data[0])*256) + quint8(data[1]);
        if(MSG_ID == 1712){
            //qDebug() << "BMS Mesage Receive";
           SOC = (quint8(data[2]));
           BattTemp = (quint8(data[3]));
           BattHightestTemp = (quint8(data[4]));
           Curr = ((quint16(data[5])*256) + quint8(data[6]));
           CurrLimit = ((quint16(data[7])*256) + quint8(data[8]));
        }
        else if (MSG_ID == 1957){
           RPM = ((quint16(data[2])*256) + quint8(data[3]));
           Speed = ((quint16(data[4])*256) + quint8(data[5]));
        }
    }

}

