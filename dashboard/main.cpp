/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "SerialManager.h"
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QSerialPort>
#include <QQmlContext>
int soc, apt, hpt, pc,dcl,rpm,speed, mtmp, tpos;
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    SerialManager serialManager;

    QSerialPort serialPort;
    serialPort.setPortName("COM6"); // Adjust the port name
    serialPort.setBaudRate(QSerialPort::Baud115200); // Set the baud rate
    serialPort.setDataBits(QSerialPort::Data8); // Set data bits
   serialPort.setParity(QSerialPort::NoParity); // Set parity
   serialPort.setStopBits(QSerialPort::OneStop); // Set stop bits

   if (serialPort.open(QIODevice::ReadOnly)) {
        // Serial port opened successfully
    } else {
        // Handle error
    }


    QFontDatabase::addApplicationFont(":/fonts/DejaVuSans.ttf");
    app.setFont(QFont("DejaVu Sans"));

    QQmlApplicationEngine engine(QUrl("qrc:/qml/dashboard.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;



    engine.rootContext()->setContextProperty("serialData", QVariant::fromValue(QString()));

    QObject::connect(&serialPort, &QSerialPort::readyRead, [&]() {
        QByteArray startByte = serialPort.read(1);
         QByteArray data;

        if (startByte == QByteArray::fromHex("8A")) // Adjust the start byte value
        {
            data = serialPort.read(11); // Read the remaining 11 bytes

            int MSG_ID = (quint16(data[0])*256) + quint8(data[1]);
            if(MSG_ID == 1712){
                //qDebug() << "BMS Mesage Receive";
                soc = quint8(data[3]);
                apt = quint8(data[4]);
                hpt = quint8(data[5]);
                pc = (quint16(data[6])*256) + quint8(data[7]);
                dcl = (quint16(data[8])*256) + quint8(data[9]);
            }
            else if (MSG_ID == 1957){
                rpm   = ((quint16(data[3])*256) + quint8(data[4]));
                speed = (quint16(data[5])*256) + quint8(data[6]);
            }
            else if(MSG_ID == 2457){
                mtmp = quint8(data[3]);
                tpos = quint8(data[4]);
            }
        }

       //Update the context property
       engine.rootContext()->setContextProperty("SOC", soc);
       engine.rootContext()->setContextProperty("AvgPackTemp",  apt);
       engine.rootContext()->setContextProperty("HighPackTemp", hpt);
       engine.rootContext()->setContextProperty("PackCurrent", pc);
       engine.rootContext()->setContextProperty("DischargeCurrentLimit", dcl);
       engine.rootContext()->setContextProperty("RPM", rpm);
       engine.rootContext()->setContextProperty("SPEED", speed);
       engine.rootContext()->setContextProperty("MTEMP", mtmp);
       engine.rootContext()->setContextProperty("THROTPOS", tpos);
       qDebug() << tpos;
   });

   // engine.rootContext()->setContextProperty(serialManager, &serialManager);

    const QUrl url(QStringLiteral("qrc:/qml/dashboard.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
