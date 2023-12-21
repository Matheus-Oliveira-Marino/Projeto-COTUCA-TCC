import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teste_flutter/Pages/TelaCadastro.dart';
import 'package:teste_flutter/Pages/TelaLogin.dart';
import 'package:teste_flutter/Pages/TelaPrincipal.dart';
import 'firebase_options.dart';
import 'package:teste_flutter/Pages/TelaEsquecerSenha.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp( debugShowCheckedModeBanner: false, home: SplashScreen()));
}


 class SplashScreen extends StatefulWidget {
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  
@override
void initState() {
  super.initState();
  // Use Future.delayed em vez de Timer
  Future.delayed(Duration(seconds: 3), () {
    // Navegue para a próxima tela após o tempo especificado
    navigateToLogin();
  });
}



  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TelaLogin(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // Pode personalizar a tela de splash conforme necessário
      
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/WCM.png"),
            ),
          ),
        ),
      ),
    );
  }
}
