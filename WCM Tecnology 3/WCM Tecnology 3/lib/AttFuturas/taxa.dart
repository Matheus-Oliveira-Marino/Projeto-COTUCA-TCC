import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: WaterCostCalculator(),
//   ));
// }

class WaterCostCalculator extends StatefulWidget {
  @override
  _WaterCostCalculatorState createState() => _WaterCostCalculatorState();
}

class _WaterCostCalculatorState extends State<WaterCostCalculator> {
  TextEditingController rateController = TextEditingController();
  double waterRate = 0.0;
  double waterCost = 0.0;

  void calculateCost() {
    setState(() 
    {
      // Obtém o valor da taxa de água inserida pelo usuário
      String rateText = rateController.text;

      if (rateText.isNotEmpty) 
      {
        waterRate = double.parse(rateText);
      } 
      else 
      {
        waterRate = 0.0;
      }

      // Realiza o cálculo do custo da água com base na vazão e taxa
      waterCost = waterRate; // Supondo que a vazão seja de 1 litro por minuto

      // Atualiza o estado para refletir o custo calculado
      waterCost = waterRate; // Supondo que a vazão seja de 1 litro por minuto
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taxa de Água'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Taxa de Água (Reais/L):'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Insira a taxa de água'),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: calculateCost,
              child: Text('Calcular Custo de Água'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
