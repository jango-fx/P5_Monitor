import processing.serial.*;

ScrollableList baudDropdown;
ScrollableList portDropdown;
Serial port;
int baudRate=115200;
String[] baudRates = {"300", "600", "1200", "2400", "4800", "9600", "14400", "19200", "28800", "31250", "38400", "57600", "115200"};

void initSerial()
{
  //portDropdown = cp5.addScrollableList("SerialPort")
  portDropdown = cp5.addScrollableList("serialPorts")
    .moveTo("serial")
    //.plugTo("serialPorts");
    ;

  baudDropdown = cp5.addScrollableList("baudRate")
    .moveTo("serial")
    ;
}

void updateSerial()
{
  baudDropdown
    .setPosition(10, 45)
    .setSize(200, 100)
    .setBarHeight(15)
    .setItems(java.util.Arrays.asList(baudRates))
    .setValue(12)
    ;

  portDropdown
    .setPosition(10, 25)
    .setSize(200, 100)
    .setBarHeight(15)
    //.setItemHeight(20)
    .setItems(java.util.Arrays.asList(Serial.list()))
    .setValue(Serial.list().length-1)
    .close()
    ;
}

void serialPorts(int n)
{
  if (currentTab == "serial")
  try {
    port = new Serial(this, Serial.list()[n], baudRate);
  }
  catch(Exception e)
  {
    println(e);
  }
}

void serialEvent(Serial inPort) {
  try {
    String msg = inPort.readStringUntil('\n');
    if (msg != null) {
      msg = msg.trim();
      println(getTime()+" - [SERIAL]: "+msg);
    }
  }
  catch (Exception e) {
    println(getTime()+" - [ERROR] serialEvent: ", e);
  }
}
