class MqttConfig {
  static const String brokerServer = 'test.mosquitto.org'; 
  static const int brokerPort = 1883; 

  static const String clientID = 'iPhone_Marc_App_TFG_Final';

  static const String topicComandos = 'esp32/comandos';
  static const String topicEstado = 'esp32/estado';

  static const String cmdVerdeOn = 'VERDE_ON';
  static const String cmdVerdeOff = 'VERDE_OFF';
  static const String cmdRojoOn = 'ROJO_ON';
  static const String cmdRojoOff = 'ROJO_OFF';
  static const String cmdBeepOK = 'BEEP_OK';
  static const String cmdBeepError = 'BEEP_ERROR';
  static const String cmdBeepClick = 'BEEP_CLICK';
  static const String cmdBeep = 'BEEP';
}