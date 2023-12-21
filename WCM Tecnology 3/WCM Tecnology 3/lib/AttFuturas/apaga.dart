// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(MaterialApp(
//     home: YearMonthDisplay(),
//   ));
// }

// class YearMonthDisplay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Obtém a data atual
//     DateTime now = DateTime.now();

//     // Obtém o ano e o mês da data atual
//     int year = now.year;
//     int month = now.month;

//     // Formate o mês como uma string (por exemplo, "Janeiro", "Fevereiro", etc.)
//     String monthName = DateFormat.MMMM().format(now); // Requer o pacote intl

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ano e Mês Atuais'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Ano: $year'),
//             Text('Mês: $month'),
//             Text('Nome do Mês: $monthName'),
//           ],
//         ),
//       ),
//     );
//   }
// }
