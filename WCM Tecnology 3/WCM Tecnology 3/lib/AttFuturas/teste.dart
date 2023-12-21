import 'package:flutter/material.dart';

class WaterConsumption {
  final int month;
  final int year;
  final double consumption;
  final double value;

  WaterConsumption({
    required this.month,
    required this.year,
    required this.consumption,
    required this.value,
  });
}

void main() {
  runApp(MyApp());
}

class WaterConsumptionReportScreen extends StatefulWidget {
  @override
  _WaterConsumptionReportScreenState createState() => _WaterConsumptionReportScreenState();
}

class _WaterConsumptionReportScreenState extends State<WaterConsumptionReportScreen> {
  List<WaterConsumption> waterConsumptionData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Consumo de Água'),
      ),
      body: waterConsumptionData.isEmpty
          ? Center(
              child: Text('Nenhum relatório disponível.'), // Caso a lista esteja vazia
            )
          : ListView(
              children: waterConsumptionData.map((consumption) {
                final totalConsumption = waterConsumptionData
                    .where((item) => item.month == consumption.month && item.year == consumption.year)
                    .fold(0.0, (previous, current) => previous + current.consumption);

                return GestureDetector(
                  onTap: () {
                    // Navegar para a tela de detalhes do mês clicado
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WaterConsumptionDetailScreen(consumption, totalConsumption),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('Mês: ${consumption.month}-${consumption.year}'),
                      subtitle: Text('Consumo Total: $totalConsumption Litros'),
                    ),
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newWaterConsumption = WaterConsumption(
            month: DateTime.now().month,
            year: DateTime.now().year,
            consumption: 27, // Defina o valor apropriado
            value: 167, // Defina o valor apropriado
          );
          setState(() {
            waterConsumptionData.add(newWaterConsumption);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WaterConsumptionDetailScreen extends StatelessWidget {
  final WaterConsumption consumption;
  final double totalConsumption;

  WaterConsumptionDetailScreen(this.consumption, this.totalConsumption);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Consumo de Água'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('Detalhes do Consumo do Mês'),
          Divider(),
          ListTile(
            title: Text('Mês: ${consumption.month}-${consumption.year}'),
            subtitle: Text(
                'Consumo: ${consumption.consumption} Litros | Valor: ${consumption.value} Reais'),
          ),
          Divider(),
          ListTile(
            title: Text('Total do Mês'),
            subtitle: Text('Consumo Total: $totalConsumption Reais'),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Aplicativo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WaterConsumptionReportScreen(),
    );
  }
}
