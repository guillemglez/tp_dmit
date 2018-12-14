public class Graph {
  private int posX,posY,width,height;
  private float minVal, maxVal;
  private ArrayList<Float> donnees;
  private final static int MAX_ARRAY_SIZE=50;
  
  public Graph(int posX,int posY,int width, int height, float minVal, float maxVal) {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
    this.minVal = minVal;
    this.maxVal = maxVal;
    this.donnees = new ArrayList<Float>();
  }
  
  void draw() {
    fill(122);
    rect(this.posX-1, this.posY-1, this.width+1, this.height+1);
    fill(0);
    line(this.XtoCanvas(0), YtoCanvas(0), XtoCanvas(MAX_ARRAY_SIZE), YtoCanvas(0));
    for(int i = 0; i < donnees.size()-1 ;i++){
      stroke(255,0,0);
      line(this.XtoCanvas(i), YtoCanvas(donnees.get(i)), XtoCanvas(i+1), YtoCanvas(donnees.get(i+1)));
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
    text(int(minVal),this.posX - 5, this.posY + this.height + 7);
    text(int(maxVal),this.posX - 5, this.posY + 7);
  }
  
  private int XtoCanvas(int x) {
    return (int)map(x,MAX_ARRAY_SIZE, 0, this.posX, this.posX+this.width);
  }
  
  private int YtoCanvas(float y) {
    return (int)(map(y, this.minVal, this.maxVal, this.posY+this.height, this.posY));
  }
  
  public void addValue(float val){
    if(donnees.size() == MAX_ARRAY_SIZE){
      donnees.remove(0);
    }
    donnees.add(val);
  }  
  
}
