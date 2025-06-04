import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oil Health Index',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OilHealthPage(),
    );
  }
}

class OilHealthPage extends StatefulWidget {
  const OilHealthPage({super.key});

  @override
  State<OilHealthPage> createState() => _OilHealthPageState();
}

class _OilHealthPageState extends State<OilHealthPage> {
  final voltageController = TextEditingController();
  final moistureController = TextEditingController();
  final acidityController = TextEditingController();
  final colorController = TextEditingController();
  final iftController = TextEditingController();

  double? healthIndex;
  String status = '';

  void calculateHealthIndex() {
    final double voltage = double.tryParse(voltageController.text) ?? 0;
    final double moisture = double.tryParse(moistureController.text) ?? 0;
    final double acidity = double.tryParse(acidityController.text) ?? 0;
    final double color = double.tryParse(colorController.text) ?? 0;
    final double ift = double.tryParse(iftController.text) ?? 0;

    // Sample formula - adjust the weights and normalizing constants as needed
    double index = 
      (voltage / 30) * 0.2 +
      (1 - (moisture / 50)) * 0.2 +
      (1 - (acidity / 1)) * 0.2 +
      (1 - (color / 5)) * 0.2 +
      (ift / 50) * 0.2;

    index = (index.clamp(0.0, 1.0)) * 100;

    setState(() {
      healthIndex = index;
      if (index > 80) {
        status = "Good";
      } else if (index > 60) {
        status = "Fair";
      } else {
        status = "Poor";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transformer Oil Health Index")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: voltageController,
                decoration: const InputDecoration(
                  labelText: "Breakdown Voltage (kV)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: moistureController,
                decoration: const InputDecoration(
                  labelText: "Moisture Content (ppm)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: acidityController,
                decoration: const InputDecoration(
                  labelText: "Acidity (mg KOH/g)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(
                  labelText: "Color",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: iftController,
                decoration: const InputDecoration(
                  labelText: "IFT (mN/m)",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateHealthIndex,
                child: const Text("Calculate Health Index"),
              ),
              const SizedBox(height: 20),
              if (healthIndex != null)
                Column(
                  children: [
                    Text("Health Index: ${healthIndex!.toStringAsFixed(1)}%"),
                    Text("Status: $status"),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
