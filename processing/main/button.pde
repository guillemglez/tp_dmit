/**
* @author Maxime ARIF <maxime.arif@etudiant.univ-rennes1.fr>
* @author Guillem GONZÁLEZ VELA <guillem.vela@etudiant.univ-rennes1.fr>
* @brief Classe Button : Définit un objet clickable
**/
public class Button {
  private int posX,posY,width,height;
  private String text;
  private int r,g,b;
  private int rclicked, gclicked, bclicked;
  private boolean mouseOver, clicked;
  
  public Button(int posX, int posY, int width, int height, String text, int r, int g, int b, int rclicked, int gclicked, int bclicked) {        
    this.posX = posX;
    this.posY = posY;
    this.height = height;
    this.width = width;
    setText(text);
    setBtnColor(r, g, b);
    setBtnOverColor(rclicked, gclicked, bclicked);
  }
  
  // Change le texte d'affichage
  public void setText(String text){
    this.text = text;
  }
  
  // Change la couleur d'affichage
  public void setBtnColor(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  // Change la couleur de "hover"
  public void setBtnOverColor(int r, int g, int b) {
    this.rclicked = r;
    this.gclicked = g;
    this.bclicked = b;
  }
  
  void draw() {
    if (clicked) {
      fill(this.rclicked, this.gclicked, this.bclicked);
    } else {
      fill(this.r, this.g, this.b);
    }
    if (this.mouseOver) {
      strokeWeight(2);
    } else {
      strokeWeight(1);
    }
    rect(this.posX, this.posY, this.width, this.height, 2);
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.text, this.posX + (int) (this.width/2), this.posY + (int) (this.height/2));
    strokeWeight(1);
  }
  
  public void mouseMoved(int x, int y) {
    if (((x > posX) && (x < (posX + width))) && ((y > posY) && (y < (posY + height)))) {
      this.mouseOver = true;
    } else {
      this.mouseOver = false;
    }
  } 
  
  public void mouseReleased(int x, int y){
    if (((x > posX) && (x < (posX + width))) && ((y > posY) && (y < (posY + height)))) {
      setClicked(!isClicked());
    }  
  }
  
  public boolean isClicked() {
    return clicked;
  }
   
  public boolean isMouseOver() {
    return mouseOver;
  }
  
  public void setClicked(boolean clicked) {
    this.clicked = clicked;
  }
  
  public String getText() {
    return this.text;
  }
}
