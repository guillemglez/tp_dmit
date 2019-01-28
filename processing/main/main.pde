/**
* @author Guillem Gonzalez Vela <guillem.vela@etudiant.univ-rennes1.fr>
* @author Maxime ARIF <maxime.arif@etudiant.univ-rennes1.fr>
**/
public static final int RECT_WIDTH = 100;
public static final int RECT_HEIGHT = 40;
public static final int RECT_1_X = 245;
public static final int RECT_1_Y = 20;
public static final int LIST_START_X = 80;
public static final int LIST_START_Y = 20;
public static final int LIST_WIDTH = 100;
public static final int LIST_HEIGHT = 40;
public static final int LED_START_X = RECT_1_X + RECT_WIDTH + 100;
public static final int LED_START_Y = RECT_1_Y + RECT_HEIGHT / 2;
public static final int LED_WIDTH = 40;
public static final int LED_HEIGHT = 40;
public static final int GRAPH_POSX = 40;
public static final int GRAPH_POSY = 120;
public static final int GRAPH_WIDTH = 500;
public static final int GRAPH_HEIGHT = 300;
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

//import classes;
import processing.serial.*;

void settings() {
  size(1280, 840);
  smooth();
}

void setup() {
   ledState = false;
   btnText = "--";
   connectBtn = new Button(RECT_1_X, RECT_1_Y, RECT_WIDTH, RECT_HEIGHT, "CONNECT", 46, 204, 113, 231, 76, 60);
   expandBtn = new Button(LIST_START_X-RECT_HEIGHT, LIST_START_Y, RECT_HEIGHT, RECT_HEIGHT, "+", 255,255,255, 150,150,150 );
   currentComBtn = new Button(LIST_START_X, LIST_START_Y, LIST_WIDTH, LIST_HEIGHT, btnText, 255, 255, 255, 150, 150, 150);
   listYStart = LIST_START_Y + LIST_HEIGHT;
   int count = 0;
   arrayOfCOM = Serial.list();
   for (String port : arrayOfCOM) {
     listBtn[count] = new Button(LIST_START_X, listYStart, LIST_WIDTH, LIST_HEIGHT, port, 255, 255, 255, 150, 150, 150);
     listYStart += LIST_HEIGHT;
     count++;
   }
   graphSensor = new Graph2(GRAPH_POSX, GRAPH_POSY, GRAPH_WIDTH ,GRAPH_HEIGHT, 10,50,20, 80);
   graphRgb = new GraphRgb(GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY, GRAPH_WIDTH ,GRAPH_HEIGHT);
   proxGraph = new Graph(GRAPH_POSX, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH, GRAPH_HEIGHT, 0, 255);
   udpserver = new UdpServer(GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH, GRAPH_HEIGHT);
   gyroGraph = new Graph(GRAPH_POSX + GRAPH_WIDTH + 120, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH, GRAPH_HEIGHT, 0, 20);
   logInfo = new LogInfo(RECT_1_X + 150, RECT_1_Y, GRAPH_WIDTH, RECT_HEIGHT + 35);
}

void draw() {

  background(236, 240, 241);
  
  //if (connectBtn.isClicked()) {
  //  if (ledState) {
  //    fill(230, 126, 34);
  //  } else {
  //    fill(44, 62, 80);
  //  }
  //} else {
  //  noFill();
  //}
  //ellipse(LED_START_X, LED_START_Y, LED_WIDTH, LED_HEIGHT);
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
  
  graphRgb.draw();
  logInfo.draw();  
  proxGraph.draw();
  gyroGraph.draw();
  
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
  
  //udpserver.draw();
}

void mouseReleased() {
 
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

void serialEvent(Serial arduino){
   String serialText = arduino.readString().replaceAll("(\\r|\\n)", "");
   if (serialText.contains("SSID")) logInfo.setSSID(serialText.split(":")[1]);
   if (serialText.contains("IP")) logInfo.setIP(serialText.split(":")[1]);
   if (serialText.contains("UDP")) {
     if (newLineChar.contains("-")) {
       newLineChar = " ";
     } else {
       newLineChar = "-";
     }
     udpserver.addLine(newLineChar + "UDP from " + serialText.split(":", 3)[1] + ": ", serialText.split(":", 3)[2]);
     println(newLineChar + "UDP from " + serialText.split(":", 3)[1] + ": ", serialText.split(":", 3)[2]);
   }
   if (serialText.contains("HUM")) graphSensor.addValue2(Float.parseFloat(serialText.split(":")[1]));
   if (serialText.contains("TEMP")) graphSensor.addValue1(Float.parseFloat(serialText.split(":")[1]));
   if (serialText.contains("MSG")) logInfo.setLocal(serialText.split(":")[1]);
   if (serialText.contains("GYRO")) {
     gyroGraph.addValue(Float.parseFloat(serialText.split(":")[3])); 
     logInfo.setGyro(serialText.split(":")[4]);
   }
   if (serialText.contains("RGB")) {
     int r = Integer.parseInt(serialText.split(":")[3]);
     int g = Integer.parseInt(serialText.split(":")[4]);
     int b = Integer.parseInt(serialText.split(":")[5]);
     graphRgb.addValue(r, g, b);
     logInfo.setRGB(serialText.split(":")[6]);
   }
   if (serialText.contains("Prox")) {
     proxGraph.addValue(Float.parseFloat(serialText.split(":")[3])); 
     logInfo.setProx(serialText.split(":")[4]);
   }
}

void mouseMoved(){
  for (int i = 0; i < arrayOfCOM.length; i++) {
    listBtn[i].mouseMoved(mouseX,mouseY);
  }
  if (!currentComBtn.getText().equals(btnText)) connectBtn.mouseMoved(mouseX,mouseY);
  if (!connectBtn.isClicked()) expandBtn.mouseMoved(mouseX,mouseY);
}

public void writeText(String text,int x,int y) {
  textAlign(CENTER, CENTER);
  text(text, x, y);
}
