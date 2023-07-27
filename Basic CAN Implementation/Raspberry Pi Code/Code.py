import serial
import time
import requests

ser = serial.Serial('/dev/ttyUSB1', 115200)
THINGSPEAK_CHANNEL_ID = 2212949
THINGSPEAK_WRITE_API_KEY = 'IJLXHVDLGI4SCEE3'

while True:
    if ser.in_waiting > 0:
        line = ser.readline().decode('utf-8').rstrip()
        print(f'Recieved: {line}')

        #respone = requests.post(f'https://api.thingspeak.com/update?api_key={THINGSPEAK_WRITE_API_KEY}&field1={line}')
        #if respone.status_code == 200:
        #    print('Data has been sent to ThingSpeak')
        #else:
        #    print('Failed to send data to ThingSpeak')
        time.sleep(1)