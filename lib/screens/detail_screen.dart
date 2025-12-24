import 'package:flutter/material.dart';
import '../models/exercise.dart';

class DetailScreen extends StatelessWidget {
  final Exercise exercise;

  const DetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: const Text("Detail Latihan"),
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image / Icon Besar
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[900]
                    : Colors.blueAccent.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'exercise-${exercise.id}',
                  child: Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: isDark ? Colors.blueAccent : Colors.blue,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Konten Detail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      exercise.activityName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Chip(
                      label: Text(
                        exercise.date,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Statistik Grid
                  Row(
                    children: [
                      _buildDetailCard(
                        context,
                        title: "Durasi",
                        value: "${exercise.duration} Menit",
                        icon: Icons.timer,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      _buildDetailCard(
                        context,
                        title: "Kalori",
                        value: "${exercise.calories} Kkal",
                        icon: Icons.local_fire_department,
                        color: Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Catatan!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exercise.calories > 300
                              ? "Wow! Kamu membakar banyak kalori hari ini. Pertahankan!"
                              : "Setiap langkah berarti. Teruslah bergerak!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
