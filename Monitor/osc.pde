import java.net.*;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress oscRemoteLocation;


public int oscReceivePort;
public String oscReceivePattern;

public int oscSendPort;
public String oscSendIP;
public String oscSendPattern;
public String oscSendMessage;

Textfield oscReceivePortField;
Textfield oscReceivePatternField;

Textfield oscSendPortField;
Textfield oscSendIPField;
Textfield oscSendPatternField;
Textfield oscSendMessageField;
Bang oscSendBang;


void initOSC()
{
  oscReceivePortField = cp5.addTextfield("oscRecivePortString")
    .setPosition(10, 25)
    .setSize(50, 15)
    .setText("12000")
    .setLabel("port incoming")
    .setAutoClear(false)
    .moveTo("osc")
    ;

  oscReceivePatternField = cp5.addTextfield("oscReceivePattern")
    .setPosition(10, 60)
    .setSize(50, 15)
    .setText("/*")
    .setLabel("Receive Pattern")
    .setAutoClear(false)
    .moveTo("osc")
    ;

  oscSendPortField = cp5.addTextfield("oscSendPortString")
    .setPosition(10, 120)
    .setSize(50, 15)
    .setText("10000")
    .setLabel("port outgoing")
    .setAutoClear(false)
    .moveTo("osc")
    ;
  oscSendIPField = cp5.addTextfield("oscSendIP")
    .setPosition(10, 155)
    .setSize(50, 15)
    .setText("127.0.0.1")
    .setLabel("ip outgoing")
    .setAutoClear(false)
    .moveTo("osc")
    ;
  oscSendPatternField = cp5.addTextfield("oscSendPattern")
    .setPosition(10, 190)
    .setSize(200, 15)
    .setText("/monitor")
    .setLabel("send pattern")
    .setAutoClear(false)
    .moveTo("osc")
    ;
  oscSendMessageField = cp5.addTextfield("oscSendMessage")
    .setPosition(10, 225)
    .setSize(200, 15)
    .setText("test")
    .setLabel("message")
    .setAutoClear(false)
    .moveTo("osc")
    ;
  oscSendBang = cp5.addBang("oscSend")
    .setPosition(10, 260)
    .moveTo("osc")
    ;

  oscSendPort = int(oscSendPortField.getText());
  oscReceivePort = int(oscReceivePortField.getText());
}

void oscRecivePortString(String s)
{
  oscReceivePort = int(s);
  connectOSC();
}

void oscSendPortString(String s)
{
  oscSendPort = int(s);
}

void connectOSC()
{
  getIP();
  println(getTime()+" - [OSC]: " + "connect");
  oscP5 = new OscP5(this, oscReceivePort);
}

void disconnectOSC()
{
  println(getTime()+" - [OSC]: " + "disconnect");

  if (oscP5 != null)
    oscP5.dispose();
}

void oscSend()
{
  oscSendIP = cp5.get(Textfield.class, "oscSendIP").getText();
  oscSendPort = int(cp5.get(Textfield.class, "oscSendPortString").getText());
  oscRemoteLocation = new NetAddress(oscSendIP, oscSendPort);

  oscSendPattern = cp5.get(Textfield.class, "oscSendPattern").getText();
  oscSendMessage = cp5.get(Textfield.class, "oscSendMessage").getText();
  OscMessage msg = new OscMessage(oscSendPattern);
  msg.add(oscSendMessage);
  oscP5.send(msg, oscRemoteLocation);
  
  println(getTime()+" - [OSC]: "+" outgoing "+oscSendIP+":"+oscSendPort+"   "  +msg.addrPattern()+" = "+java.util.Arrays.toString(msg.arguments()));
}


void oscEvent(OscMessage msg) {

  println(getTime()+" - [OSC]: "+" incoming "+msg.address()+":"+msg.port()+"   "  +msg.addrPattern()+" = "+java.util.Arrays.toString(msg.arguments()));
}

void getIP()
{
  try {
    //String ip = java.net.Inet4Address.getLocalHost().getHostAddress();

    println(getTime()+" - [OSC]: " + "all possible IP addresses:");

    java.util.Enumeration e = NetworkInterface.getNetworkInterfaces();
    while (e.hasMoreElements())
    {
      NetworkInterface n = (NetworkInterface) e.nextElement();
      java.util.Enumeration ee = n.getInetAddresses();
      while (ee.hasMoreElements())
      {
        InetAddress i = (InetAddress) ee.nextElement();
        String ip = i.getHostAddress();
        if (ip.length() < 15)
          System.out.println("  "+ ip);
      }
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}
