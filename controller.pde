// Interface between Model and View, and Processing and arduino

class Controller {
  
  private Model model;
  private View view;
  private Serial port;
  private PrintWriter writer;
  private boolean textBoxState;
  private boolean firstContact;
  private int timer;
  
  Controller(Serial port) {
    this.view = new View();  
    this.model = new Model(this);
    this.port = port;
    this.textBoxState = false;
    this.firstContact = false;
    this.timer = 0;
    this.writer = createWriter("myLogFile.log");
  }
  

  public void getRpm() {
    if (this.port.available() > 0) {
      String input = this.port.readStringUntil('\n');
      if (input != null) {
        if (firstContact) {
          float rpm = float(input);
          this.model.setRpm(rpm);
          this.model.addToRpms(rpm);
          this.model.addToSetPoints(this.model.getSetPoint());
          if (this.timer > 800 && this.timer % 100 == 0) {
            this.model.addToTimes(new Date());
          } else if (this.timer % 10 == 0) {
            this.logData(new Date(), rpm, this.model.getSetPoint());
          }
          this.timer += 1;
        } else {
          firstContact = true;
        }
      }
    }
  }
  
  public boolean getTextBoxState() {
    return this.textBoxState;
  }

  void run() {
    this.view.initBackground();
    this.getRpm();
    this.model.update();
  }
  
  public void registerRpm(float rpm) {
    this.view.registerRpm(Float.toString(rpm));
  }
  
  public void registerSetPoint(float setPoint) {
    this.view.registerSetPoint(Float.toString(setPoint));
  }
  
  public void registerStatus(boolean status) {
    this.view.registerStatus(status);
  }
  
  public void registerTextBox(TextBox textBox) {
    this.view.registerTextBox(textBox);
  }
  
  public void registerRpms(LinkedList<Float> rpms) {
    this.view.graphValues(rpms, 't');
  }
  
  public void registerSetPoints(LinkedList<Float> setPoints) {
    this.view.graphValues(setPoints, 's');
  }
  
  public void registerTimes(LinkedList<Date> times) {
    this.view.registerTimes(times);
  }
  
  public void raiseMotorPwm() {
    myPort.write('1');
  }
  
  public void lowerMotorPwm() {
    myPort.write('0');
  }
  
  public void logData(Date timestamp, float rpm, float setPoint) {
    SimpleDateFormat ft = new SimpleDateFormat ("dd-M-yyyy HH:mm:ss");
    this.writer.println(ft.format(timestamp));
    this.writer.println("rpm: " + Float.toString(rpm) + " set point: " + Float.toString(setPoint));
    this.writer.println("");
    this.writer.flush();
  }
}
