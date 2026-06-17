import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'mqtt_config.dart';

class MqttService {
  MqttService._internal();

  static final MqttService _instance = MqttService._internal();

  factory MqttService() => _instance;

  late MqttServerClient _client;
  bool _isConnected = false;
  bool _isConnecting = false;

  bool get isConnected => _isConnected;

  Future<void> inicializarMqtt() async {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    final String idDinamico = '${MqttConfig.clientID}_${DateTime.now().millisecondsSinceEpoch}';
    if (kDebugMode) print('MQTT :: Generado ID: $idDinamico');

    _client = MqttServerClient.withPort(
      MqttConfig.brokerServer, 
      idDinamico, 
      MqttConfig.brokerPort
    );
    
    _client.useWebSocket = false; 
    _client.keepAlivePeriod = 20;
    _client.autoReconnect = true; 
    _client.connectTimeoutPeriod = 4000; 

    _client.onConnected = () {
      _isConnected = true;
      if (kDebugMode) print('MQTT :: ¡Conectado con éxito al Broker Mosquitto!');
      _client.subscribe(MqttConfig.topicEstado, MqttQos.atLeastOnce);
    };

    _client.onDisconnected = () {
      _isConnected = false;
      if (kDebugMode) print('MQTT :: Cliente desconectado del Broker.');
    };

    final MqttConnectMessage connMessage = MqttConnectMessage()
        .withClientIdentifier(idDinamico)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
        
    _client.connectionMessage = connMessage;

    try {
      if (kDebugMode) print('MQTT :: Intentando conectar al broker de la placa...');
      await _client.connect();
    } catch (e) {
      if (kDebugMode) print('MQTT :: Error en la conexión TCP: $e');
      _isConnected = false;
    } {
      _isConnecting = false;
    }
  }

  void enviarComando(String comando) async {
    if (!_isConnected && !_isConnecting) {
      if (kDebugMode) print('MQTT :: Detectada desconexión. Intentando reconexión express...');
      await inicializarMqtt();
      await Future.delayed(const Duration(milliseconds: 800)); 
    }
    
    if (_isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(comando);
      _client.publishMessage(
        MqttConfig.topicComandos,
        MqttQos.exactlyOnce,
        builder.payload!,
      );
      if (kDebugMode) print('MQTT :: Publicando -> $comando');
    } else {
      if (kDebugMode) print('MQTT :: Imposible enviar $comando, el broker no responde.');
    }
  }

  void desconectar() => _client.disconnect();
}