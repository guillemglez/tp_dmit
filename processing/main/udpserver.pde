public class UdpServer {
  private int posX,posY,width,height;
  private final static int textSpacing=15;
  private final static int maxlines = 10;
  private ArrayList<String> lines;
  
  public UdpServer(int posX,int posY,int width, int height) {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
  }
  
  void addLine(String remitent, String message) {
    if(lines.size() == maxlines){
      lines.remove(0);
    }
    lines.add(ip + message);;
  }
  
  void draw() {
    //stroke(255);
    noFill();
    rect(posX, posY, width, height);
    
    textAlign(LEFT);
    //textSize(32);
    
    for (int i = 0; i < lines.size(); i++) {
       text(lines.get(i), posX + textSpacing, posY + (i+1)*textSpacing);
    }     
  }
}
