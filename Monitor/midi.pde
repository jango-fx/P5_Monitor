// inspired by https://github.com/sojamo/midimapper/tree/master/src/main/java/sojamo/midimapper

import javax.sound.midi.*;

String deviceName = "networkMIDI-1";
MidiReceiver midiReceiver;

ScrollableList deviceDropdown;


void initMIDI()
{
  deviceDropdown = cp5.addScrollableList("midiDevices")
    .setPosition(10, 25)
    .setSize(200, 100)
    .setBarHeight(15)
    .setItems(java.util.Arrays.asList(getInputDevices()) )
    .close()
    .moveTo("midi")
    ;
}


void midiDevices(int n)
{
  if (currentTab == "midi")
  try {
    connectMIDI(deviceName, new MidiReceiver("midiReceiver"));
  }
  catch(Exception e)
  {
    println(e);
  }
}


String[] getInputDevices()
{
  MidiDevice.Info[] list = MidiSystem.getMidiDeviceInfo();
  String thePattern = "";
  ArrayList<String> found = new ArrayList<String>();
  String[] result = new String[0];
  for (int i = 0; i < list.length; i++)
  {
    try {
      MidiDevice device = MidiSystem.getMidiDevice(list[i]);
      boolean in = (device.getMaxTransmitters() != 0);
      boolean out = (device.getMaxReceivers() != 0);
      String pattern = "(?i)^.*?(" + thePattern + ").*$";
      boolean a = list[i].getName().matches(thePattern);
      boolean b = list[i].getVendor().matches(thePattern);
      boolean c = list[i].getDescription().matches(thePattern);
      if (thePattern.length() == 0 || (a || b || c)) {
        //found.add(toMap(k_id, i, k_name, info[i].getName(), k_in, in, k_out, out, k_vendor, info[i].getVendor(), k_version, info[i].getVersion(), "description", info[i].getDescription()));
        if (in)
          found.add(list[i].getName());
      }
    }
    catch (MidiUnavailableException e) {
      e.printStackTrace();
    }
  }

  result = found.toArray(result);
  return result;
}

void midiSend(int theCommand, int theChannel, int theData1, int theData2, int theTimeStamp) {
  /* send a midi message through the default midi interface
   * int theChannel corresponds to the channel where this message will be sent to
   * int theData1 corresponds to the id of the midi message
   * int theData2 is an int value between 0-127
   */
  ShortMessage msg = new ShortMessage();
  try {
    msg.setMessage(theCommand, theChannel, theData1, theData2);
    MidiSystem.getReceiver().send(msg, theTimeStamp);
  }
  catch (MidiUnavailableException e) {
    e.printStackTrace();
  }
  catch (InvalidMidiDataException | NullPointerException e) {
    System.err.println(e.getMessage());
  }
}


void connectMIDI(final String theName, final Receiver... theReceivers) {
  println(getTime()+" - [MIDI]: " + "connecting to "+ deviceName);
  try {
    MidiDevice device;
    device = MidiSystem.getMidiDevice(getMidiDeviceInfo(theName, false));
    device.open();
    for (Receiver receiver : theReceivers) {
      Transmitter transmitter = device.getTransmitter();
      transmitter.setReceiver(receiver);
    }
    println(getTime()+" - [MIDI]: " + "connected");
  }
  catch (MidiUnavailableException e) {
    e.printStackTrace();
  }
  catch (NullPointerException e) {
    println(getTime()+" - [MIDI]: " + "No Midi device " + theName + " is available.");
  }
}

void disconnectMIDI()
{
  println(getTime()+" - [MIDI]: " + "disconnect");

  try {
    MidiDevice device = MidiSystem.getMidiDevice(getMidiDeviceInfo(deviceName, false));

    if (device != null && device.isOpen()) {
      device.close();
    }
    println(getTime()+" - [MIDI]: " + "disconnected");
  }
  catch (MidiUnavailableException e) {
    e.printStackTrace();
  }
  catch (NullPointerException e) {
    println(getTime()+" - [MIDI]: " + "No Midi device " + deviceName + " is available.");
  }
}

class MidiReceiver implements Receiver {

  final String name;

  MidiReceiver(String theName) {
    name = theName;
  }

  void send(final MidiMessage msg, final long timeStamp) {

    byte[] b = msg.getMessage();
    MidiMsg midi = new MidiMsg();
    midi.device = name;
    midi.type = midi.types.get(b[0]);
    midi.status = msg.getStatus();

    if (midi.type != "Channel Pressure") {
      midi.note = b[1];
      midi.pressure = b[2];
    } else {
      midi.pressure = b[1];
    }
    midi.timestamp = timeStamp;

    println(getTime()+" - [MIDI]: " + midi.type + "\t " + midi.note + "\t " + midi.pressure + " (" + deviceName + ")");
  }

  public void close() {
  }
}


class MidiMsg {
  String device;
  String type;
  int status;
  int note;
  int pressure;
  long timestamp;

  HashMap<Byte, String> types = new HashMap<>();

  MidiMsg() {
    types.put((byte) -112, "Note On");
    types.put((byte) -128, "Note Off");
    types.put((byte) -48, "Channel Pressure");
    types.put((byte) -80, "Continuous Controller");
  }
}


MidiDevice.Info getMidiDeviceInfo(final String theDeviceName, final boolean theOutput) {
  MidiDevice.Info[] aInfos = MidiSystem.getMidiDeviceInfo();
  for (int i = 0; i < aInfos.length; i++) {
    if (aInfos[i].getName().equals(theDeviceName)) {
      try {
        MidiDevice device = MidiSystem.getMidiDevice(aInfos[i]);
        boolean allowsInput = (device.getMaxTransmitters() != 0);
        boolean allowsOutput = (device.getMaxReceivers() != 0);
        if ((allowsOutput && theOutput) || (allowsInput && !theOutput)) {
          return aInfos[i];
        }
      }
      catch (MidiUnavailableException e) {
      }
    }
  }
  return null;
}
