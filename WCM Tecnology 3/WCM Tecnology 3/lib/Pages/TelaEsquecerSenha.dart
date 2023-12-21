import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:teste_flutter/Pages/TelaCadastro.dart';
import 'package:teste_flutter/Pages/TelaLogin.dart';

class TelaEsquecerSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Usuário',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: EsquecerSenhaPage(),
    );
  }
}

class EsquecerSenhaPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  EsquecerSenhaPage({super.key});

  void _resetPassword(BuildContext context) async {
    try {
      final snackBar = SnackBar(content: Text('Por favor, preencha o campo.'));

      if (emailController.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text);

      if (methods.isEmpty) 
      {
        // O email não está cadastrado
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('O email não está cadastrado.'),
        ));
      }
       else 
      {
        // O email está cadastrado, envie o email de redefinição de senha
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email de redefinição de senha enviado com sucesso.'),
        ));
      }
    }
    catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Redefinir Senha'),
      ),
      body: Center(
        // height: screenHeight,
        // width: screenWidth,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _resetPassword(context),
                  child: Text('Redefinir Senha'),
                ),
                const SizedBox(height: 16.0),
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
                        ));
                  },
                  child: const Text('Já tem uma conta? Faça login aqui'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () 
                  {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: TelaCadastro(),
                          type: PageTransitionType.leftToRightWithFade,
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 600),
                          reverseDuration: Duration(milliseconds: 600),
                        ));
                  },
                  child: const Text("Você ainda não tem uma conta?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
