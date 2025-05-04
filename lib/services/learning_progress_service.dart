import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LearningProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Learning categories
  static const List<String> categories = [
    'alphabet',
    'numbers',
    'animals',
    'fruits',
    'vegetables',
    'colors',
    'shapes',
    'birds',
    'months'
  ];

  // Track lesson completion
  Future<void> trackLessonCompletion({
    required String category,
    required int totalItems,
    required int completedItems,
  }) async {
    if (currentUserId == null) return;

    try {
      // Calculate progress percentage (0.0 to 1.0)
      double progress = completedItems / totalItems;

      // Ensure progress is between 0 and 1
      progress = progress.clamp(0.0, 1.0);

      // Get current progress
      DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> learningProgress =
          data['learningProgress'] as Map<String, dynamic>;

      // Only update if new progress is higher
      double currentProgress = learningProgress[category] ?? 0.0;
      if (progress > currentProgress) {
        await _usersCollection.doc(currentUserId).update({
          'learningProgress.$category': progress,
          'lastActive': FieldValue.serverTimestamp(),
        });

        // Check for achievements
        await _checkForAchievements(category, progress, learningProgress);
      }
    } catch (e) {
      print('Error tracking lesson completion: $e');
    }
  }

  // Track quiz completion
  Future<void> trackQuizCompletion({
    required String category,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    if (currentUserId == null) return;

    try {
      // Calculate score percentage (0.0 to 1.0)
      double score = correctAnswers / totalQuestions;

      // Ensure score is between 0 and 1
      score = score.clamp(0.0, 1.0);

      // Get current progress
      DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> learningProgress =
          data['learningProgress'] as Map<String, dynamic>;

      // Only update if new score is higher
      double currentProgress = learningProgress[category] ?? 0.0;
      double newProgress = (currentProgress + score) /
          2; // Average of current progress and quiz score

      if (newProgress > currentProgress) {
        await _usersCollection.doc(currentUserId).update({
          'learningProgress.$category': newProgress,
          'lastActive': FieldValue.serverTimestamp(),
        });

        // Check for achievements
        await _checkForAchievements(category, newProgress, learningProgress);

        // Check for perfect score achievement
        if (score >= 1.0) {
          await _addAchievement('perfect_score');
        }
      }
    } catch (e) {
      print('Error tracking quiz completion: $e');
    }
  }

  // Track video watched
  Future<void> trackVideoWatched({
    required String category,
  }) async {
    if (currentUserId == null) return;

    try {
      // Get current progress
      DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> learningProgress =
          data['learningProgress'] as Map<String, dynamic>;

      // Increment progress by a small amount (5%)
      double currentProgress = learningProgress[category] ?? 0.0;
      double newProgress = currentProgress + 0.05;

      // Ensure progress doesn't exceed 1.0
      newProgress = newProgress.clamp(0.0, 1.0);

      if (newProgress > currentProgress) {
        await _usersCollection.doc(currentUserId).update({
          'learningProgress.$category': newProgress,
          'lastActive': FieldValue.serverTimestamp(),
        });

        // Check for achievements
        await _checkForAchievements(category, newProgress, learningProgress);
      }
    } catch (e) {
      print('Error tracking video watched: $e');
    }
  }

  // Track listen and guess activity
  Future<void> trackListenAndGuess({
    required String category,
    required int totalItems,
    required int correctGuesses,
  }) async {
    if (currentUserId == null) return;

    try {
      // Calculate score percentage (0.0 to 1.0)
      double score = correctGuesses / totalItems;

      // Ensure score is between 0 and 1
      score = score.clamp(0.0, 1.0);

      // Get current progress
      DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> learningProgress =
          data['learningProgress'] as Map<String, dynamic>;

      // Only update if new score contributes to higher progress
      double currentProgress = learningProgress[category] ?? 0.0;
      double newProgress =
          (currentProgress * 0.7) + (score * 0.3); // Weighted average

      if (newProgress > currentProgress) {
        await _usersCollection.doc(currentUserId).update({
          'learningProgress.$category': newProgress,
          'lastActive': FieldValue.serverTimestamp(),
        });

        // Check for achievements
        await _checkForAchievements(category, newProgress, learningProgress);
      }
    } catch (e) {
      print('Error tracking listen and guess: $e');
    }
  }

  // Get learning progress stream
  Stream<Map<String, dynamic>> getLearningProgressStream() {
    if (currentUserId == null) {
      return Stream.value({});
    }

    return _usersCollection.doc(currentUserId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        // If document doesn't exist, try to create it
        _initializeUserIfNeeded();
        return {};
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('learningProgress')) {
        return data['learningProgress'] as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }

  // Initialize user if needed
  Future<void> _initializeUserIfNeeded() async {
    try {
      if (currentUserId != null) {
        final user = _auth.currentUser;
        if (user != null) {
          // Check if document exists
          final docSnapshot = await _usersCollection.doc(currentUserId).get();
          if (!docSnapshot.exists) {
            // Create default learning progress
            final Map<String, dynamic> learningProgress = {};
            for (String category in categories) {
              learningProgress[category] = 0.0;
            }

            // Set initial data
            await _usersCollection.doc(currentUserId).set({
              'uid': currentUserId,
              'email': user.email ?? '',
              'displayName': user.displayName,
              'photoURL': user.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
              'lastActive': FieldValue.serverTimestamp(),
              'learningProgress': learningProgress,
              'achievements': [],
              'preferences': {
                'notifications': true,
                'language': 'English',
                'speechRate': 0.5,
              },
            });
          }
        }
      }
    } catch (e) {
      print('Error initializing user data: $e');
    }
  }

  // Calculate overall progress
  Future<double> calculateOverallProgress() async {
    if (currentUserId == null) return 0.0;

    try {
      DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> learningProgress =
          data['learningProgress'] as Map<String, dynamic>;

      if (learningProgress.isEmpty) return 0.0;

      double total = 0.0;
      learningProgress.forEach((key, value) {
        total += (value as double);
      });

      return total / learningProgress.length;
    } catch (e) {
      print('Error calculating overall progress: $e');
      return 0.0;
    }
  }

  // Check for achievements based on progress
  Future<void> _checkForAchievements(String category, double progress,
      Map<String, dynamic> learningProgress) async {
    if (currentUserId == null) return;

    try {
      // Category-specific achievements
      if (progress >= 1.0) {
        switch (category) {
          case 'alphabet':
            await _addAchievement('complete_alphabet');
            break;
          case 'numbers':
            await _addAchievement('complete_numbers');
            break;
          case 'animals':
            await _addAchievement('animal_explorer');
            break;
          case 'fruits':
            await _addAchievement('fruit_collector');
            break;
        }
      }

      // Check for overall progress achievements
      double overallProgress = 0.0;
      int completedCategories = 0;

      learningProgress.forEach((key, value) {
        overallProgress += (value as double);
        if (value >= 0.8) completedCategories++;
      });

      overallProgress = overallProgress / learningProgress.length;

      // Overall progress achievements
      if (overallProgress >= 0.5) {
        await _addAchievement('halfway_hero');
      }

      if (completedCategories >= 3) {
        await _addAchievement('triple_threat');
      }

      if (completedCategories >= 5) {
        await _addAchievement('learning_champion');
      }
    } catch (e) {
      print('Error checking for achievements: $e');
    }
  }

  // Add achievement if not already earned
  Future<void> _addAchievement(String achievement) async {
    if (currentUserId == null) return;

    try {
      DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> achievements = data['achievements'] as List<dynamic>;

      if (!achievements.contains(achievement)) {
        await _usersCollection.doc(currentUserId).update({
          'achievements': FieldValue.arrayUnion([achievement]),
        });
      }
    } catch (e) {
      print('Error adding achievement: $e');
    }
  }
}
