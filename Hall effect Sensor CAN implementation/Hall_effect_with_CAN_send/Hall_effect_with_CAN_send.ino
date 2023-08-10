//==================================================================================//

#include <CAN.h>

#define TX_GPIO_NUM   21  // Connects to CTX
#define RX_GPIO_NUM   22  // Connects to CRX
//#define hallPin       36
const int hallPin = 19;   // Hall effect sensor pin
const int numMagnets = 6; 
const float diskDiameter = 0.2794; // 11 inches converted to meters
const float conversionFactor = 2.23694; // Conversion factor from m/s to mph

volatile unsigned int pulseCount = 0;
unsigned long lastUpdateTime = 0;
unsigned int rpm = 0;
const float diskCircumference = PI * diskDiameter;

//==================================================================================//

// Interrupt service routine for Hall effect sensor
void IRAM_ATTR hallInterrupt() {
  pulseCount++;
}

void setup() {
  Serial.begin (115200);
  pinMode(hallPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(hallPin), hallInterrupt, FALLING);
  while (!Serial);
  delay (1000);

  Serial.println ("CAN Receiver/Receiver");

  // Set the pins
  CAN.setPins (RX_GPIO_NUM, TX_GPIO_NUM);

  // start the CAN bus at 500 kbps
  if (!CAN.begin (500E3)) {
    Serial.println ("Starting CAN failed!");
    while (1);
  }
  else {
    Serial.println ("CAN Initialized");
  }
}

//==================================================================================//

void loop() {
  int x = rpms();
  canSender(x);
  float y = rpm_to_mph(x);
  canSender(y);
  //canReceiver();
}

//==================================================================================//

void canSender(int rpmz) {
  // send packet: id is 11 bits, packet can contain up to 8 bytes of data
  Serial.print ("Sending packet ... ");
  
  //CAN.beginPacket (0x12);  //sets the ID and clears the transmit buffer
  CAN.beginExtendedPacket(0xabcdef);
  String numStr = String(rpmz);  // Convert integer to string
  for(int i=0; i<numStr.length(); i++) {  // Iterate over each character in string
    char c = numStr.charAt(i);  // Get the character
    CAN.write(c);  // Print the character
  }
  CAN.endPacket();

  //RTR packet with a requested data length
  /*CAN.beginPacket (0x12, 3, true);
  CAN.endPacket();*/

  Serial.println ("done");

  delay (100);
}

//==================================================================================//

void canReceiver() {
  // try to parse packet
  int packetSize = CAN.parsePacket();

  if (packetSize) {
    // received a packet
    Serial.print ("Received ");

    if (CAN.packetExtended()) {
      Serial.print ("extended ");
    }

    if (CAN.packetRtr()) {
      // Remote transmission request, packet contains no data
      Serial.print ("RTR ");
    }

    Serial.print ("packet with id 0x");
    Serial.print (CAN.packetId(), HEX);

    if (CAN.packetRtr()) {
      Serial.print (" and requested length ");
      Serial.println (CAN.packetDlc());
    } else {
      Serial.print (" and length ");
      Serial.println (packetSize);

      // only print packet data for non-RTR packets
      while (CAN.available()) {
        Serial.print ((char) CAN.read());
      }
      Serial.println();
    }

    Serial.println();
  }
}

int rpms()
{
  if (millis() - lastUpdateTime >= 1000) {
    detachInterrupt(digitalPinToInterrupt(hallPin)); // Disable interrupt while calculating RPM
    
    rpm = (pulseCount * 60) / (numMagnets); // Calculate RPM
    
    pulseCount = 0; // Reset pulse count
    
    lastUpdateTime = millis(); // Update last update time
    
    attachInterrupt(digitalPinToInterrupt(hallPin), hallInterrupt, FALLING); // Re-enable interrupt
  }

  // Print RPM
  Serial.print("RPM: ");
  Serial.println(rpm);
  return rpm;
}

//==================================================================================//

float rpm_to_mph(int rpmz)
{
  float rps = rpmz/60;
  float speed_mps = rps * diskCircumference; 
  float speed_mph = speed_mps * conversionFactor;  // Convert m/s to mph
  return speed_mph;
}
