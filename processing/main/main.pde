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
public static final int GRAPH_WIDTH = 250;
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
private UdpServer udpserver;
private String btnText;
private LogInfo logInfo;

//import classes;
import processing.serial.*;

void settings() {
  size(640, 840);
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
   graphSensor = new Graph2(GRAPH_POSX, GRAPH_POSY, GRAPH_WIDTH*2 + 50 ,GRAPH_HEIGHT, 10,50,20, 80);
   udpserver = new UdpServer(GRAPH_POSX, GRAPH_POSY + GRAPH_HEIGHT + 50, GRAPH_WIDTH + 50 + GRAPH_WIDTH, GRAPH_HEIGHT);
   logInfo = new LogInfo(RECT_1_X + 150, RECT_1_Y, 200, RECT_HEIGHT + 20);
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
 
  graphSensor.draw();
  logInfo.draw();  
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
  
  udpserver.draw();
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
   String serialText = arduino.readString();
   if (serialText.contains("SSID")) logInfo.setSSID(serialText.split(":")[1]);
   if (serialText.contains("IP")) logInfo.setIP(serialText.split(":")[1]);
   if (serialText.contains("UDP")) udpserver.addLine("UDP: ", serialText.split(":")[2]);
   if (serialText.contains("HUM")) graphSensor.addValue2(Float.parseFloat(serialText.split(":")[1]));
   if (serialText.contains("TEMP")) graphSensor.addValue1(Float.parseFloat(serialText.split(":")[1]));
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
