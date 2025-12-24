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
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Papan Peringkat"),
        elevation: 0,
        backgroundColor: Colors.transparent, // Transparan agar menyatu
        foregroundColor: isDark
            ? Colors.white
            : Colors.black, // Warna text appbar adaptif
        centerTitle: true,
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allData = provider.leaderboardData;
          if (allData.isEmpty) {
            return const Center(child: Text("Belum ada data ranking."));
          }

          final top1 = allData.isNotEmpty ? allData[0] : null;
          final top2 = allData.length > 1 ? allData[1] : null;
          final top3 = allData.length > 2 ? allData[2] : null;

          final restList = allData.length > 3
              ? allData.sublist(3, allData.length > 10 ? 10 : allData.length)
              : <Map<String, dynamic>>[];

          final myData = allData.firstWhere(
            (element) => element['isMe'] == true,
            orElse: () => {},
          );

          return Column(
            children: [
              const SizedBox(height: 10),
              // --- BAGIAN PODIUM (Gradient Batang) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (top2 != null)
                      _buildPodiumItem(top2, 2, 120, isCenter: false),
                    if (top1 != null)
                      _buildPodiumItem(top1, 1, 160, isCenter: true),
                    if (top3 != null)
                      _buildPodiumItem(top3, 3, 100, isCenter: false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- LIST RANK 4-10 ---
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: restList.length,
                    itemBuilder: (context, index) {
                      final data = restList[index];
                      return _buildRankItem(data, isDark);
                    },
                  ),
                ),
              ),

              // --- KARTU USER SENDIRI (STICKY) ---
              if (myData.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "https://www.jktliving.com/blog/wp-content/uploads/2024/04/Foto-Kucing-Keren.jpg",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kamu",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Peringkat ${myData['rank']}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${myData['calories']} kkal",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodiumItem(
    Map<String, dynamic> data,
    int rank,
    double height, {
    bool isCenter = false,
  }) {
    return Column(
      children: [
        // Avatar + Mahkota
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white, // Border avatar putih
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: isCenter ? 30 : 22,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    data['name'].toString().substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isCenter ? 20 : 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            if (rank == 1)
              const Icon(
                Icons.workspace_premium,
                color: Color(0xFFFFD700),
                size: 30,
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Nama User
        Text(
          data['name'].toString().split(' ')[0],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: isCenter ? 80 : 60,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4A80F0),
                Color(0xFF9E47FF),
              ], // Gradient Ungu-Biru
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A80F0).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$rank",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              // Skor
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${data['calories']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget Rank Item
  Widget _buildRankItem(Map<String, dynamic> data, bool isDark) {
    bool isMe = data['isMe'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF4A80F0).withOpacity(0.1)
            : (isDark ? Colors.grey[800] : Colors.grey[100]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            "${data['rank']}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            child: Text(
              data['name'].toString().substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              data['name'],
              style: TextStyle(
                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            "${data['calories']} kkal",
            style: const TextStyle(
              color: Color(0xFF9E47FF),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
