// general network protocol monitor:
// * serial
// * osc
// * midi
// * mqtt
// * websockets
// * artnet

import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
Textarea textarea;
Println console;
Toggle autoscroll;
Bang clear;
public boolean scroll=true;
int tab;

int windowWidth, windowHeight;
void settings()
{
  size(800, 600);
}
void setup()
{
  surface.setResizable(true);
  registerMethod("pre", this);

  cp5 = new ControlP5(this);
  cp5.addTab("serial").activateEvent(true);
  cp5.addTab("osc").activateEvent(true);
  cp5.addTab("mqtt").activateEvent(true);
  cp5.addTab("websockets").activateEvent(true);
  cp5.addTab("midi").activateEvent(true);
  cp5.addTab("artnet").activateEvent(true);

  autoscroll = cp5.addToggle("scroll")
    .setPosition(10, 70)
    .setSize(20, 10)
    .moveTo("global");
  ;

  clear = cp5.addBang("clear")
    .setPosition(50, 70)
    .setSize(20, 10)
    .moveTo("global");
  ;

  textarea = cp5.addTextarea("txt")
    .setPosition(10, 100)
    .setLineHeight(12)
    .setColorBackground(color(30))
    .setColorForeground(color(255, 50))
    .moveTo("global");
  ;
  console = cp5.addConsole(textarea);

  initSerial();
}

void pre() {
  if (windowWidth != width || windowHeight != height) {
    windowWidth = width;
    windowHeight = height;
    updateUI();
  }
}

void updateUI()
{
  updateSerial();

  textarea
    .setSize(width-20, height-105)
    ;
}

void draw()
{
  background(0);
  //println(frameCount+": "+frameRate);
  if (scroll) console.play();
  else console.pause();
}

void clear()
{
  console.clear();
}

void controlEvent(ControlEvent theEvent) {
  println("!");
  if (theEvent.isTab()) {
    String name = theEvent.getTab().getName();
    if (name == "serial")
      updateSerial();
    else
      port.stop();
  }
}

String getTime() {
  return new java.text.SimpleDateFormat("HH:mm:ss.SSSS", java.util.Locale.GERMANY).format(new java.util.Date());
}
