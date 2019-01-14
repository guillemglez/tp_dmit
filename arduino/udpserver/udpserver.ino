#include <WiFiNINA.h>
#include <WiFiUdp.h>
#include "Adafruit_Si7021.h"

#define BUFFER_SIZE 40

IPAddress broadcastIP(192,168,0,255);
char ssid[] = "TP_DMIT";
char pwd[] = "dmit3ATP";
byte mac[6];
int status = WL_IDLE_STATUS;
float tempBuffer[BUFFER_SIZE];
float humBuffer[BUFFER_SIZE];
WiFiClient wifi;

unsigned int localPort = 4321;      // local port to listen on

char packetBuffer[255]; //buffer to hold incoming packet
char  ReplyBuffer[] = "Message reçu";       // a string to send back
Adafruit_Si7021 sensor = Adafruit_Si7021();

WiFiUDP Udp;
unsigned long lastTime;
unsigned long lastLog;
int countValues = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while (!Serial){}

  // check for the WiFi module:
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    // don't continue
    while (true);
  }
  
  if (!sensor.begin()) {
    Serial.println("Did not find Si7021 sensor!");
    while (true)
      ;
  }
  
  while (status != WL_CONNECTED) {
    Serial.print("Attempting connection to ");
    Serial.print(ssid);
    Serial.println("...");
    status = WiFi.begin(ssid, pwd);
    delay(10000);
  }
   
  Serial.println("Connected to wifi");
  printWifiStatus();

  Serial.println("\nStarting connection to server...");
  // if you get a connection, report back via serial:
  Udp.begin(localPort);
  lastTime = millis();

  do {    
    humBuffer[countValues] = sensor.readHumidity();
    tempBuffer[countValues] = sensor.readTemperature();
    countValues++;
  } while (countValues % BUFFER_SIZE != 0);
  
}

void loop() {
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  if (packetSize) {
    //Serial.print("Received packet of size ");
    //Serial.println(packetSize);
    //Serial.print("From ");
    IPAddress remoteIp = Udp.remoteIP();
    Serial.print("UDP:");
    Serial.print(remoteIp);
    Serial.print(":");
    //Serial.println(Udp.remotePort());

    // read the packet into packetBufffer
    int len = Udp.read(packetBuffer, 255);
    if (len > 0) {
      packetBuffer[len] = 0;
    }
    //Serial.println("Contents:");
    Serial.println(packetBuffer);

    // send a reply, to the IP address and port that sent us the packet we received
    Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
    Udp.write(ReplyBuffer);
    Udp.endPacket();
  }
  if ( (millis() - lastTime) > 50) {
    lastTime = millis();
    humBuffer[countValues] = sensor.readHumidity();
    tempBuffer[countValues] = sensor.readTemperature();
    countValues = (countValues + 1) % BUFFER_SIZE;
    
    Serial.print("HUM:");
    Serial.println(bufferMean(humBuffer, BUFFER_SIZE), 2);
    Serial.print("TEMP:");
    Serial.println(bufferMean(tempBuffer, BUFFER_SIZE), 2);
  }

  if ((millis() - lastLog) > 5000) {

    Udp.beginPacket(broadcastIP, localPort);
    Udp.print("ParkinsonCentralIP:");
    Udp.print(WiFi.localIP());
    Udp.endPacket();
    
    printWifiStatus();

    lastLog = millis();    
  }  
}


void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}

void sendIPBroadcast(String ip) {
  
}

float bufferMean( float* buffer, int length) {
  float mean = 0;
  for (int i = 0; i < length; i++)
  {
    mean += buffer[i];
  }
  return mean / (float) length;
}


