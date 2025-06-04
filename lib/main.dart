import 'package:flutter/material.dart';

void main() => runApp(OilHealthApp());

class OilHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oil Health Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OilHealthHomePage(),
    );
  }
}

class OilHealthHomePage extends StatefulWidget {
  @override
  _OilHealthHomePageState createState() => _OilHealthHomePageState();
}

class _OilHealthHomePageState extends State<OilHealthHomePage> {
  final TextEditingController breakdownController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController acidController = TextEditingController();
  final TextEditingController iftController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  String result = '';

  void calculateOilHealth() {
    final double CONSTANT_A = 0.169;
    final double CONSTANT_B = 0.108;
    final double CONSTANT_C = 0.139;
    final double CONSTANT_D = 0.124;
    final double CONSTANT_E = 0.114;

    double num1 = double.tryParse(breakdownController.text) ?? 0;
    double num2 = double.tryParse(waterController.text) ?? 0;
    double num3 = double.tryParse(acidController.text) ?? 0;
    double num4 = double.tryParse(iftController.text) ?? 0;
    double num5 = double.tryParse(colorController.text) ?? 0;

    int scoreBV = (num1 > 50) ? 1 : (num1 >= 45) ? 2 : (num1 >= 40) ? 3 : 4;
    int scoreWater = (num2 < 20) ? 1 : (num2 <= 25) ? 2 : (num2 <= 30) ? 3 : 4;
    int scoreAcid = (num3 < 0.1) ? 1 : (num3 <= 0.15) ? 2 : (num3 <= 0.2) ? 3 : 4;
    int scoreIFT = (num4 > 35) ? 1 : (num4 >= 25) ? 2 : (num4 >= 20) ? 3 : 4;
    int scoreColor = (num5 < 1.5) ? 1 : (num5 <= 2) ? 2 : (num5 <= 2.5) ? 3 : 4;

    double totalOilHealth = (scoreBV * CONSTANT_A) +
        (scoreWater * CONSTANT_B) +
        (scoreAcid * CONSTANT_C) +
        (scoreIFT * CONSTANT_D) +
        (scoreColor * CONSTANT_E);

    double sumOfConstants = CONSTANT_A + CONSTANT_B + CONSTANT_C + CONSTANT_D + CONSTANT_E;
    double finalResult = totalOilHealth / sumOfConstants;

    String grade;
    int gradeValue;
    String desc;

    if (finalResult < 1.2) {
      grade = "Grade A";
      gradeValue = 4;
      desc = "VERY GOOD (VR)";
    } else if (finalResult < 1.5) {
      grade = "Grade B";
      gradeValue = 3;
      desc = "GOOD (G)";
    } else if (finalResult < 2.0) {
      grade = "Grade C";
      gradeValue = 2;
      desc = "CAUTION (C)";
    } else if (finalResult <= 3.0) {
      grade = "Grade D";
      gradeValue = 1;
      desc = "POOR (P)";
    } else {
      grade = "Grade E";
      gradeValue = 0;
      desc = "VERY POOR (VP)";
    }

    double description = (gradeValue / 4.0) * 100;

    setState(() {
      result = '''
--- SCORES ---
Breakdown Voltage Score: $scoreBV
Water Content Score: $scoreWater
Acid Value Score: $scoreAcid
Interfacial Tension Score: $scoreIFT
Color Value Score: $scoreColor

--- CALCULATION RESULTS ---
TOTAL HEALTH = ${totalOilHealth.toStringAsFixed(3)}
OIL HEALTH INDEX FACTOR = ${finalResult.toStringAsFixed(3)}

--- OIL CONDITION ---
OIL RATING CODE = $grade
OIL SCORE FACTOR = $gradeValue

--- DESCRIPTION ---
(SCORE FACTOR / 4) * 100% = ${description.toStringAsFixed(0)}%
YOUR OIL IS $desc
''';
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transformer Oil Health Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField("Breakdown Voltage", breakdownController),
            buildTextField("Water Content", waterController),
            buildTextField("Acid Value", acidController),
            buildTextField("Interfacial Tension (IFT)", iftController),
            buildTextField("Color Value", colorController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateOilHealth,
              child: Text("Calculate"),
            ),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}