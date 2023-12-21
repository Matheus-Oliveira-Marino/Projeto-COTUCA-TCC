import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_flutter/Pages/TelaPerfil.dart';

import '../AttFuturas/taxa.dart';
import '../DadosMobel.dart';
import '../Pages/TelaLogin.dart';
import '../AttFuturas/teste.dart';

class menu extends StatelessWidget 
{
  User? nome = FirebaseAuth.instance.currentUser; 

  @override
  Widget build(BuildContext context) 
  {
    print(nome);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Bem vindo, " + 
              (nome?.displayName ?? "Usuario"),  //userName
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navegar para a tela de home
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
                  Navigator.push(context,  MaterialPageRoute(builder: (context) => WaterCostCalculator()));
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Relatórios'),
            onTap: () 
            {
               Navigator.push(context,  MaterialPageRoute(builder: (context) => WaterConsumptionReportScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              // Navegar para a tela de perfil
              Navigator.push(context,  MaterialPageRoute(builder: (context) => TelaPerfil()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () 
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaLogin()),
              );
            },
          ),
        ],
      ),
    );
  }
}
