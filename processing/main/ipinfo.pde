public class IPInfo {
  private int[] IPS = {241,242,243,244,245,246,247,248,249,250,251,252,253};
  private boolean[] stat = {false,false,false,false,false,false,false,false,false,false,false,false,false};
  private int posX,posY,width,height;
  private int myIP = -1;
  
  public IPInfo(int posX,int posY,int width, int height) {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
  }
  
  void update(boolean[] ips, int myIP) {
    stat = ips;
    this.myIP = myIP;
  }
  
  int[] getIPs() {
    return IPS;
  }
  
  
  void draw() {
    textAlign(CENTER);
    
    int lignes = 2;
    int spacingX = width / int((IPS.length + 1)/lignes + 1) ; 
    int spacingY = height / (lignes +1 );
    int count = 0;
    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < int((IPS.length + 1)/lignes) ; j++) {
      if (count < IPS.length) {
         if (myIP == IPS[count]) {
           fill(0,0,255);
         } else {
           if (stat[count]) {
            fill(0,255,0);
           } else {
            fill(255,0,0);
           }
         }
        text(IPS[count], posX + (j+1)*spacingX, posY + (i+1)*spacingY);
        count++;
      }
    }
    
    noFill();
    rect(posX, posY, width, height);
    
    textAlign(LEFT);

  }
  }
}
