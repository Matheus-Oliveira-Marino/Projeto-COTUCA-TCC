import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:teste_flutter/Pages/TelaCadastro.dart';
import 'package:teste_flutter/Pages/TelaEsquecerSenha.dart';
import 'package:web_socket_channel/io.dart';
import 'TelaPrincipal.dart';

final channel = IOWebSocketChannel.connect('ws://192.168.138.224:80'); 

class TelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Usuário',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

      // Função para enviar o UID para o Arduino
  void enviarUidParaArduino(String uid) {
    channel.sink.add(uid);
  }

  void _loginUser(BuildContext context) async {
    try {
      if (emailController.text == "" || passwordController.text == "") {
        final snackBar = SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Login bem-sucedido, você pode navegar para a próxima tela ou realizar ações adicionais aqui.
      User? user = FirebaseAuth.instance.currentUser; 
      final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Agora você pode navegar para a TelaPrincipal e passar o usuário
    if (user != null) {
      enviarUidParaArduino(user.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaPrincipal(user: user, databaseReference: databaseReference,),
        ),
      );
    }
    } on FirebaseAuthException catch (e) 
    {
      if (e.code == 'wrong-password') {
        // Senha incorreta, exiba um snackbar com a mensagem de erro.
        final snackBar = SnackBar(
          content: Text('Senha incorreta. Tente novamente.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'user-not-found') {
        // Email não cadastrado, exiba uma mensagem de erro.
        final snackBar = SnackBar(
          content: Text('O e-mail não está cadastrado.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Outro erro, você pode lidar com isso de acordo com suas necessidades.
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Login de Usuário')),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/teste.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.1),
                    child: Container(
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
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Digite seu email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: GestureDetector(
                          onTap: _togglePasswordVisibility,
                          child: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(9.8)),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () => _loginUser(context),
                    child: Text('Entrar'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: TelaCadastro(),
                          type: PageTransitionType.topToBottom,
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 600),
                          reverseDuration: Duration(milliseconds: 600),
                        ),
                      );
                    },
                    child: const Text("Você ainda não tem uma conta?"),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: TelaEsquecerSenha(),
                          type: PageTransitionType.rightToLeft,
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 600),
                          reverseDuration: Duration(milliseconds: 600),
                        ),
                      );
                    },
                    child: const Text('Esqueceu sua senha?'),
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
