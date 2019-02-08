/**
* @author Maxime ARIF <maxime.arif@etudiant.univ-rennes1.fr>
* @author Guillem GONZÁLEZ VELA <guillem.vela@etudiant.univ-rennes1.fr>
* @brief Code ARDUINO qui:
*   - Se connecte à un réseau WiFi (dans ce cas, nommé TP_DMIT)
*   - Fait clignotter la LED de la plaque
*   - Fait ping aux dernières 8 IPs et n'écoute la réponse 
*   - Transmet les données de la LED et du ping par serial
**/

#include <WiFiNINA.h>

#define STATE_LED_OFF 20
#define STATE_LED_ON 30
unsigned int state;
unsigned long lastTs, lastLog, lastPing;

char ssid[] = "TP_DMIT";
char pwd[] = "dmit3ATP";
String pinged;
byte mac[6];
int status = WL_IDLE_STATUS;
char serverAddress[] = "192.168.0.102";  // server address
int port = 80;
int statusCode = 0;
WiFiClient wifi;
String response;
boolean png;
byte ip[] = { 192, 168, 0, 254 };

void setup() {
  Serial.begin(9600);
  while (!Serial){}
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
  lastLog = millis();
  lastPing = millis();

  pinged = pingall();
}

void loop() {

  // Faire clignotter la LED
  if ((state == STATE_LED_OFF) && ((millis() - lastTs) > 1000)) {
    digitalWrite(LED_BUILTIN, HIGH);
    state = STATE_LED_ON;
    lastTs = millis();
  } else if ((state == STATE_LED_ON) && ((millis() - lastTs) > 500)) {
    state = STATE_LED_OFF;
    digitalWrite(LED_BUILTIN, LOW);
    lastTs = millis();
  }

  // Envoyer le status par serial 5 fois par séconde
  if ((millis() - lastLog) > 200) {

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
    Serial.print(mac[5], HEX);
    Serial.print(":");
    Serial.print(mac[4], HEX);
    Serial.print(":");
    Serial.print(mac[3], HEX);
    Serial.print(":");
    Serial.print(mac[2], HEX);
    Serial.print(":");
    Serial.print(mac[1], HEX);
    Serial.print(":");
    Serial.println(mac[0], HEX);

    Serial.println(pinged);

    lastLog = millis();
  }

  // Ping au réseau toutes les minutes
  if ((millis() - lastPing) > 60000) {
    pinged = pingall();
    lastPing = millis();
  }
}

// Fonction qui fait ping aux IPs de la réseu (entre 241 et 248) et en retourne un string avec la information de ceux qui ont répondu
String pingall() {
  Serial.println("Pinging in LAN...");
  String reponse = "PING";
  int maxI = 248;
  for (byte i = 241; i < maxI; i++) {
    ip[3] = i;
    if (WiFi.localIP() == IPAddress(192, 168, 0, i)) continue;
    if (WiFi.ping(ip) >= 0) {
      reponse += ":" + String(ip[3], DEC);
    }
  }
  return reponse + ":PING";
}
