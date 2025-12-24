import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/exercise_provider.dart';
import '../providers/auth_provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Latihan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Olahraga',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Durasi (menit)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? 'Isi durasi' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Kalori',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? 'Isi kalori' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // AMBIL USER YANG SEDANG LOGIN
                      final user = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error: User tidak ditemukan"),
                          ),
                        );
                        return;
                      }

                      final newExercise = Exercise(
                        id: '',
                        userId: user.id, // <--- MASUKKAN ID DISINI
                        activityName: _activityController.text,
                        duration: int.parse(_durationController.text),
                        calories: int.parse(_caloriesController.text),
                        date: DateTime.now().toString().split(' ')[0],
                      );

                      // 1. Simpan data
                      final success = await Provider.of<ExerciseProvider>(
                        context,
                        listen: false,
                      ).addExercise(newExercise);

                      // 2. Cek mounted
                      if (!mounted) return;

                      // 3. Tutup layar jika sukses
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gagal menyimpan data")),
                        );
                      }
                    }
                  },
                  child: const Text("SIMPAN DATA"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
