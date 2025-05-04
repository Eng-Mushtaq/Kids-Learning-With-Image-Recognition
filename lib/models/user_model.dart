class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final Map<String, dynamic>? learningProgress;
  final List<String>? achievements;
  final Map<String, dynamic>? preferences;
  final DateTime? createdAt;
  final DateTime? lastActive;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.learningProgress,
    this.achievements,
    this.preferences,
    this.createdAt,
    this.lastActive,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      learningProgress: data['learningProgress'],
      achievements: data['achievements'] != null
          ? List<String>.from(data['achievements'])
          : null,
      preferences: data['preferences'],
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data['createdAt'].millisecondsSinceEpoch)
          : null,
      lastActive: data['lastActive'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data['lastActive'].millisecondsSinceEpoch)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'learningProgress': learningProgress ?? {},
      'achievements': achievements ?? [],
      'preferences': preferences ?? {},
      'createdAt': createdAt,
      'lastActive': DateTime.now(),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoURL,
    Map<String, dynamic>? learningProgress,
    List<String>? achievements,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      learningProgress: learningProgress ?? this.learningProgress,
      achievements: achievements ?? this.achievements,
      preferences: preferences ?? this.preferences,
      createdAt: this.createdAt,
      lastActive: DateTime.now(),
    );
  }
}
