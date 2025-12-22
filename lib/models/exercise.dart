class Exercise {
  final String id;
  final String activityName;
  final int duration;
  final int calories;
  final String date;

  Exercise({
    required this.id,
    required this.activityName,
    required this.duration,
    required this.calories,
    required this.date,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      activityName: json['activityName'] ?? 'Olahraga',
      duration: int.tryParse(json['duration'].toString()) ?? 0,
      calories: int.tryParse(json['calories'].toString()) ?? 0,
      date: json['date'] ?? '',
    );
  }

  // Dari Aplikasi ke JSON (API)
  Map<String, dynamic> toJson() {
    return {
      'activityName': activityName,
      'duration': duration,
      'calories': calories,
      'date': date,
    };
  }
}