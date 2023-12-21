import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:teste_flutter/Pages/TelaLogin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../DadosMobel.dart';

final channel = IOWebSocketChannel.connect('ws://192.168.15.103:80'); // Substitua pelo endereço IP e porta do ESP32

class TelaCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Usuário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<CadastroPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool showWarning = false;
  bool isPasswordVisible = false;

  String? userUid;

  void _togglePasswordVisibility() 
  {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

    // Função para enviar o UID para o Arduino
  void enviarUidParaArduino(String uid) {
    channel.sink.add(uid);
  }

  void _registro(BuildContext context) async {
  try {
    // Verifique se todos os campos estão preenchidos
    if (nomeController.text == "" ||
        sobrenomeController.text == "" ||
        emailController.text == "" ||
        senhaController.text == "") {
      final snackBar = SnackBar(
        content: Text('Por favor, preencha todos os campos.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: senhaController.text);

    User? user = userCredential.user;
    if (user != null) 
    {
      // Obtenha o UID do usuário registrado com sucesso
        userUid = user.uid;
        print(userUid);
        print(user.uid);

      // Crie um nó para o usuário no Firebase Realtime Database
        await _criarNoDeUsuario(user.uid);

        // Envie o UID para o Arduino
        enviarUidParaArduino(userUid!);
    }

    final sucessoSnackBar = SnackBar(
      content: Text('Cadastro realizado com sucesso!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(sucessoSnackBar);
  } catch (e) {
    final erroSnackBar = SnackBar(
      content: Text("Ocorreu um erro durante o cadastro. Verifique o email e a senha."),
    );

    ScaffoldMessenger.of(context).showSnackBar(erroSnackBar);
  }
}

// Função para criar um nó de usuário no Firebase Realtime Database
  Future<void> _criarNoDeUsuario(String userId) async 
  {
  final databaseReference = FirebaseDatabase.instance.reference();
  final userReference = databaseReference.child("users").child(userId);

    // Adicione os dados do usuário ao nó
    await userReference.set({
      "nome": nomeController.text,
      "email": emailController.text,
      "litrosPorMinuto": 0,
      "reais": 0,
      "vazao": 0
      // Outros dados do usuário aqui
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Stack(
        children: [
          // Imagem de fundo ocupando toda a tela
          Image.asset(
            'assets/images/testeCadastro1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              // Centralize os elementos na parte superior da tela
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  if (showWarning)
                    Text(
                      'Preencha todos os campos!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/WCM.png', // Substitua pelo caminho da sua imagem
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextField(
                    controller: nomeController,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextField(
                    controller: sobrenomeController,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Sobrenome',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextField(
                    obscureText: !isPasswordVisible,
                    controller: senhaController,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                       suffixIcon: GestureDetector(
                          onTap: _togglePasswordVisibility,
                          child: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20),),
                  ElevatedButton(
                    onPressed: () => _registro(context),
                    child: Text('Cadastrar'),
                  ),   
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: TelaLogin(),
                          type: PageTransitionType.scale,
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 800),
                          reverseDuration: Duration(milliseconds: 800),
                        ),
                      );
                      //DadosModel().nome = nomeController.text;
                    },
                    child: Text(
                      "Já tem uma conta? Faça login aqui.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
