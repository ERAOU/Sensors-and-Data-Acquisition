#define FRAME_START              0x8A
#define FRAME_ESCAPE_CHAR        0x8B
#define FRAME_XOR_CHAR           0x20
#define FRAME_NUM_EXTRA_BYTES    4 

#define LENGTH_INPUT_BUFFER      50
#define LENGTH_OUT_DATA_BUFFER   50
#define LENGTH_OUT_FRAME_BUFFER  60

#define BMS_ID 0x6B0
#define Hall_Effect_ID 0x7A5
#define Motor_Controller_ID 0x999

//byte g_InputBuffer[LENGTH_INPUT_BUFFER];            // Incoming data buffer
byte g_OutFrameBuffer[LENGTH_OUT_FRAME_BUFFER];     // Data buffer for output Frame
byte g_OutBuffer[LENGTH_OUT_DATA_BUFFER];           // Data buffer for output data
//byte g_ReceiverStatus = RCV_ST_IDLE;
byte g_xorValue = 0x00;
byte g_Checksum = 0;
int  g_DataLength = 0;
int  g_BufferIndex = 0;






//FOR TESTING
int counter =   0;
int BMS_LEN =   7;

//BMS
int SOC     = 100;
int APT     =   23; 
int HPT     =   34;
int PC      =   4;
int DCL     =   105;

//Hall Effect
int RPM     =   3000;
int SPEED   =   60;

//Motor Controller 
int MTMP = 40;
int THROT_POS = 0;

void setup() {
  // put your setup code here, to run once:
Serial.begin(115200);

}

void loop() {
SendMCMessage();
SendBMSMessage();
SendHEMessage();

switch (counter){
  
  case 10:
  RPM = CounterOffset(RPM,100,5000,true);
  SPEED = CounterOffset(SPEED,1,80,true);
  break;
  case 35:
  PC = CounterOffset(PC,1,150,true);
  DCL = CounterOffset(DCL,1,220,true);
  break;
  case 50:
  APT = CounterOffset(APT,1,60,true);
  HPT = CounterOffset(HPT,3,60,true);
  MTMP = CounterOffset(MTMP,2,50,true);
  break;
  case 100:
  RPM = CounterOffset(RPM,100,5000,true);
  SPEED = CounterOffset(SPEED,1,80,true);
  break;
  case 500:
  SOC = CounterOffset(SOC,1,100,false);
  break;
}
THROT_POS = counter/5;
if (counter >=500){
  counter = 0;
}
counter ++;
//Serial.println(SOC);
}


int CounterOffset(int value, int increment, int limit, bool posNeg){
  if (posNeg){

    if(value >= limit){
      value = 0;
    }
    else value = value + increment;
  }
  else{
   // Serial.println("Decrease");
    if (value <=0){
      value = limit;
    }
    else{
      value = value - increment;
    }
  }

return value;
    
}

void SendHEMessage(){
    g_OutFrameBuffer[0]  = FRAME_START                  ;                      // Start Frame
    g_OutFrameBuffer[1]  = (Hall_Effect_ID & 0xFF00) >>8;                     // ID
    g_OutFrameBuffer[2]  =  Hall_Effect_ID & 0x00FF     ;
    g_OutFrameBuffer[3]  = BMS_LEN &0xFF                ;                     // Length
    g_OutFrameBuffer[4]  = (RPM & 0xFF00) >> 8          ;
    g_OutFrameBuffer[5]  =  RPM & 0xFF                  ;
    g_OutFrameBuffer[6]  = (SPEED & 0xFF00) >> 8        ;
    g_OutFrameBuffer[7]  =  SPEED & 0xFF                ;
    g_OutFrameBuffer[8]  = 0                            ;
    g_OutFrameBuffer[9]  = 0                            ;
    g_OutFrameBuffer[10] = 0                            ;
    g_OutFrameBuffer[11] = CalculateChecksum(11)        ;                     // Checksum

    SendFrame(g_OutFrameBuffer, 12);
}


void SendBMSMessage(){
    g_OutFrameBuffer[0]  = FRAME_START           ;                   // Start Frame
    g_OutFrameBuffer[1]  = (BMS_ID & 0xFF00) >>8 ;                  // ID
    g_OutFrameBuffer[2]  =  BMS_ID & 0x00FF      ;
    g_OutFrameBuffer[3]  = BMS_LEN &0xFF         ;                  // Length
    g_OutFrameBuffer[4]  = SOC & 0xFF            ;
    g_OutFrameBuffer[5]  = APT & 0xFF            ;
    g_OutFrameBuffer[6]  = HPT & 0xFF            ;
    g_OutFrameBuffer[7]  = (PC & 0xFF00) >> 8    ;
    g_OutFrameBuffer[8]  = PC & 0x00FF           ;
    g_OutFrameBuffer[9]  = (DCL & 0xFF00) >> 8   ;
    g_OutFrameBuffer[10] = DCL & 0x00FF          ;
    g_OutFrameBuffer[11] = CalculateChecksum(11) ;                  // Checksum

    SendFrame(g_OutFrameBuffer, 12);
}

void SendMCMessage(){
    g_OutFrameBuffer[0]  =  FRAME_START                        ;                      // Start Frame
    g_OutFrameBuffer[1]  = (Motor_Controller_ID  & 0xFF00) >>8 ;                     // ID
    g_OutFrameBuffer[2]  =  Motor_Controller_ID  & 0x00FF      ;
    g_OutFrameBuffer[3]  =  BMS_LEN &0xFF                      ;                     // Length
    g_OutFrameBuffer[4]  =  MTMP & 0x00FF                      ;
    g_OutFrameBuffer[5]  =  THROT_POS & 0xFF                   ;
    g_OutFrameBuffer[6]  =  0                                  ;
    g_OutFrameBuffer[7]  =  0                                  ;
    g_OutFrameBuffer[8]  =  0                                  ;
    g_OutFrameBuffer[9]  =  0                                  ;
    g_OutFrameBuffer[10] =  0                                  ;
    g_OutFrameBuffer[11] =  CalculateChecksum(11)              ;                     // Checksum

    SendFrame(g_OutFrameBuffer, 12);
}

void SendFrame(byte* pFrameBuff, int length)
{
    int i;
    byte dataToSend = 0;

    g_OutBuffer[dataToSend++] = FRAME_START;

    for(i = 1; i < length; i++)
    {
        if(pFrameBuff[i] == FRAME_START || pFrameBuff[i] == FRAME_ESCAPE_CHAR)
        {
            g_OutBuffer[dataToSend++] = FRAME_ESCAPE_CHAR;
            g_OutBuffer[dataToSend++] = pFrameBuff[i] ^ FRAME_XOR_CHAR;
        } else
            g_OutBuffer[dataToSend++] = pFrameBuff[i];
    }
    
    Serial.write(g_OutBuffer, dataToSend);
}
byte CalculateChecksum(byte length)
{
    byte rv = 0, index;
    for(index = 0; index < length; index++)
    {
        rv += g_OutFrameBuffer[index];
    }
    return rv;
}
