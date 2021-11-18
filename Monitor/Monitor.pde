// general network protocol monitor:
// * serial
// * osc
// * midi
// * mqtt
// * websockets
// * artnet

import processing.serial.*;
import controlP5.*;

int windowWidth, windowHeight;

ControlP5 cp5;
String currentTab;
Textarea consoleArea;
Println console;
Toggle autoscroll;
Bang clear;
public boolean scroll=true;

// int cfg, int cbg, int cactive, int ccl, int cvl
CColor serialColor = new CColor(color(0, 0, 255), color(255, 255, 0), color(255, 200, 0), color(255), color(255));
color oscColor;
color mqttColor;
color wsColor;
color midiColor;
color artnetColor;

void settings()
{
  size(800, 600);
}
void setup()
{
  surface.setResizable(true);
  registerMethod("pre", this);

  cp5 = new ControlP5(this);
  cp5.addTab("serial").activateEvent(true).setColorBackground(color(255, 222, 0, 150));
  cp5.addTab("websockets").activateEvent(true).setColorBackground(color(240, 255, 0, 150));
  cp5.addTab("mqtt").activateEvent(true).setColorBackground(color(180, 255, 0, 150));
  cp5.addTab("osc").activateEvent(true).setColorBackground(color(0, 240, 255, 150));
  cp5.addTab("artnet").activateEvent(true).setColorBackground(color(180, 0, 235, 150));
  cp5.addTab("midi").activateEvent(true).setColorBackground(color(255, 0, 140, 150));

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

  consoleArea = cp5.addTextarea("txt")
    .setPosition(10, 100)
    .setLineHeight(12)
    .setColorBackground(color(30))
    .setColorForeground(color(255, 50))
    .moveTo("global");
  ;
  console = cp5.addConsole(consoleArea);

  initSerial();
  initOSC();
  initMQTT();
  initWS();
  initARTNET();
  initMIDI();
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

  consoleArea
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
  if (theEvent.isTab()) {
    currentTab = theEvent.getTab().getName();
    if (currentTab == "serial") {
      updateSerial();
    } else {
      if (port !=null) port.stop();
    }
    if (currentTab == "mqtt") {
      connectMQTT();
    } else {
      disconnectMQTT();
    }
    if (currentTab == "osc")
      connectOSC();
    else
      disconnectOSC();
  }
}

String getTime() {
  return new java.text.SimpleDateFormat("HH:mm:ss.SSSS", java.util.Locale.GERMANY).format(new java.util.Date());
}
