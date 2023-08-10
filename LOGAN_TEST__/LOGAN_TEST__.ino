void setup() {
  Serial.begin(115200);

  // Initialize the random seed
  randomSeed(analogRead(0));

  // Create a character array to hold the 20 hexadecimal numbers
  char hexString[20]; // 20 characters plus the null terminator

  // First four characters are always the same
  hexString[0] = 'A';
  hexString[1] = 'B';
  hexString[2] = 'C';
  hexString[3] = 'D';

  // Generate the remaining 16 random hexadecimal characters
  for(int i = 4; i < 20; i++) {
    int randomValue = random(16);
    if (randomValue < 10) {
      hexString[i] = '0' + randomValue;
    } else {
      hexString[i] = 'A' + (randomValue - 10);
    }
  }

  // Print the hexadecimal string to the serial monitor
  Serial.println(hexString);
}

void loop() {
  // Nothing to do here
}
