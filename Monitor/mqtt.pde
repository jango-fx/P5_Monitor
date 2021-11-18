import mqtt.*;

MQTTClient mqttClient;

public String mqttServer="mqtt://public:public@public.cloud.shiftr.io";
public String mqttID="P5_Monitor";

public String mqttReceivePattern="*";

public String mqttSendPattern="/world";
public String mqttSendMessage="Hello";


Textfield mqttServerField;
Textfield mqttIDField;

Textfield mqttReceivePatternField;

Bang mqttSendBang;
Textfield mqttSendPatternField;
Textfield mqttSendMessageField;


void initMQTT()
{
  mqttServerField = cp5.addTextfield("mqttServer")
    .setPosition(10, 25)
    .setSize(300, 15)
    .moveTo("mqtt")
    ;
  mqttIDField = cp5.addTextfield("mqttID")
    .setPosition(320, 25)
    .setSize(50, 15)
    .moveTo("mqtt")
    ;
  mqttReceivePatternField = cp5.addTextfield("mqttRecivePattern")
    .setPosition(395, 25)
    .setSize(150, 15)
    .moveTo("mqtt")
    ;

  mqttSendBang = cp5.addBang("sendMqttMsg")
    .setPosition(575, 60)
    //.setSize(50,15)
    .moveTo("mqtt")
    ;

  mqttSendPatternField = cp5.addTextfield("mqttSendPattern")
    .setPosition(575, 25)
    .setSize(150, 15)
    .moveTo("mqtt")
    ;
  mqttSendMessageField = cp5.addTextfield("mqttMessage")
    .setPosition(735, 25)
    .setSize(50, 15)
    .moveTo("mqtt")
    ;
}

void connectMQTT()
{
  println(getTime()+" - [MQTT]: " + "connecting to "+mqttServer);
  mqttClient = new MQTTClient(this);
  mqttClient.connect(mqttServer, mqttID);
}

void disconnectMQTT()
{
  mqttClient.disconnect();
  println(getTime()+" - [MQTT]: " + "disconnected");
}

void publishMQTT() {
  mqttClient.publish(mqttSendPattern, mqttSendMessage);
  println(getTime()+" - [MQTT]: " + "sent "+mqttSendPattern+"/"+mqttSendMessage+"");
}

void clientConnected() {
  println(getTime()+" - [MQTT]: " + "connected");
  mqttClient.subscribe(mqttReceivePattern);
}

void messageReceived(String topic, byte[] payload) {
  println(getTime()+" - [MQTT]: " + topic + " - " + new String(payload));
}

void connectionLost() {
  println(getTime()+" - [MQTT]: " + "connection lost");
}
