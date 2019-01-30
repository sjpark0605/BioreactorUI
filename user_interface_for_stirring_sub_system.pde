// Entry point to the program

import processing.serial.*;
import java.util.LinkedList;
import java.util.Calendar;
import java.util.Date;
import java.text.SimpleDateFormat;

Controller myController;
Serial myPort;

void setup() {
  size(1000, 750);
  printArray(Serial.list());  
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myController = new Controller(myPort);
}

void draw() {
  myController.run();
}

void mousePressed() {
  if (!myController.textBoxState && mouseX > 505 && mouseX < 980 && mouseY > 180 && mouseY < 330) {
    myController.model.createTextBox();
    myController.textBoxState = true;
  }
}
  
void keyPressed() {
  if (key == ESC) {
    this.myController.writer.close();
  } else if (myController.textBoxState) {
    myController.model.textBox.keyPress(key, myController);
  }
}
