// inspired by https://github.com/sojamo/midimapper/tree/master/src/main/java/sojamo/midimapper

import javax.sound.midi.*;

String deviceName = "networkMIDI-1";
MidiReceiver midiReceiver;


void initMIDI()
{
  connect(deviceName, new MidiReceiver("midiReceiver"));
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


public final void connect(final String theName, final Receiver... theReceivers) {
  try {
    MidiDevice device;
    device = MidiSystem.getMidiDevice(getMidiDeviceInfo(theName, false));
    device.open();
    for (Receiver receiver : theReceivers) {
      Transmitter transmitter = device.getTransmitter();
      transmitter.setReceiver(receiver);
    }
  }
  catch (MidiUnavailableException e) {
    e.printStackTrace();
  }
  catch (NullPointerException e) {
    println(getTime()+" - [MQTT]: " + "No Midi device " + theName + " is available.");
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

    println(getTime()+" - [MIDI]: " + midi.type + "\t " + midi.note + "\t " + midi.pressure + " (" + midi.device + ")");
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
