// Contains state of application

public class TextBox {
  
  private int x;
  private int y;
  private int w;
  private int h;
  private String txt;
  
  TextBox(int x, int y, int w, int h, String txt) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    this.txt = txt;
  }
  
  public String getTxt() {
    return this.txt;
  }
  
  public int getWidth() {
    return this.w;
  }
  
  public int getHeight() {
    return this.h;
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
  
  public void keyPress(char k, Controller controller) {
     if (k == ENTER || k == RETURN) {
       if (this.isValid(this.txt)) {
         controller.model.setSetPoint(Float.parseFloat(this.txt));
         controller.textBoxState = false;
       } else {
         controller.textBoxState = false;
       }
     } else if (k == BACKSPACE) {
       if (txt.length() > 0) {
         txt = txt.substring(0,txt.length() - 1);
       }
     } else {
       if (txt.length() < 5) {
         txt += str(k);
       }
     }
  }
  
  private boolean isValid(String s) {
    return s.matches("\\d+(\\.\\d+)?");
  }
  
}


public class Model {
  
  private Controller controller;
  private float setPoint;
  private float rpm;
  private boolean isMotorOn;
  private TextBox textBox;
  private LinkedList<Float> rpms;
  private int modCount;
  private LinkedList<Float> setPoints;
  private int modCount2;
  private LinkedList<Date> times;
  
  Model(Controller controller) {
    this.controller = controller;
    this.setPoint = 710;
    this.isMotorOn = false;
    this.rpms = new LinkedList<Float>();
    this.modCount = 0;
    this.setPoints = new LinkedList<Float>();
    this.modCount2 = 0;
    this.times = new LinkedList<Date>();
    this.initialiseTimes();
  }
  
  public void initialiseTimes() {
    Calendar time = Calendar.getInstance();
    for (int i = 0; i < 9; i++) {
      this.times.add(time.getTime());
      time.add(Calendar.SECOND, 10);
    }
}
  
 public void setRpm(float rpm) {
   this.rpm = rpm;
 }
 
 public float getRpm() {
   return this.rpm;
 }
 
 public void setSetPoint(float setPoint) {
   if (setPoint < 500) {
     this.setPoint = 500;
   } else if (setPoint > 1500) {
     this.setPoint = 1500;
   } else {
     this.setPoint = setPoint;
   }
 }
 
 public float getSetPoint() {
   return this.setPoint;
 }
 
 public boolean getMotorStatus() {
   return this.isMotorOn;
 }
 
 public void addToRpms(float rpm) {
   if (this.modCount < 800) {
     this.rpms.add(rpm);
     this.modCount += 1;
   } else {
     this.rpms.remove();
     this.rpms.add(rpm);
   }
 }
 
 public void addToSetPoints(float setPoint) {
   if (this.modCount2 < 800) {
     this.setPoints.add(setPoint);
     this.modCount2 += 1;
   } else {
     this.setPoints.remove();
     this.setPoints.add(setPoint);
   }
 }
 
 public void addToTimes(Date time) {
   this.times.remove();
   this.times.add(time);
 }
 
 public void checkRpm() {
   if (this.rpm < this.setPoint) {
     this.controller.raiseMotorPwm();
   } else {
     this.controller.lowerMotorPwm();
   }
 }
 
 public void createTextBox() {
   this.textBox = new TextBox(530, 260, 155, 50, Float.toString(this.setPoint));
 }
 
 public void update() {
   this.checkRpm();
   this.controller.registerRpm(this.rpm);
   this.controller.registerStatus(this.isMotorOn);
   this.controller.registerRpms(this.rpms);
   this.controller.registerSetPoints(this.setPoints);
   this.controller.registerTimes(this.times);
   
   if (this.controller.getTextBoxState()) {
     this.controller.registerTextBox(this.textBox);
   } else {
     this.controller.registerSetPoint(this.setPoint);
   }
 }
  
}
