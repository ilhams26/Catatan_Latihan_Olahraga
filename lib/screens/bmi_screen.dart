import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  double _weight = 60;
  double _height = 170;
  double _bmi = 0;

  @override
  void initState() {
    super.initState();
    // Ambil data user jika ada
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null && user.weight > 0 && user.height > 0) {
      _weight = user.weight.toDouble();
      _height = user.height.toDouble();
      _calculateBMI();
    }
  }

  void _calculateBMI() {
    setState(() {
      // Rumus BMI = Berat (kg) / (Tinggi (m) * Tinggi (m))
      double heightInMeter = _height / 100;
      _bmi = _weight / (heightInMeter * heightInMeter);
    });
  }

  // Menentukan Kategori BMI
  String getResult() {
    if (_bmi < 18.5) return "Kurus (Underweight)";
    if (_bmi < 25) return "Normal";
    if (_bmi < 30) return "Gemuk (Overweight)";
    return "Obesitas";
  }

  Color getColor() {
    if (_bmi < 18.5) return Colors.blue;
    if (_bmi < 25) return Colors.green;
    if (_bmi < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator BMI")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // CARD HASIL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _bmi == 0
                    ? (isDark ? Colors.grey[800] : Colors.blue[50])
                    : getColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _bmi == 0 ? Colors.transparent : getColor(),
                ),
              ),
              child: Column(
                children: [
                  const Text("Hasil BMI Kamu", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _bmi == 0 ? Colors.grey : getColor(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _bmi == 0 ? "Masukkan data" : getResult(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _bmi == 0 ? Colors.grey : getColor(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // INPUT BERAT
            const Text("Berat Badan (kg)"),
            Slider(
              value: _weight,
              min: 30,
              max: 150,
              activeColor: Colors.blueAccent,
              label: _weight.round().toString(),
              onChanged: (val) {
                setState(() => _weight = val);
                _calculateBMI();
              },
            ),
            Text(
              "${_weight.round()} kg",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // INPUT TINGGI
            const Text("Tinggi Badan (cm)"),
            Slider(
              value: _height,
              min: 100,
              max: 220,
              activeColor: Colors.blueAccent,
              label: _height.round().toString(),
              onChanged: (val) {
                setState(() => _height = val);
                _calculateBMI();
              },
            ),
            Text(
              "${_height.round()} cm",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
