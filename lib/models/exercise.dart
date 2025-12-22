class Exercise {
  final String id;
  final String userId; 
  final String activityName;
  final int duration;
  final int calories;
  final String date;

  Exercise({
    required this.id,
    required this.userId, 
    required this.activityName,
    required this.duration,
    required this.calories,
    required this.date,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      userId: json['userId'] ?? 'guest', // Default jika data lama kosong
      activityName: json['activityName'] ?? 'Olahraga',
      duration: int.tryParse(json['duration'].toString()) ?? 0,
      calories: int.tryParse(json['calories'].toString()) ?? 0,
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId, 
      'activityName': activityName,
      'duration': duration,
      'calories': calories,
      'date': date,
    };
  }
}
