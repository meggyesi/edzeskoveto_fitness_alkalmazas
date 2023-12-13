class UserModel {
  final String email;
  final String userId;
  final String? nickname;
  final String? fullName;
  final String? gender;
  final double? height;
  final double? weight;
  final DateTime? birthDate;
  final List<DateTime> loggedInDays; // New array to store logged-in days

  const UserModel({
    required this.email,
    required this.userId,
    this.nickname,
    this.fullName,
    this.gender,
    this.height,
    this.weight,
    this.birthDate,
    this.loggedInDays = const [], // Initialize the array with an empty list
  });

  // Parsing JSON data into a UserModel instance
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      userId: json['userId'],
      nickname: json['nickname'],
      fullName: json['fullName'],
      gender: json['gender'],
      height:
          json['height'] != null ? (json['height'] as num).toDouble() : null,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      loggedInDays: json['loggedInDays'] != null
          ? (json['loggedInDays'] as List<dynamic>)
              .map((date) => DateTime.parse(date))
              .toList()
          : [], // Parse the logged-in days array from JSON
    );
  }

  // Converting UserModel data to JSON format
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userId': userId,
      'nickname': nickname,
      'fullName': fullName,
      'gender': gender,
      'height': height,
      'weight': weight,
      'birthDate': birthDate?.toIso8601String(),
      'loggedInDays': loggedInDays
          .map((date) => date.toIso8601String())
          .toList(), // Convert logged-in days to ISO 8601 strings for JSON
    };
  }
}
