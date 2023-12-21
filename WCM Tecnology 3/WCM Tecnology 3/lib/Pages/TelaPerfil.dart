import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teste_flutter/firebase_options.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TelaPerfil(),
//     );
//   }
// }


class TelaPerfil extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/profile_image.jpg',
              ),
            ),
            SizedBox(height: 16),
            Text(
              user?.displayName ?? "Usuario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            FutureBuilder<String>(
              future: getEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? "Email não disponível",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  Future<String> getEmail() async {
    try {
      // Verifique se o usuário está autenticado
      if (user != null) {
        String email = user!.email ?? "Email não disponível";
        print("Email do usuário: $email");
        return email;
      } else {
        print("Usuário não autenticado");
        return "Usuário não autenticado";
      }
    } catch (e) {
      print("Erro ao obter o email: $e");
      return "Erro ao obter o email";
    }
  }
}


