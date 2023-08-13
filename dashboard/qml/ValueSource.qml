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

import QtQuick 2.2

//! [0]
Item {
    id: valueSource
    property string drivingMode: "RACE"
    property string fanMode: "DISABLED"
    property real currentLimit: 100
    property real overallTime: 0
    property real lapTime: 0
    property real kph: 0
    property real batTemp: 40
    property real motorTemp: 40
    property real stateOfCharge: 100
    property double rpm: 0
    property real throttle: 0
    property real fuel: 0.85
    property string gear: {
        var g;
        if (kph == 0) {
            return "P";
        }
        if (kph < 30) {
            return "1";
        }
        if (kph < 50) {
            return "2";
        }
        if (kph < 80) {
            return "3";
        }
        if (kph < 120) {
            return "4";
        }
        if (kph < 160) {
            return "5";
        }
    }
    property int turnSignal: gear == "P" && !start ? randomDirection() : -1
    property real temperature: 0.6
    property bool start: true


//! [0]

    function randomDirection() {
        return Math.random() > 0.5 ? Qt.LeftArrow : Qt.RightArrow;
    }

    SequentialAnimation {
        running: true
        loops: 1

        // We want a small pause at the beginning, but we only want it to happen once.
        PauseAnimation {
            duration: 1000
        }

        PropertyAction {
            target: valueSource
            property: "start"
            value: false
        }

        SequentialAnimation {
            loops: Animation.Infinite
//! [1]
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    from: 0
                    to: 30
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    from: 0
                    to: 100
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    from: 0
                    to: 6.1
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 95
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "batTemp"
                    easing.type: Easing.InOutSine
                    to: 47
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "motorTemp"
                    easing.type: Easing.InOutSine
                    to: 55
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 3
                    duration: 3000

                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 3
                    duration: 3000

                }
            }

//! [1]
            ParallelAnimation {
                // We changed gears so we lost a bit of speed.
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    from: 30
                    to: 26
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    from: 100
                    to: 50
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    from: 6
                    to: 2.4
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 94
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 3.6
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 3.6
                    duration: 600
                }

            }
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 60
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    to: 100
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 5.6
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 92
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "batTemp"
                    easing.type: Easing.InOutSine
                    to: 49
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "motorTemp"
                    easing.type: Easing.InOutSine
                    to: 55
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 6.6
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 6.6
                    duration: 3000
                }
            }
            ParallelAnimation {
                // We changed gears so we lost a bit of speed.
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 56
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    from: 0
                    to: 50
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 2.3
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 90
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 7.2
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 7.2
                    duration: 600
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 100
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    to: 100
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 5.1
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 85
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "batTemp"
                    easing.type: Easing.InOutSine
                    to: 52
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "motorTemp"
                    easing.type: Easing.InOutSine
                    to: 44
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 10.8
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 10.8
                    duration: 3000
                }
            }
            ParallelAnimation {
                // We changed gears so we lost a bit of speed.
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 96
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 2.2
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 84
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 11.4
                    duration: 600
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    from:0
                    to: 0.6
                    duration: 600
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 140
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 6.2
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 80
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "batTemp"
                    easing.type: Easing.InOutSine
                    to: 43
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "motorTemp"
                    easing.type: Easing.InOutSine
                    to: 49
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 14.4
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 3.6
                    duration: 3000
                }
            }

            // Start downshifting.

            // Fifth to fourth gear.
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.Linear
                    to: 100
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    to: 60
                    duration: 5000
                }

                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 3.1
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 70
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "batTemp"
                    easing.type: Easing.InOutSine
                    to: 55
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "motorTemp"
                    easing.type: Easing.InOutSine
                    to: 65
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 19.4
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    to: 8.6
                    duration: 5000
                }
            }

            ParallelAnimation {
            // Fourth to third gear.
            NumberAnimation {
                target: valueSource
                property: "rpm"
                easing.type: Easing.InOutSine
                to: 5.5
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "stateOfCharge"
                easing.type: Easing.InOutSine
                to: 65
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "overallTime"
                to: 20.0
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "lapTime"
                to: 9.2
                duration: 600
            }
}
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 60
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    to: 30
                    duration: 3000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 2.6
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "stateOfCharge"
                    easing.type: Easing.InOutSine
                    to: 55
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "batTemp"
                    easing.type: Easing.InOutSine
                    to: 47
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "motorTemp"
                    easing.type: Easing.InOutSine
                    to: 54
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "overallTime"
                    to: 25.0
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "lapTime"
                    from:0
                    to: 5
                    duration: 5000
                }
            }
ParallelAnimation {
            // Third to second gear.
            NumberAnimation {
                target: valueSource
                property: "rpm"
                easing.type: Easing.InOutSine
                to: 6.3
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "overallTime"
                to: 25.6
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "lapTime"
                to: 5.6
                duration: 600
            }
}
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 30
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "throttle"
                    easing.type: Easing.InOutSine
                    to:0
                    duration: 1000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 2.6
                    duration: 5000
                }
           NumberAnimation {
               target: valueSource
               property: "stateOfCharge"
               easing.type: Easing.InOutSine
               to: 45
               duration: 5000
           }
           NumberAnimation {
               target: valueSource
               property: "batTemp"
               easing.type: Easing.InOutSine
               to: 45
               duration: 5000
           }
           NumberAnimation {
               target: valueSource
               property: "motorTemp"
               easing.type: Easing.InOutSine
               to: 49
               duration: 5000
           }
           NumberAnimation {
               target: valueSource
               property: "overallTime"
               to: 30.6
               duration: 5000
           }
           NumberAnimation {
               target: valueSource
               property: "lapTime"
               to: 10.6
               duration: 5000
           }
            }
ParallelAnimation {
            NumberAnimation {
                target: valueSource
                property: "rpm"
                easing.type: Easing.InOutSine
                to: 6.5
            duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "stateOfCharge"
                easing.type: Easing.InOutSine
                to: 43
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "overallTime"
                to: 31.2
                duration: 600
            }
            NumberAnimation {
                target: valueSource
                property: "lapTime"
                to: 11.2
                duration: 600
            }
            }

            // Second to first gear.
            ParallelAnimation {
                NumberAnimation {
                    target: valueSource
                    property: "kph"
                    easing.type: Easing.InOutSine
                    to: 0
                    duration: 5000
                }
                NumberAnimation {
                    target: valueSource
                    property: "rpm"
                    easing.type: Easing.InOutSine
                    to: 0
                    duration: 4500
                }
            NumberAnimation {
                target: valueSource
                property: "stateOfCharge"
                easing.type: Easing.InOutSine
                to: 25
                duration: 4500
            }
            NumberAnimation {
                target: valueSource
                property: "batTemp"
                easing.type: Easing.InOutSine
                to: 45
                duration: 4500
            }
            NumberAnimation {
                target: valueSource
                property: "motorTemp"
                easing.type: Easing.InOutSine
                to: 61
                duration: 4500
            }
            NumberAnimation {
                target: valueSource
                property: "overallTime"
                to: 35.7
                duration: 4500
            }
            NumberAnimation {
                target: valueSource
                property: "lapTime"
                from:0
                to: 4.5
                duration: 4500
            }
            }

            PauseAnimation {
                duration: 5000
            }
        }
    }
}
