String input = "Type something... ";
PFont font;
float offsetY = 0;

import oscP5.*;
import netP5.*;

// create net address for osc
NetAddress myRemoteLocation;
OscMessage myOscMessage;
int val = 0;

void setup() {
  size(650, 650);
  font = loadFont("SourceCodePro-Regular-18.vlw");
  textFont(font);

  // send the osc messages on port 5000
  myRemoteLocation = new NetAddress("127.0.0.1", 12345);
}

void draw() {
  background(255);
  fill(255, 0, 0);
  text(input, 20, 20+offsetY);
}

void keyPressed() {
  input += key;
  if (input.length() % 55 == 0) input += '\n';

  if (key < 127) { // to only pass original ascii
    val = 127;
    val = key;
    // send values to the OSCsend function below
    OSCsend(val);
    println(val);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  offsetY += 4*e;
}

void OSCsend(int val) {
  // create the osc message
  myOscMessage = new OscMessage("message");

  // add coordinates to osc message
  myOscMessage.add(val);


  // send the OscMessage to the remote location. 
  OscP5.flush(myOscMessage, myRemoteLocation);
}
