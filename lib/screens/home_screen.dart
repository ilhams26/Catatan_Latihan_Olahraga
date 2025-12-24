import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/auth_provider.dart';
import 'form_screen.dart';
import 'profile_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = Provider.of<AuthProvider>(
        context,
        listen: false,
      ).currentUser;
      if (user != null && mounted) {
        Provider.of<ExerciseProvider>(
          context,
          listen: false,
        ).getMyExercises(user.id);
      }
    });
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // LayoutBuilder untuk Responsivitas dasar
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Cek apakah layar lebar (tablet/landscape)
          bool isWideScreen = constraints.maxWidth > 600;

          return Consumer<ExerciseProvider>(
            builder: (context, provider, child) {
              int totalCal = 0;
              int totalDur = 0;
              for (var item in provider.exercises) {
                totalCal += item.calories;
                totalDur += item.duration;
              }

              double progress = (auth.weeklyTarget > 0)
                  ? (totalCal / auth.weeklyTarget).clamp(0.0, 1.0)
                  : 0.0;

              return SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getGreeting()}, ${user?.username ?? 'Bro'}! 👋",
                                      style: TextStyle(
                                        fontSize: isWideScreen ? 28 : 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Siap membakar kalori?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ProfileScreen(),
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Dashboard & Target (Responsive Row/Column)
                            isWideScreen
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _buildDashboardCard(
                                          provider.exercises.length,
                                          totalCal,
                                          totalDur,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: _buildTargetCard(
                                          progress,
                                          isDark,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      _buildDashboardCard(
                                        provider.exercises.length,
                                        totalCal,
                                        totalDur,
                                      ),
                                      const SizedBox(height: 24),
                                      _buildTargetCard(progress, isDark),
                                    ],
                                  ),

                            const SizedBox(height: 24),

                            // Judul List
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Riwayat Latihan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    // List Items (SliverList agar performa tinggi)
                    if (provider.isLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (provider.exercises.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: Text("Belum ada data latihan.")),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        // Gunakan SliverGrid untuk layar lebar, SliverList untuk HP
                        sliver: isWideScreen
                            ? SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 2.5,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _buildExerciseItem(
                                    context,
                                    provider.exercises[index],
                                    isDark,
                                  ),
                                  childCount: provider.exercises.length,
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildExerciseItem(
                                      context,
                                      provider.exercises[index],
                                      isDark,
                                    ),
                                  ),
                                  childCount: provider.exercises.length,
                                ),
                              ),
                      ),

                    // Spasi Bawah
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormScreen()),
        ),
      ),
    );
  }
  Widget _buildDashboardCard(int count, int cal, int dur) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A80F0), Color(0xFF9E47FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Aktivitas",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn("$count", "Latihan"),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildStatColumn("$cal", "Kkal"),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildStatColumn("$dur", "Menit"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard(double progress, bool isDark) {
    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.transparent : Colors.grey[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Target Mingguan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, var item, bool isDark) {
    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.transparent : Colors.grey[100]!,
        ),
      ),
      child: InkWell(
        // <--- AGAR BISA DIKLIK (Syarat Detail Item)
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(exercise: item)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ), // Padding manual karena bukan ListTile biasa
          child: Row(
            children: [
              // Hero Icon (Animasi saat pindah halaman)
              Hero(
                tag: 'exercise-${item.id}',
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3E0), // Orange[50]
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_run, color: Colors.orange),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.activityName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "+${item.calories} Kkal",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
