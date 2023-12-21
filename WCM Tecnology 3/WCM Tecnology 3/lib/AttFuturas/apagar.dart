// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   final channel = IOWebSocketChannel.connect('ws://192.168.15.102:80');

//   void _sendCommand(String command) {
//     channel.sink.add(command);
//     print("Aqui caraio" + command);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('WebSocket Flutter-Arduino'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () {
//                   _sendCommand('A'); // Envia o comando 'A' para o Arduino
//                 },
//                 child: Text('Enviar Comando A'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
