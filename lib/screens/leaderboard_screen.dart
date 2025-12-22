import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/exercise_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Hitung total kalori user kita sendiri
    int myCalories = 0;
    for (var item in exerciseProvider.exercises) {
      myCalories += item.calories;
    }

    // Data Dummy User Lain (Supaya terlihat ramai)
    final List<Map<String, dynamic>> leaderboardData = [
      {'name': 'Rian Gymrat', 'calories': 4500},
      {'name': 'Siti Runner', 'calories': 3200},
      {'name': 'Budi Strong', 'calories': 2800},
      {'name': 'Dina Fit', 'calories': 2100},
      // Masukkan User kita ke dalam list ini
      {'name': '${auth.username} (You)', 'calories': myCalories, 'isMe': true},
      {'name': 'Joko Santai', 'calories': 1500},
    ];

    // Urutkan dari yang terbesar
    leaderboardData.sort((a, b) => b['calories'].compareTo(a['calories']));

    return Scaffold(
      appBar: AppBar(title: const Text("Papan Peringkat")),
      body: Column(
        children: [
          // Top 3 Podium (Visualisasi Sederhana)
          Container(
            padding: const EdgeInsets.all(20),
            color: isDark ? Colors.grey[900] : Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodium(
                  leaderboardData[1],
                  2,
                  80,
                  Colors.grey[300]!,
                ), // Juara 2
                _buildPodium(
                  leaderboardData[0],
                  1,
                  100,
                  Colors.amber,
                ), // Juara 1
                _buildPodium(
                  leaderboardData[2],
                  3,
                  60,
                  Colors.brown[300]!,
                ), // Juara 3
              ],
            ),
          ),

          // List Sisanya
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardData.length - 3,
              itemBuilder: (context, index) {
                final realIndex = index + 3;
                final data = leaderboardData[realIndex];
                final isMe = data['isMe'] == true;

                return Card(
                  color: isMe
                      ? Colors.blue.withOpacity(0.1)
                      : (isDark ? Colors.grey[800] : Colors.white),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isMe ? Colors.blue : Colors.grey,
                      child: Text(
                        "${realIndex + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      data['name'],
                      style: TextStyle(
                        fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      "${data['calories']} kkal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(
    Map<String, dynamic> data,
    int rank,
    double height,
    Color color,
  ) {
    return Column(
      children: [
        const CircleAvatar(radius: 20, child: Icon(Icons.person)),
        const SizedBox(height: 8),
        Text(
          data['name'].toString().split(' ')[0],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              "#$rank",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
