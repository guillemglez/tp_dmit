/**
* @author Maxime ARIF <maxime.arif@etudiant.univ-rennes1.fr>
* @author Guillem GONZÁLEZ VELA <guillem.vela@etudiant.univ-rennes1.fr>
* @brief Code processing qui se connecte à un port série et intérprete les données (voir arduino/udpserver.ino) 
**/

// Taille des bouttons
public static final int RECT_WIDTH = 100;
public static final int RECT_HEIGHT = 40;
// Position du boutton de connexion
public static final int RECT_1_X = 245;
public static final int RECT_1_Y = 20;
// Position et taille de la liste de ports COM
public static final int LIST_START_X = 80;
public static final int LIST_START_Y = 20;
public static final int LIST_WIDTH = 100;
public static final int LIST_HEIGHT = 40;
// Position et taille de l'indicateur clignottant de la LED
public static final int LED_START_X = RECT_1_X + RECT_WIDTH + 100;
public static final int LED_START_Y = RECT_1_Y + RECT_HEIGHT / 2;
public static final int LED_WIDTH = 40;
public static final int LED_HEIGHT = 40;
// Position et taille de la première graphe
public static final int GRAPH_POSX = 40;
public static final int GRAPH_POSY = 120;
public static final int GRAPH_WIDTH = 500;
public static final int GRAPH_HEIGHT = 300;

//  Initialisation des variables
public boolean ledState = false;
Serial arduino;
private String[] arrayOfCOM;
private int listYStart;
private Button[] listBtn = new Button[20];
private Button connectBtn;
private Button expandBtn;
private Button currentComBtn;
private Graph2 graphSensor;
private GraphRgb graphRgb;
private Graph proxGraph, gyroGraph;
private UdpServer udpserver;
private String btnText;
private LogInfo logInfo;
private String newLineChar = "-";

// Importer toutes les classes dans le dossier
import processing.serial.*;

void settings() {
  size(1280, 840);
  smooth();
}

void setup() {
   // Status de la LED clignottante
   ledState = false;
   btnText = "--";
   // Boutton de connexion
   connectBtn = new Button(RECT_1_X, RECT_1_Y, RECT_WIDTH, RECT_HEIGHT, "CONNECT", 46, 204, 113, 231, 76, 60);
   // Boutton d'expansion de liste
   expandBtn = new Button(LIST_START_X-RECT_HEIGHT, LIST_START_Y, RECT_HEIGHT, RECT_HEIGHT, "+", 255,255,255, 150,150,150 );
   // Boutton indicateur de le port COM utilisé
   currentComBtn = new Button(LIST_START_X, LIST_START_Y, LIST_WIDTH, LIST_HEIGHT, btnText, 255, 255, 255, 150, 150, 150);

   // Liste des ports COM
   listYStart = LIST_START_Y + LIST_HEIGHT;
   int count = 0;
   arrayOfCOM = Serial.list();
   for (String port : arrayOfCOM) {
     listBtn[count] = new Button(LIST_START_X, listYStart, LIST_WIDTH, LIST_HEIGHT, port, 255, 255, 255, 150, 150, 150);
     listYStart += LIST_HEIGHT;
     count++;
   }

   // Création des objets de graphe et information
   graphSensor = new Graph2(GRAPH_POSX, GRAPH_POSY, GRAPH_WIDTH ,GRAPH_HEIGHT, 10,50,20, 80);
   graphRgb = new GraphRgb(GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY, GRAPH_WIDTH ,GRAPH_HEIGHT);
   proxGraph = new Graph(GRAPH_POSX, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH, GRAPH_HEIGHT, 0, 255);
   udpserver = new UdpServer(GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH, GRAPH_HEIGHT);
   gyroGraph = new Graph(GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH, GRAPH_HEIGHT, 0, 20);
   logInfo = new LogInfo(RECT_1_X + 150, RECT_1_Y, GRAPH_WIDTH, RECT_HEIGHT + 35);
}

void draw() {

  background(236, 240, 241);
  
  // Status de la LED clignottante
/*   if (connectBtn.isClicked()) {
   if (ledState) {
     fill(230, 126, 34);
   } else {
     fill(44, 62, 80);
   }
  } else {
   noFill();
  }
  ellipse(LED_START_X, LED_START_Y, LED_WIDTH, LED_HEIGHT); */

  // Texte informatif pour chacune des graphes
  fill(127,0,0);
  textAlign(LEFT, CENTER);
  text("Température (ºC)", GRAPH_POSX, GRAPH_POSY - 10);
  fill(0,0,127);
  textAlign(RIGHT, CENTER);
  text("Humidité (%)", GRAPH_POSX+ GRAPH_WIDTH, GRAPH_POSY - 10);
  graphSensor.draw();
  fill(50);
  textAlign(LEFT, CENTER);
  text("Intensité des couleurs", GRAPH_POSX + GRAPH_WIDTH + 120 , GRAPH_POSY - 10);
  textAlign(LEFT, CENTER);
  text("Proximité", GRAPH_POSX , GRAPH_POSY + GRAPH_HEIGHT + 50 - 10);
  textAlign(LEFT, CENTER);
  text("Gyroscope", GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY + GRAPH_HEIGHT + 50 - 10);
  
  // Mettre à jour chacun des objets
  graphRgb.draw();
  logInfo.draw();  
  proxGraph.draw();
  gyroGraph.draw();
  
  // Contrôle de la connexion COM 
  connectBtn.draw();
  expandBtn.draw();
  currentComBtn.draw();
  if (expandBtn.isClicked()){
    expandBtn.setText("-");
    for (int i = 0; i < arrayOfCOM.length; i++) {
      listBtn[i].draw();
    }
  } else {
    expandBtn.setText("+");
  }
  
  // Objet qui montre le contenu tous les paquets reçus par l'Arduino
  //udpserver.draw();
}

void mouseReleased() {
 
  // Expansion de la liste
  for (int i = 0; i < arrayOfCOM.length; i++) {
      listBtn[i].setClicked(false);
    }
  if (!currentComBtn.getText().equals(btnText)) connectBtn.mouseReleased(mouseX,mouseY);
  if (!connectBtn.isClicked()) expandBtn.mouseReleased(mouseX,mouseY);
  if (expandBtn.isClicked()){
  for (int i = 0; i < arrayOfCOM.length; i++) {
    listBtn[i].mouseReleased(mouseX,mouseY);
    if (listBtn[i].isClicked()){
      currentComBtn.setText(listBtn[i].getText());
      expandBtn.setClicked(false);
    }
  }
  }
  
  // Action du boutton de connexion
  if (connectBtn.isMouseOver()) {
    if (currentComBtn.getText().equals(btnText)) {
      connectBtn.setClicked(false); 
    } else {
      if (!connectBtn.isClicked()) {
        arduino.stop();
        connectBtn.setText("CONNECT");
      } else {
        arduino = new Serial(this, currentComBtn.getText(), 9600);
        arduino.bufferUntil(10); 
        connectBtn.setText("DISCONNECT");
      }
    }
  }
}

// Traitement des données provenant de la plaque ARDUINO
void serialEvent(Serial arduino){
   // Éliminer les sauts de ligne de la chaîne de caractères
   String serialText = arduino.readString().replaceAll("(\\r|\\n)", "");
   // Si SSID Wi-Fi
   if (serialText.contains("SSID")) logInfo.setSSID(serialText.split(":")[1]);
   // Si IP Wi-Fi
   if (serialText.contains("IP")) logInfo.setIP(serialText.split(":")[1]);
   // Si paquet UDP (tous les paquets sont affichés dans la fênetre de debug)
   if (serialText.contains("UDP")) {
     if (newLineChar.contains("-")) {
       newLineChar = " ";
     } else {
       newLineChar = "-";
     }
     udpserver.addLine(newLineChar + "UDP from " + serialText.split(":", 3)[1] + ": ", serialText.split(":", 3)[2]);
     println(newLineChar + "UDP from " + serialText.split(":", 3)[1] + ": ", serialText.split(":", 3)[2]);
   }
   // Senseur d'humidité
   if (serialText.contains("HUM")) graphSensor.addValue2(Float.parseFloat(serialText.split(":")[1]));
   // Senseur de temperature
   if (serialText.contains("TEMP")) graphSensor.addValue1(Float.parseFloat(serialText.split(":")[1]));
   // Message des senseurs locals
   if (serialText.contains("MSG")) logInfo.setLocal(serialText.split(":")[1]);
   // Paquet provenant de l'équipe du senseur gyroscopique
   if (serialText.contains("GYRO")) {
     gyroGraph.addValue(Float.parseFloat(serialText.split(":")[3])); 
     logInfo.setGyro(serialText.split(":")[4]);
   }
   // Paquet provenant de l'équipe du senseur RGB
   if (serialText.contains("RGB")) {
     int r = Integer.parseInt(serialText.split(":")[3]);
     int g = Integer.parseInt(serialText.split(":")[4]);
     int b = Integer.parseInt(serialText.split(":")[5]);
     graphRgb.addValue(r, g, b);
     logInfo.setRGB(serialText.split(":")[6]);
   }
   // Paquet provenant de l'équipe du senseur de proximité
   if (serialText.contains("Prox")) {
     proxGraph.addValue(Float.parseFloat(serialText.split(":")[3])); 
     logInfo.setProx(serialText.split(":")[4]);
   }
}

// Mouvement de la souris : loop sur tous les éléments avec des méthodes "hover"
void mouseMoved(){
  for (int i = 0; i < arrayOfCOM.length; i++) {
    listBtn[i].mouseMoved(mouseX,mouseY);
  }
  if (!currentComBtn.getText().equals(btnText)) connectBtn.mouseMoved(mouseX,mouseY);
  if (!connectBtn.isClicked()) expandBtn.mouseMoved(mouseX,mouseY);
}

// Fonction qui écrit du texte centré à une position donnée
public void writeText(String text,int x,int y) {
  textAlign(CENTER, CENTER);
  text(text, x, y);
}
