#include <WiFiNINA.h>
#include <ArduinoHttpClient.h>
#include <SPI.h>

#define STATE_LED_OFF 20
#define STATE_LED_ON 30
unsigned int state;
unsigned long lastTs;
unsigned long lastLog;

char ssid[] = "TP_DMIT";
char pwd[] = "dmit3ATP";
byte mac[6];
int status = WL_IDLE_STATUS;  
char serverAddress[] = "192.168.0.102";  // server address
int port = 80;
int statusCode = 0;
WiFiClient wifi;
HttpClient client = HttpClient(wifi, serverAddress, port);
String response;
boolean png;
byte ip[] = { 192, 168, 5, 254 };

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  state = STATE_LED_OFF;

  while (status != WL_CONNECTED) {
    Serial.print("Attempting connection to ");
    Serial.print(ssid);
    Serial.println("...");
    status = WiFi.begin(ssid, pwd);
    delay(10000);
  }

  WiFi.macAddress(mac);
  lastTs = millis();
  lastLog = lastTs;
}

void loop() {
  if ((state == STATE_LED_OFF) && ((millis() - lastTs)> 2000)) {
    digitalWrite(LED_BUILTIN, HIGH);
    state = STATE_LED_ON;
    lastTs = millis();
  } else if ((state == STATE_LED_ON) && ((millis() - lastTs) > 5000)) {
    state = STATE_LED_OFF;
    digitalWrite(LED_BUILTIN, LOW);
    lastTs = millis();
  }

  if (0){//(millis() - lastLog) > 200){
    
    Serial.println("READY");
    
    if (state == STATE_LED_OFF) {
      Serial.println("LED_OFF");  
    } else {
      Serial.println("LED_ON");  
    }

    Serial.print("SSID:");
    Serial.println(ssid);
  
    Serial.print("PWD:");
    Serial.println(pwd);
    
    Serial.print("IP:");
    Serial.println(WiFi.localIP());
    
    Serial.print("MAC:");
    Serial.print(mac[5],HEX);
    Serial.print(":");
    Serial.print(mac[4],HEX);
    Serial.print(":");
    Serial.print(mac[3],HEX);
    Serial.print(":");
    Serial.print(mac[2],HEX);
    Serial.print(":");
    Serial.print(mac[1],HEX);
    Serial.print(":");
    Serial.println(mac[0],HEX);
    
    lastLog = millis();
  }

  lastLog = millis();
  Serial.println("PINGING...");
  png = WiFi.ping(ip);
  Serial.println(millis() - lastLog);
  //Serial.println(WiFi.gatewayIP());
  
}

void pingall() {
  Serial.println("PING");
  for (byte i = 1; i < 254; i++) {
    ip[3] = i;
    if (WiFi.ping(ip) >= 0) {
      //Serial.println(ip); 
    }
  }
  Serial.println("PING");
}


