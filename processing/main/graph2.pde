public class Graph2 {
  private int posX,posY,width,height;
  private float minVal1, maxVal1, minVal2, maxVal2;
  private ArrayList<Float> donnees1, donnees2;
  private final static int MAX_ARRAY_SIZE=200;
  
  public Graph2(int posX,int posY,int width, int height, float minVal1, float maxVal1, float minVal2, float maxVal2) {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
    this.minVal1 = minVal1;
    this.maxVal1 = maxVal1;
    this.donnees1 = new ArrayList<Float>();
    this.minVal2 = minVal2;
    this.maxVal2 = maxVal2;
    this.donnees2 = new ArrayList<Float>();
  }
  
  void draw() {
    fill(122);
    rect(this.posX-1, this.posY-1, this.width+1, this.height+1);
    fill(0);
    if (minVal1 < 0 && maxVal1 > 0){
      stroke(127,0,0);
      line(this.XtoCanvas(0), YtoCanvas1(0), XtoCanvas(MAX_ARRAY_SIZE), YtoCanvas1(0));
    }
    if (minVal2 < 0 && maxVal2 > 0){
      stroke(0,0,127);
      line(this.XtoCanvas(0), YtoCanvas2(0), XtoCanvas(MAX_ARRAY_SIZE), YtoCanvas2(0));
    }
    for(int i = 0; i < donnees1.size()-1 ;i++){
      stroke(255,0,0);
      line(this.XtoCanvas(i), YtoCanvas1(donnees1.get(i)), XtoCanvas(i+1), YtoCanvas1(donnees1.get(i+1)));
    }
    for(int i = 0; i < donnees2.size()-1 ;i++){
      stroke(0,0,255);
      line(this.XtoCanvas(i), YtoCanvas2(donnees2.get(i)), XtoCanvas(i+1), YtoCanvas2(donnees2.get(i+1)));
    }
    
    // Grille
    stroke(255);
    for (int x = 5; x < width; x += 10) {
      for (int y = 5; y < height; y += 10) {
        point(posX + x, posY + y);
      }
    }
    stroke(0);
    
    textAlign(RIGHT);
    fill(127,0,0);
    text(int(minVal1),this.posX - 5, this.posY + this.height + 7);
    text(int(maxVal1),this.posX - 5, this.posY + 7);
    textAlign(LEFT);
    if (donnees1.size() > 0) text(donnees1.get(0), this.posX + 5, this.posY + height + 15);
    
    textAlign(LEFT);
    fill(0,0,127);
    text(int(minVal2),this.posX + width + 5, this.posY + this.height + 7);
    text(int(maxVal2),this.posX + width + 5, this.posY + 7);
    textAlign(RIGHT);
    if (donnees2.size() > 0) text(donnees2.get(0), this.posX + width - 5, this.posY + height + 15);
  }
  
  private int XtoCanvas(int x) {
    return (int)map(x,0, MAX_ARRAY_SIZE - 1, this.posX, this.posX+this.width);
  }
  
  private int YtoCanvas1(float y) {
    return (int)(map(y, this.minVal1, this.maxVal1, this.posY+this.height, this.posY));
  }
  private int YtoCanvas2(float y) {
    return (int)(map(y, this.minVal2, this.maxVal2, this.posY+this.height, this.posY));
  }
  
  public void addValue1(float val){
    if(donnees1.size() == MAX_ARRAY_SIZE){
      donnees1.remove(donnees1.size() - 1);
    }
    donnees1.add(0,val);
  }  
  
  public void addValue2(float val){
    if(donnees2.size() == MAX_ARRAY_SIZE){
      donnees2.remove(donnees2.size() - 1);
    }
    donnees2.add(0,val);
  }  
  
}
