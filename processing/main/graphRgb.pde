/**
* @author Guillem Gonzalez Vela <guillem.vela@etudiant.univ-rennes1.fr>
* @author Maxime ARIF <maxime.arif@etudiant.univ-rennes1.fr>
**/
public class GraphRgb {
  private int posX,posY,width,height;
  private int minVal, maxVal;
  private ArrayList<Integer> donneesR, donneesG, donneesB;
  private final static int MAX_ARRAY_SIZE=20;
  
  public GraphRgb(int posX,int posY,int width, int height) {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
    this.minVal = 0;
    this.maxVal = 255;
    this.donneesR = new ArrayList<Integer>();
    this.donneesG = new ArrayList<Integer>();
    this.donneesB = new ArrayList<Integer>();
  }
  
  void draw() {
    fill(122);
    rect(this.posX-1, this.posY-1, this.width+1, this.height+1);
    fill(0);
    if (minVal < 0 && maxVal > 0){
    line(this.XtoCanvas(0), YtoCanvas(0), XtoCanvas(MAX_ARRAY_SIZE), YtoCanvas(0));
    }
    for(int i = 0; i < donneesR.size()-1 ;i++){
      stroke(255,0,0);
      line(this.XtoCanvas(i), YtoCanvas(donneesR.get(i)), XtoCanvas(i+1), YtoCanvas(donneesR.get(i+1)));
    }
    for(int i = 0; i < donneesG.size()-1 ;i++){
      stroke(0,255,0);
      line(this.XtoCanvas(i), YtoCanvas(donneesG.get(i)), XtoCanvas(i+1), YtoCanvas(donneesG.get(i+1)));
    }
    for(int i = 0; i < donneesB.size()-1 ;i++){
      stroke(0,0,255);
      line(this.XtoCanvas(i), YtoCanvas(donneesB.get(i)), XtoCanvas(i+1), YtoCanvas(donneesB.get(i+1)));
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
    
    fill(127,0,0);
    if (donneesR.size() > 0) text(donneesR.get(0), this.posX + width - 75, this.posY +height+ 15);
    fill(0, 127,0);
    if (donneesG.size() > 0) text(donneesG.get(0), this.posX + width - 37, this.posY +height+ 15);
    fill(0,0,127);
    if (donneesB.size() > 0) text(donneesB.get(0), this.posX + width, this.posY +height+ 15);
  }
  
  private int XtoCanvas(int x) {
    return (int)map(x,0, MAX_ARRAY_SIZE - 1, this.posX, this.posX+this.width);
  }
  
  private int YtoCanvas(float y) {
    return (int)(map(y, this.minVal, this.maxVal, this.posY+this.height, this.posY));
  }
  
  public void addValue(int r, int g, int b){
    if(donneesR.size() == MAX_ARRAY_SIZE){
      donneesR.remove(donneesR.size() - 1);
    }
    donneesR.add(0,r);
    if(donneesG.size() == MAX_ARRAY_SIZE){
      donneesG.remove(donneesG.size() - 1);
    }
    donneesG.add(0,g);
    if(donneesB.size() == MAX_ARRAY_SIZE){
      donneesB.remove(donneesB.size() - 1);
    }
    donneesB.add(0,b);
  }  
  
}
