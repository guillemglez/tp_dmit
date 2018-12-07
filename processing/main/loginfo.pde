public class LogInfo {
  private int posX,posY,width,height;
  private final static int textSpacing=15;
  
  public String ssid, pwd, ip, mac;
  
  public LogInfo(int posX,int posY,int width, int height) {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
  }
  
  void setSSID(String ssid) {
    this.ssid = ssid;
  }
  void setPWD(String pwd) {
    this.pwd = pwd;
  }
  void setIP(String ip) {
    this.ip = ip;
  }
  
  String getIP() {
    return this.ip;
  }
  
  void setMAC(String mac) {
    this.mac = mac;
  }
  
  void draw() {
    //stroke(255);
    noFill();
    rect(posX, posY, width, height);
    
    int textY = posY + 20;
    int textX = posX + 10;
    textAlign(LEFT);
    //textSize(32);
    
    text("SSID : " + ssid, textX, textY);
    textY += textSpacing;
    text("PWD : " + pwd, textX, textY);
    textY += textSpacing;
    text("IP : " + ip, textX, textY);
    textY += textSpacing;
    text("MAC : " + mac, textX, textY);
    textY += textSpacing;
  }
}
