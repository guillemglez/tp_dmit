/**
* @author Maxime ARIF <maxime.arif@etudiant.univ-rennes1.fr>
* @author Guillem GONZÁLEZ VELA <guillem.vela@etudiant.univ-rennes1.fr>
* @brief Code principal ARDUINO pour ce projet. Il :
*   - Se connecte à un réseau WiFi (dans ce cas, nommé TP_DMIT)
*   - Émet un broadcast à fin d'être réconnu pour les autres dispositifs
*   - Reste à l'écoute de paquets UDP des autres dispositifs
*   - Émet par serial les données de son senseur de témperature connecté et des données reçues par UDP
**/
 
#include <WiFiNINA.h> // Pour l'antenne WiFi
#include <WiFiUdp.h> // Pour le serveur UDP
#include "Adafruit_Si7021.h" // Pour le senseur temperature+humidité

// Nombre d'échantillons du senseur qui seront moyennés en sortie
#define BUFFER_SIZE 40

// Seuils au-dessus desquels un souffle est détecté
#define HUM_SEUIL 60
#define TEMP_SEUIL 29

// Données de réseau WiFi
IPAddress broadcastIP(192,168,0,255);
char ssid[] = "TP_DMIT";
char pwd[] = "dmit3ATP";
byte mac[6];
int status = WL_IDLE_STATUS;

// Échantillons du senseur
float tempBuffer[BUFFER_SIZE];
float humBuffer[BUFFER_SIZE];

// Port auquel les paquets UDP sont envoyés
unsigned int localPort = 4321;      // local port to listen on
char packetBuffer[255]; //buffer to hold incoming packet
char  ReplyBuffer[] = "Message reçu";  // a string to send back (currently disabled)
Adafruit_Si7021 sensor = Adafruit_Si7021();

WiFiUDP Udp;

unsigned long lastTime;
unsigned long lastLog;
int countValues = 0;

void setup() {
  //initialisation du sérial
  Serial.begin(9600);
  
  // check for the WiFi module:
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    while (true); // ne pas continuer
  }
  
  if (!sensor.begin()) {
    Serial.println("Did not find Si7021 sensor!");
    while (true); // ne pas continuer
  }
  
  while (status != WL_CONNECTED) {
    Serial.print("Attempting connection to ");
    Serial.print(ssid);
    Serial.println("...");
    status = WiFi.begin(ssid, pwd);
    delay(10000);
  }

  while (!Serial){} // Ne plus rien faire si l'ordinateur n'est pas à l'écoute du sérial
  
  Serial.println("Connected to wifi");
  printWifiStatus();

  Serial.println("\nStarting connection to server...");
  // if you get a connection, report back via serial:
  Udp.begin(localPort);
  lastTime = millis();

  // Remplir buffer senseurs
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

    // Envoyer les données du paquet par serial
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
 /*   Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
    Udp.write(ReplyBuffer);
    Udp.endPacket();*/
  }

  // Prendre une mesure toutes les 50 millisécondes
  if ( (millis() - lastTime) > 50) {
    lastTime = millis();
    humBuffer[countValues] = sensor.readHumidity();
    tempBuffer[countValues] = sensor.readTemperature();
    
    // Envoyer la mésure déjà traitée par serial
    Serial.print("HUM:");
    Serial.println(bufferMean(humBuffer, BUFFER_SIZE), 2);
    Serial.print("TEMP:");
    Serial.println(bufferMean(tempBuffer, BUFFER_SIZE), 2);
    Serial.print("MSG:");
    // Message sur le mesure
    if ((humBuffer[countValues] > HUM_SEUIL) && (tempBuffer[countValues] > TEMP_SEUIL)) {
      Serial.println("La personne est en train de souffler");
    } else {
      Serial.println("La personne ne souffle pas");
    }     
    
    countValues = (countValues + 1) % BUFFER_SIZE;
  }

  // Envoyer un broadcast toutes les 5 sécondes
  if ((millis() - lastLog) > 5000) {

    Udp.beginPacket(broadcastIP, localPort);
    Udp.print("ParkinsonCentralIP:");
    Udp.print(WiFi.localIP());
    Udp.endPacket();
    
    // Envoyer par serial les données de connexion
    printWifiStatus();

    lastLog = millis();    
  }  
}

// Fonction qui envoye par serial les données de la connexion
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

// Fonction qui applique un filtre moyenneur aux données du senseur
float bufferMean( float* buffer, int length) {
  float mean = 0;
  for (int i = 0; i < length; i++)
  {
    mean += buffer[i];
  }
  return mean / (float) length;
}


