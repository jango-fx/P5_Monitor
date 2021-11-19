import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress oscRemoteLocation;


public int oscRecivePort;
public String oscReceivePattern;

public int oscSendPort;
public String oscSendIP;
public String oscSendPattern;
public String oscSendMessage;

Textfield oscRecivePortField;
Textfield oscPatternField;

Bang oscSendBang;
Textfield oscSendPortField;
Textfield oscSendIPField;


void initOSC()
{
  oscRecivePortField = cp5.addTextfield("oscRecivePort")
    .setPosition(10, 25)
    .setSize(50, 15)  
    .setAutoClear(false)
    .moveTo("osc")
    ;

  oscRemoteLocation = new NetAddress(oscSendIP, oscSendPort);
}

void connectOSC()
{
  println(getTime()+" - [OSC]: " + "connect");
  oscP5 = new OscP5(this, oscRecivePort);
}

void disconnectOSC()
{
  println(getTime()+" - [OSC]: " + "disconnect");

  if (oscP5 != null)
    oscP5.dispose();
}

void updateOSC()
{
}

void oscSend()
{
  OscMessage msg = new OscMessage(oscSendPattern);
  msg.add(oscSendMessage);
  oscP5.send(msg, oscRemoteLocation);
}


void oscEvent(OscMessage msg) {
  println(getTime()+" - [OSC]: "+msg);
}
