#include <Servo.h>
Servo RPMServo;
volatile boolean fire = false;
volatile int rpm;
volatile int dwell = 1000;
volatile float timing;
volatile float newmicros;
volatile float oldmicros;
volatile long newmillis;
volatile long oldmillis;
volatile float lag;
int pos;


void setup()
{
  pinMode(3,OUTPUT);
  attachInterrupt(0, pulse, FALLING);
  RPMServo.attach(9);
  Serial.begin(115200);
}


void loop()
{
  
  newmillis = millis();
   
   if ((newmillis - oldmillis) > 250) {
    pos = map(rpm, 0, 6000, 14, 170);
    RPMServo.write(pos);
    Serial.print("RPM: ");
    Serial.print(rpm);
    Serial.print(" timing: ");
    Serial.print(timing);
    Serial.print("  lag: ");
    Serial.println(lag);
    oldmillis = newmillis;
 }
 
   if ((micros() - newmicros) > 500000L) {  
    newmicros = micros();
    rpm = 0;
    lag = 0;
    timing = 0;
  }
  
  if (fire) {
    rpm = (60000000L/(newmicros - oldmicros));
    lag = ((((newmicros - oldmicros) / 360) * timing) - dwell);   
    oldmicros = newmicros;     
    delayMicroseconds(lag);
    digitalWrite(3,HIGH);
    delayMicroseconds(dwell);
    digitalWrite(3,LOW);
    fire=false;
  }
}

void pulse()
{
  newmicros = micros();
  timing = analogRead(1) / 2.85F;
  
    if ((newmicros - oldmicros) > 500000L)
  {  
    oldmicros = newmicros;
  }
else
  {
    fire = true;
  }
}
