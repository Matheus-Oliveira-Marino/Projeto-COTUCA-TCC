import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Widgets/menu.dart';

class TelaPrincipal extends StatefulWidget {
  final User user; // Usuário autenticado
  final DatabaseReference databaseReference;

  TelaPrincipal({required this.user, required this.databaseReference});

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  TextEditingController litrosPorMinutoController = TextEditingController();
  TextEditingController valorEmReaisController = TextEditingController();
  TextEditingController volumeTotalController = TextEditingController();

  @override
  void initState() 
  {
    super.initState();
    // Buscar os dados do Firebase assim que a tela for carregada
    //buscarDadosDoFirebase();

     // Adicionar um listener para atualizações em tempo real no Firebase
    String pathNoFirebase = 'users/${widget.user.uid}';
    widget.databaseReference.child(pathNoFirebase).onValue.listen((event) {
      // Atualize a interface do usuário com os novos dados recebidos do Firebase
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          litrosPorMinutoController.text = data['litrosPorMinuto'].toString();
          valorEmReaisController.text = data['reais'].toString(); // Certifique-se de que o nome do campo está correto
          volumeTotalController.text = data['vazao'].toString();
        });
      }
    });
  }

  // void buscarDadosDoFirebase() {
  //   String pathNoFirebase = 'users/${widget.user.uid}';

  //   widget.databaseReference.child(pathNoFirebase).once().then(
  //     (DatabaseEvent snapshot) {
  //       if (snapshot.snapshot.value != null) {
  //         print('Dados do Firebase: ${snapshot.snapshot.value}'); // Verifique os dados no console

  //         // Use cast para informar ao Dart o tipo esperado dos dados em snapshot.value
  //         final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

  //         setState(() {
  //           litrosPorMinutoController.text = data['litrosPorMinuto'].toString();
  //           valorEmReaisController.text = data['reais'].toString(); // Certifique-se de que o nome do campo está correto
  //           volumeTotalController.text = data['vazao'].toString();
  //         });
  //       }
  //     },
  //   );
  // }




  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      drawer: menu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('WCM Technology'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/WCM.png',
                width: isSmallScreen ? 150 : 280,
                height: isSmallScreen ? 150 : 280,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Litros/min: ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 16,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: litrosPorMinutoController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Valor(Reais): ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 16,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: valorEmReaisController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Volume Total: ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 16,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: volumeTotalController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
