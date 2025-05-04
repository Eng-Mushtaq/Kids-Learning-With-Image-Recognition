import 'package:flutter/material.dart';
import '../services/learning_progress_service.dart';

class LearningTracker {
  static final LearningProgressService _progressService = LearningProgressService();
  
  // Track lesson completion
  static Future<void> trackLessonProgress({
    required BuildContext context,
    required String category,
    required int totalItems,
    required int completedItems,
  }) async {
    await _progressService.trackLessonCompletion(
      category: category,
      totalItems: totalItems,
      completedItems: completedItems,
    );
    
    // Show a snackbar if significant progress is made
    if (completedItems > 0 && completedItems % (totalItems ~/ 4) == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Great job! You\'ve completed $completedItems out of $totalItems items.'),
            backgroundColor: Colors.deepPurple,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  // Track quiz completion
  static Future<void> trackQuizCompletion({
    required BuildContext context,
    required String category,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    await _progressService.trackQuizCompletion(
      category: category,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
    );
    
    // Show a snackbar with the score
    if (context.mounted) {
      final percentage = (correctAnswers / totalQuestions * 100).toInt();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz completed! Your score: $percentage%'),
          backgroundColor: percentage >= 80 ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  // Track video watched
  static Future<void> trackVideoWatched({
    required BuildContext context,
    required String category,
  }) async {
    await _progressService.trackVideoWatched(
      category: category,
    );
    
    // Show a subtle snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress updated!'),
          backgroundColor: Colors.deepPurple,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  
  // Track listen and guess activity
  static Future<void> trackListenAndGuess({
    required BuildContext context,
    required String category,
    required int totalItems,
    required int correctGuesses,
  }) async {
    await _progressService.trackListenAndGuess(
      category: category,
      totalItems: totalItems,
      correctGuesses: correctGuesses,
    );
    
    // Show a snackbar with the score
    if (context.mounted) {
      final percentage = (correctGuesses / totalItems * 100).toInt();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activity completed! Your score: $percentage%'),
          backgroundColor: percentage >= 80 ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
