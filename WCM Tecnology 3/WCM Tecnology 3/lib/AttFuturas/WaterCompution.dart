class WaterConsumption {
  final int month;
  final int year;
  final double consumption;
  final double value;

  WaterConsumption({required this.month, required this.year, required this.consumption, required this.value});
}

DateTime now = DateTime.now();

  int year = now.year;
  int month = now.month;

List<WaterConsumption> waterConsumptionData = [
  WaterConsumption(month: 1, year: 2023, consumption: 100.0, value:23),
  WaterConsumption(month: month, year: year, consumption: 0, value: 0),
];
