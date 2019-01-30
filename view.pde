// Presents application data in a meaningful way

public class Coord {
  public final float x;
  public final float y;
  
  Coord(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

public class View {

  private PFont f;
  
  View() {
    this.f = createFont("Arial",16,true);
  }
  
  public void initBackground() {
    background(51, 52, 50);
    
    fill(72, 75, 65);
    noStroke();
    rect(MARGIN, MARGIN, width - 2*MARGIN, 150);
    rect(MARGIN, 180, 475, 150);
    rect(505, 180, 475, 150);
    rect(MARGIN, 340, 960, 390);
    
    fill(37, 38, 46);
    rect(2*MARGIN, 360, 920, 350);
    
    textFont(f,20);
    fill(255);
    text("STIRRING SPEED",30,210);
    text("SETPOINT",515,210);
    
    stroke(98, 96, 100);
    strokeWeight(1);
    noFill();
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 9; j++) {
        rect(100 + 50 * i, 380 + 30 * j, 50, 30);
      }
    }
    stroke(26, 232, 144);
    strokeWeight(4);
    
    textFont(f,14);
    fill(255);
    for (int i = 0; i < (MAX - MIN)/STEP + 1; i++) {
      float yLabel = MIN + i*STEP;
      text(Float.toString(yLabel) + this.addUnitOfMeasurement(), 100 - 50, this.getYCoord(yLabel));
    }
  }
  
  public void registerStatus(boolean status) {
    
  }
  
  public void registerRpm(String rpm) {
    textFont(f,40);
    fill(26, 232, 144);
    text(rpm + this.addUnitOfMeasurement(), 50, 300);
  }
  
  public void registerSetPoint(String setPoint) {
    textFont(f,40);
    fill(154, 116, 222);
    text(setPoint + this.addUnitOfMeasurement(), 530, 300);
  }
  
  public void registerTextBox(TextBox textBox) {
    fill(255);
    noStroke();
    rect(textBox.getX(), textBox.getY(), textBox.getWidth(), textBox.getHeight());
    textFont(f,40);
    fill(0);
    text(textBox.getTxt() + this.blinkingChar(), textBox.getX() + PADDING, textBox.getY() + textBox.getHeight() - PADDING);
  }
  
  public void graphValues(LinkedList<Float> values, char key_) {
    ArrayList<Coord> coords = new ArrayList<Coord>();
    int index = 0;
    
    for (float value : values) {
      coords.add(new Coord(100 + index*1, this.getYCoord(value)));
      index += 1;
    }
    
    if (key_ == 't') {
      stroke(26, 232, 144);
    } else {
      stroke(154, 116, 222);
    }
    strokeWeight(3);
    
    for (int j = 0; j < coords.size() - 1; j++) {
      Coord coord1 = coords.get(j);
      Coord coord2 = coords.get(j + 1);
      line(coord1.x, coord1.y, coord2.x, coord2.y);
    }
  }
  
  public void registerTimes(LinkedList<Date> times) {
    SimpleDateFormat ft = new SimpleDateFormat ("HH:mm:ss");
    int index = 0;
    textFont(f,14);
    fill(255);
    for (Date time: times) {
      text(ft.format(time), 100 + 100 * index, 670);
      index += 1;
    }
  }
  
  private float getYCoord(float rpm) {
    float rotatePerMin = rpm;
    float factor1 = 270.0/(MAX - MIN);
    float factor2 = rotatePerMin - MIN;
    if (rotatePerMin > MAX) {
      return 380;
    } 
    else if (rotatePerMin < MIN) {
      return 650;
    } else {
      return (650 - factor1*factor2);
    }
 }
  
  private String addUnitOfMeasurement() {
    return " RPM";
  }
  
  private String blinkingChar() {
    return (frameCount>>4 & 1) == 0 ? "_" : "";
  }
}
