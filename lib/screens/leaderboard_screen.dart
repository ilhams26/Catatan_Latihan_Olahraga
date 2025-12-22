import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/exercise_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fungsi hitung leaderboard real saat halaman dibuka
    Future.microtask(() {
      final user = Provider.of<AuthProvider>(
        context,
        listen: false,
      ).currentUser;
      if (user != null) {
        Provider.of<ExerciseProvider>(
          context,
          listen: false,
        ).fetchRealLeaderboard(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Papan Peringkat Global")),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final leaderboardData = provider.leaderboardData;

          if (leaderboardData.isEmpty) {
            return const Center(child: Text("Belum ada data ranking."));
          }

          // Ambil Top 3 (jika ada)
          final top1 = leaderboardData.isNotEmpty ? leaderboardData[0] : null;
          final top2 = leaderboardData.length > 1 ? leaderboardData[1] : null;
          final top3 = leaderboardData.length > 2 ? leaderboardData[2] : null;

          return Column(
            children: [
              // Top 3 Podium Dynamic
              Container(
                padding: const EdgeInsets.all(20),
                color: isDark ? Colors.grey[900] : Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (top2 != null)
                      _buildPodium(top2, 2, 80, Colors.grey[300]!),
                    if (top1 != null) _buildPodium(top1, 1, 100, Colors.amber),
                    if (top3 != null)
                      _buildPodium(top3, 3, 60, Colors.brown[300]!),
                  ],
                ),
              ),

              // List Sisanya (Rank 4 ke bawah)
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboardData.length > 3
                      ? leaderboardData.length - 3
                      : 0,
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
                            fontWeight: isMe
                                ? FontWeight.bold
                                : FontWeight.normal,
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
          );
        },
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
          data['name'].toString().split(' ')[0], // Ambil nama depan
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
