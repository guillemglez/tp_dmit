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
public static final int GRAPH_HEIGHT = 150;
public boolean ledState = false;
Serial arduino;
private String[] arrayOfCOM;
private int listYStart;
private Button[] listBtn = new Button[20];
private Button connectBtn;
private Button expandBtn;
private Button currentComBtn;
private Graph graph;
private LogInfo loginfo;
private IPInfo ipinfo;
private int count;
private String btnText;

//import classes;
import processing.serial.*;

void settings() {
  size(640, 320);
  smooth();
}

void setup() {
   count=0;
   ledState = false;
   btnText = "--";
   graph = new Graph(GRAPH_POSX,GRAPH_POSY,GRAPH_WIDTH,GRAPH_HEIGHT,-1,1);
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
   loginfo = new LogInfo(GRAPH_POSX + GRAPH_WIDTH + 50, GRAPH_POSY, GRAPH_WIDTH, GRAPH_HEIGHT / 2);
   loginfo.setSSID("Notre SSID");
   loginfo.setPWD("Notre PWD");
   loginfo.setIP("Notre IP");
   loginfo.setMAC("Notre MAC");
   
   ipinfo = new IPInfo(GRAPH_POSX + GRAPH_WIDTH + 50, GRAPH_POSY + GRAPH_HEIGHT / 2, GRAPH_WIDTH, GRAPH_HEIGHT / 2);
}

void draw() {

  background(236, 240, 241);
  
  if (connectBtn.isClicked()) {
    if (ledState) {
      fill(230, 126, 34);
    } else {
      fill(44, 62, 80);
    }
  } else {
    noFill();
  }
  ellipse(LED_START_X, LED_START_Y, LED_WIDTH, LED_HEIGHT);
 
  count += 8;
  graph.addValue((float)Math.sin(Math.toRadians(count%360)));  
  graph.draw();
    
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
  
  loginfo.draw();
  ipinfo.draw();
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
   if (serialText.contains("LED_ON")) ledState = true;
   if (serialText.contains("LED_OFF")) ledState = false;
   if (serialText.contains("SSID")) loginfo.setSSID(serialText.split(":")[1]);
   if (serialText.contains("IP")) loginfo.setIP(serialText.split(":")[1]);
   if (serialText.contains("PWD")) loginfo.setPWD(serialText.split(":")[1]);
   if (serialText.contains("MAC")) loginfo.setMAC(serialText.substring(5));
   if (serialText.contains("PING")) {
     int[] IPs = ipinfo.getIPs();
     boolean[] pings = new boolean[IPs.length];
     for (int i = 0; i < IPs.length; i++) {
       if (serialText.contains(String.valueOf(ipinfo.IPS[i]))) {
         pings[i] = true;
       } else {
         pings[i] = false;
       }
     }
     String stringip = split(loginfo.getIP(),'.')[3];
     int myip = Integer.parseInt(stringip.substring(0, stringip.length() - 2));
     ipinfo.update(pings,myip);
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
