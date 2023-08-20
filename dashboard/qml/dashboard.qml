import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3

Window {
    id: root
    visible: true
    width: 800
    height: 480
    color: "#222222"
    flags: Qt.FramelessWindowHint



    //Left Side SpeedoMeter
        CircularGauge {
            id: speedometer
            value: SPEED
            anchors.verticalCenter:parent.verticalCenter
            anchors.horizontalCenter: parent.left
            anchors.leftMargin: 100
            maximumValue: 90
            width: height
            height: parent.height
            style: DashboardGaugeStyle {}
        }

    //Center Data Section
        Rectangle{
            id:dataDisp
            width: height/1.5
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            color:"transparent"

    // Throttle Section
                Rectangle{
                    id:throttleBox
                    width: parent.width*1.5
                    height: parent.height/10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 0.3
                    color:"transparent"

    // Throttle Header Text -- Turns Red at 80%
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 10
                        text:"THROTTLE POSITION"
                        color:THROTPOS < 80 ? "white": "red"
                        anchors.top: parent.top
                        anchors.topMargin: 10
                    }
    // Throttle White Border - Static
                    Rectangle{
                        width: parent.width +2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
                        height: parent.height/3 + 2
                        color:"transparent"
                        border.color: "white"
                    }

    // Throttle - Turns Red at 80%
                    Rectangle{
                        id:throttle
                        width: parent.width*(THROTPOS/100)
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        height: parent.height/3
                        color: THROTPOS < 80 ? "grey" :"red"
                    }
                }

    // Warning Section
                Rectangle{
                    id:warningBox
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/3
                    anchors.top: throttleBox.bottom
                    anchors.topMargin: 5
                    color: "transparent"
                    border.color: "white"

                    Text{
                        id:warningLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 20
                        text:"MESSAGES"
                        color:"grey"
                        anchors.top: parent.top
                        anchors.topMargin: 10
                    }
                    Text{
                        id:errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 20
                        text:HighPackTemp >50 ?"SINGLE BATTERY OVER TEMP" :""
                        color:HighPackTemp >50 ?"red":"white"
                        anchors.top: warningLabel.bottom
                        anchors.topMargin: 5
                    }

    //Lap Time
                    Text{
                        id:lapTime
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 15
                        text:"LAP TIME: " + valueSource.lapTime.toFixed(3) + "s"
                        color:"white"
                        anchors.top: errorMessage.bottom
                        anchors.topMargin: 5
                    }

    //Overall Time
                    Text{
                        id:overallTime
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 15
                        text:"OVERALL TIME: " + valueSource.overallTime.toFixed(3)
                        //text:"OVERALL TIME: " + Math.round(valueSource.overallTime*100)/100
                        color:"white"
                        anchors.top: lapTime.bottom
                    }
                    Text{
                        id:current
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 15
                        text:"CURRENT: " + PackCurrent + "A"
                        color:"white"
                        anchors.top: overallTime.bottom
                    }
                    Text{
                        id:currentLimit
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 15
                        text:"CURRENT LIMIT: " + DischargeCurrentLimit + "A"
                        color:"white"
                        anchors.top: current.bottom
                    }




                    Text{
                        id:drivingMode
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 15
                        text:"<font color=\"#ffffff\">%1</font>%2".arg("DRIVING MODE: ").arg(valueSource.drivingMode)
                        color:valueSource.drivingMode === "RACE" ? "green": "white"
                        anchors.top:currentLimit.bottom
                    }


                }

    // Speed Section
                Rectangle{
                    id:speed
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/3
                    anchors.top: warningBox.bottom
                    color: "#222222"

    // Speed - Goes Red at 100MPH

                    Text{
                      id:speedTxt
                      anchors.horizontalCenter: parent.horizontalCenter
                      anchors.verticalCenter: parent.verticalCenter
                      font.pixelSize: 100
                      text:SPEED
                      color: SPEED < 70 ? "white": "red"
                      anchors.top: warningBox.bottom
                    }

    // Speed Unit - Static - Goes Red at 100MPH
                    Text{
                      id:speedmarkerTxt
                      anchors.horizontalCenter: parent.horizontalCenter
                      anchors.verticalCenter: parent.verticalCenter
                      anchors.topMargin: -10
                      font.pixelSize: 20
                      text:"MPH"
                      color:SPEED < 70 ? "white": "red"
                      anchors.top: speedTxt.bottom

                    }
                  }

    //RPM Section
                Rectangle{
                    id:rpm
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/10
                    anchors.top: speed.bottom
                    color: "#222222"

    //RPM Text - Turns Red at 6000 RPM
                    Text{
                        id:rpmTxt
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 30
                        text:(RPM/1000) + " x 1000 RPM"
                        color: RPM < 5000 ? "white": "red"
                        anchors.topMargin: -10
                    }
                }

    //Motor & Battery Temp & SOC Section
                Rectangle{
                    id:lights
                    width: parent.width *1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height/8
                    anchors.bottom: parent.bottom
                    color: "transparent"



    //Motor Temp Container
                    Rectangle{
                        id:motorTemp
                        width: parent.width/ 3

                        height: parent.height
                        color: "transparent"

                        Text{
                            id:motorTempTxt
                            font.pixelSize: 40
                            text:MTEMP
                            color: MTEMP < 60 ? "white": "red"
                        }
                        Text{
                            id:motorCirc
                            font.pixelSize: 5
                            anchors.left: motorTempTxt.right
                            anchors.top: motorTempTxt.top
                            anchors.topMargin: 5
                            text:"o"
                            color: MTEMP < 60 ? "white": "red"
                         }
                        Text{
                            id:motorUnitTxt
                            font.pixelSize: 10
                            anchors.left: motorCirc.right
                            anchors.top: motorTempTxt.top
                            anchors.topMargin: 5
                            text:"C"
                            color: MTEMP < 60 ? "white": "red"
                         }
                        Text{
                            id:motorBlock
                             anchors.top:motorTempTxt.bottom
                             anchors.topMargin: -5
                            font.pixelSize: 13
                            text:"MOTOR"
                            color: MTEMP < 60 ? "white": "red"

                        }
                        Image{
                            id:motorTempIconBlue
                        anchors.verticalCenter: parent.verticalCenter
                             height:parent.height
                             width:parent.height
                             anchors.left: motorBlock.right
                        source: "../images/thermometer-blue.svg"
                        visible: MTEMP <60 ? true : false
                        }

                        Image{
                            id:motorTempIconRed
                        anchors.verticalCenter: parent.verticalCenter
                             height:parent.height
                             width:parent.height
                             anchors.left: motorBlock.right
                        source: "../images/thermometer-red.svg"
                        visible: MTEMP >=60 ? true : false
                        }
                    }

    //Battery Temp Container
                    Rectangle{
                        id:batteryTemp
                        width: parent.width/ 3
                   //     anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height
                       color: "transparent"

                       Text{
                           id:batTempTxt
                           font.pixelSize: 40
                           text:AvgPackTemp
                           color: AvgPackTemp < 50 ? "white": "red"


                       }
                       Text{
                           id:batCirc
                           font.pixelSize: 5
                           anchors.left: batTempTxt.right
                           anchors.top: batTempTxt.top
                           anchors.topMargin: 5
                           text:"o"
                           color: AvgPackTemp < 50 ? "white": "red"
                        }
                       Text{
                           id:batUnitTxt
                           font.pixelSize: 10
                           anchors.left: batCirc.right
                           anchors.top: batTempTxt.top
                           anchors.topMargin: 5
                           text:"C"
                           color: AvgPackTemp < 50 ? "white": "red"
                        }
                       Text{
                           id:batBlock
                            anchors.top:batTempTxt.bottom
                            anchors.topMargin: -5
                           font.pixelSize: 13
                           text:"BATTERY"
                           color: AvgPackTemp < 50 ? "white": "red"

                       }
                       Image{
                           id:batTempIconBlue
                       anchors.verticalCenter: parent.verticalCenter
                            height:parent.height
                            width:parent.height
                            anchors.left: batBlock.right
                       source: "../images/thermometer-blue.svg"
                       visible: AvgPackTemp <50 ? true : false
                       }

                       Image{
                           id:batTempIconRed
                       anchors.verticalCenter: parent.verticalCenter
                            height:parent.height
                            width:parent.height
                            anchors.left: batBlock.right
                       source: "../images/thermometer-red.svg"
                       visible: AvgPackTemp >50 ? true : false
                       }


                    }

    //State Of Charge Container
                    Rectangle{
                        id:stateOfCharge
                        width: parent.width/ 3
                    //    anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        height: parent.height
                        color: "transparent"

                        Text{
                            id:stateOfChargeTxt
                            font.pixelSize: 40
                            text:SOC + "%"
                            color: SOC > 30 ? "white": "red"


                        }
                        Text{
                            id:chargeBlock
                             anchors.top:stateOfChargeTxt.bottom
                             anchors.topMargin: -10
                            font.pixelSize: 20
                            text:"CHARGE"
                            color: SOC > 30 ? "white": "red"

                        }
                        Image{
                            id:chargeIconBlue
                        anchors.verticalCenter: parent.verticalCenter
                             height:parent.height
                             width:parent.height
                             anchors.left: chargeBlock.right
                        source: "../images/charge-green.svg"
                        visible: SOC >30 ? true : false
                        }
                        Image{
                            id:chargeIconRed
                        anchors.verticalCenter: parent.verticalCenter
                             height:parent.height
                             width:parent.height
                             anchors.left: chargeBlock.right
                        source: "../images/charge-red.svg"
                        visible: SOC <=30 ? true : false
                        }


                    }
                }

        }

    //Right Side RPM Gauge
        CircularGauge {
            id: tachometer
            width: height
            height: parent.height
            value: RPM/1000
            maximumValue: 8
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.right
            anchors.horizontalCenterOffset: 5
            style: TachometerStyle {}
        }

    }


