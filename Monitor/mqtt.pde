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

ScrollableList mqttSubscriptionDrowdown;



void initMQTT()
{
  mqttServerField = cp5.addTextfield("mqttServer")
    .setPosition(10, 25)
    .setSize(200, 15)
    .setValue(mqttServer)
    .setLabel("url")
    .setAutoClear(false)
    .moveTo("mqtt")
    ;
  mqttIDField = cp5.addTextfield("mqttID")
    .setPosition(10, 55)
    .setSize(200, 15)
    .setValue(mqttID)
    .setLabel("client id")
    .setAutoClear(false)
    .moveTo("mqtt")
    ;

  mqttSendBang = cp5.addBang("connectMQTT")
    .setPosition(10, 90)
    .setSize(30, 15)
    .setLabel("connect")
    .moveTo("mqtt")
    ;

  mqttReceivePatternField = cp5.addTextfield("mqttReceivePattern")
    .setPosition(10, 140)
    .setSize(120, 15)
    .setValue(mqttReceivePattern)
    .setLabel("receive pattern")
    .setAutoClear(false)
    .moveTo("mqtt")
    ;

  mqttSendBang = cp5.addBang("subscribeMQTT")
    .setPosition(140, 140)
    .setSize(30, 15)
    .setLabel("sub")
    .moveTo("mqtt")
    ;
  mqttSendBang = cp5.addBang("unsubscribeMQTT")
    .setPosition(180, 140)
    .setSize(30, 15)
    .setLabel("unsub")
    .moveTo("mqtt")
    ;
  mqttSendPatternField = cp5.addTextfield("mqttSendPattern")
    .setPosition(10, 190)
    .setSize(200, 15)
    .setValue(mqttSendPattern)
    .setLabel("send pattern")
    .setAutoClear(false)
    .moveTo("mqtt")
    ;
  mqttSendMessageField = cp5.addTextfield("mqttSendMessage")
    .setPosition(10, 225)
    .setSize(200, 15)
    .setValue(mqttSendMessage)
    .setLabel("message")
    .setAutoClear(false)
    .moveTo("mqtt")
    ;
  mqttSendBang = cp5.addBang("publishMQTT")
    .setPosition(10, 260)
    .setSize(30, 15)
    .setLabel("publish")
    .moveTo("mqtt")
    ;

  cp5.addLabel("Subscriptions")
    .setPosition(5, 310)
    .moveTo("mqtt")
    ;

  mqttSubscriptionDrowdown = cp5.addScrollableList("mqttSubscriptions")
    .setPosition(10, 325)
    .setSize(200, 100)
    .setBarHeight(15)
    .open()
    .lock()
    .setBarVisible(false)
    .setColorBackground(color(0, 45, 90, 100))
    .moveTo("mqtt")
    ;
}

void connectMQTT()
{
  mqttServer = cp5.get(Textfield.class, "mqttServer").getText();
  mqttID = cp5.get(Textfield.class, "mqttID").getText();

  println(getTime()+" - [MQTT]: " + "connecting as "+ mqttID +" to "+ mqttServer);
  mqttClient = new MQTTClient(this);
  mqttClient.connect(mqttServer, mqttID);
}

void subscribeMQTT()
{
  mqttReceivePattern = cp5.get(Textfield.class, "mqttReceivePattern").getText();
  println(getTime()+" - [MQTT]: " + "subscribe to: "+mqttReceivePattern);
  mqttClient.subscribe(mqttReceivePattern);
  mqttSubscriptionDrowdown.addItem(mqttReceivePattern, 0);
}

void unsubscribeMQTT()
{
  mqttReceivePattern = cp5.get(Textfield.class, "mqttReceivePattern").getText();
  println(getTime()+" - [MQTT]: " + "unsubscribe from: "+mqttReceivePattern);
  mqttClient.unsubscribe(mqttReceivePattern);
  mqttSubscriptionDrowdown.removeItem(mqttReceivePattern);
}

void mqttSubscriptions(int n)
{
  println(mqttSubscriptionDrowdown.getItem(n));
  mqttSubscriptionDrowdown.open();
  //mqttReceivePatternField.setText(mqttSubscriptionDrowdown.getItem(n).getKey(n));
}

void disconnectMQTT()
{
  println(getTime()+" - [MQTT]: " + "disconnect");

  if (mqttClient != null) {
    mqttClient.disconnect();
    println(getTime()+" - [MQTT]: " + "disconnected");
  }
}

void publishMQTT() {
  mqttClient.publish(mqttSendPattern, mqttSendMessage);
  println(getTime()+" - [MQTT]: " + "sent "+mqttSendPattern+"/"+mqttSendMessage+"");
}

void clientConnected() {
  println(getTime()+" - [MQTT]: " + "connected");
  //subscribeMQTT();
}

void messageReceived(String topic, byte[] payload) {
  println(getTime()+" - [MQTT]: " + topic + "/" + new String(payload));
}

void connectionLost() {
  println(getTime()+" - [MQTT]: " + "connection lost");
}
