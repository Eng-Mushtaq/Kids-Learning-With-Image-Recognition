import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'models/user_model.dart';
import 'services/user_service.dart';
import 'services/learning_progress_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final LearningProgressService _progressService = LearningProgressService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserModel? _userModel;
  bool _isLoading = true;
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  // Stream subscription for real-time updates
  StreamSubscription? _userSubscription;
  StreamSubscription? _progressSubscription;

  // Learning progress data
  Map<String, dynamic> _learningProgress = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupProgressListener();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userSubscription?.cancel();
    _progressSubscription?.cancel();
    super.dispose();
  }

  void _setupProgressListener() {
    // Listen for learning progress updates
    _progressSubscription =
        _progressService.getLearningProgressStream().listen((progress) {
      if (mounted) {
        setState(() {
          _learningProgress = progress;
        });
      }
    });
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Set up real-time listener for user data
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        // First, ensure the user document exists
        await _ensureUserDocumentExists(userId);

        // Then set up the listener
        _userSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots()
            .listen((snapshot) {
          if (mounted) {
            if (snapshot.exists) {
              final userData = snapshot.data() as Map<String, dynamic>;
              setState(() {
                _userModel = UserModel.fromFirestore(userData, userId);
                if (_userModel?.displayName != null) {
                  _nameController.text = _userModel!.displayName!;
                }
                _isLoading = false;
              });
            } else {
              // Document doesn't exist, try to create it
              _ensureUserDocumentExists(userId).then((_) {
                setState(() {
                  _isLoading = false;
                });
              });
            }
          }
        }, onError: (e) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _showErrorToast("Failed to load profile: $e");
          }
        });
      } else {
        // No user ID, set loading to false
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorToast("Failed to load profile: $e");
      }
    }
  }

  // Ensure user document exists in Firestore
  Future<void> _ensureUserDocumentExists(String userId) async {
    try {
      // Check if user document exists
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        // Get current user from Firebase Auth
        final firebaseUser = _authService.currentUser;
        if (firebaseUser != null) {
          // Initialize user data
          await _userService.initializeNewUser(firebaseUser);
        }
      }
    } catch (e) {
      print("Error ensuring user document exists: $e");
    }
  }

  void _showErrorToast(String message) {
    if (mounted) {
      MotionToast.error(
        title: const Text("Error"),
        description: Text(message),
      ).show(context);
    }
  }

  void _showSuccessToast(String message) {
    if (mounted) {
      MotionToast.success(
        title: const Text("Success"),
        description: Text(message),
      ).show(context);
    }
  }

  Future<void> _updateDisplayName() async {
    if (_nameController.text.trim().isEmpty) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _isEditingName = false;
    });

    try {
      await _userService.updateUserProfile(
        userId: _userModel!.uid,
        displayName: _nameController.text.trim(),
      );

      // Also update in Firebase Auth
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        _nameController.text.trim(),
      );

      if (mounted) {
        await _loadUserData();

        MotionToast.success(
          title: const Text("Success"),
          description: const Text("Name updated successfully"),
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          title: const Text("Error"),
          description: Text("Failed to update name: $e"),
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (!mounted) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image == null || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final File imageFile = File(image.path);
      final String fileName =
          'profile_${_userModel!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef =
          _storage.ref().child('profile_images/$fileName');

      // Upload image
      await storageRef.putFile(imageFile);

      // Get download URL
      final String downloadURL = await storageRef.getDownloadURL();

      // Update user profile
      await _userService.updateUserProfile(
        userId: _userModel!.uid,
        photoURL: downloadURL,
      );

      // Also update in Firebase Auth
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadURL);

      if (mounted) {
        await _loadUserData();

        MotionToast.success(
          title: const Text("Success"),
          description: const Text("Profile picture updated successfully"),
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          title: const Text("Error"),
          description: Text("Failed to update profile picture: $e"),
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    if (!mounted) return;

    try {
      await _authService.signOut();
      // Navigation will be handled by the auth state listener in main.dart
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          title: const Text("Error"),
          description: Text("Failed to sign out: $e"),
        ).show(context);
      }
    }
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.deepPurple[500],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickAndUploadImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.purple[100],
                  backgroundImage: _userModel?.photoURL != null
                      ? CachedNetworkImageProvider(_userModel!.photoURL!)
                      : null,
                  child: _userModel?.photoURL == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_isEditingName)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "arlrdbd",
                      ),
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      autofocus: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: _updateDisplayName,
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  _isEditingName = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _userModel?.displayName ?? "Set your name",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "arlrdbd",
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            _userModel?.email ?? "",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningProgress() {
    // Use the real-time progress data from Firestore
    final progress = _learningProgress.isNotEmpty
        ? _learningProgress
        : _userModel?.learningProgress ?? {};

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  "Learning Progress",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arlrdbd",
                  ),
                ),
                const Spacer(),
                CircularPercentIndicator(
                  radius: 25.0,
                  lineWidth: 5.0,
                  percent: _calculateOverallProgress(progress),
                  center: Text(
                    "${(_calculateOverallProgress(progress) * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  progressColor: Colors.deepPurple,
                  backgroundColor: Colors.purple[50]!,
                  animation: true,
                  animationDuration: 500,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
                "Alphabet", progress['alphabet'] ?? 0.0, Colors.blue),
            _buildProgressItem(
                "Numbers", progress['numbers'] ?? 0.0, Colors.green),
            _buildProgressItem(
                "Animals", progress['animals'] ?? 0.0, Colors.orange),
            _buildProgressItem("Fruits", progress['fruits'] ?? 0.0, Colors.red),
            _buildProgressItem(
                "Vegetables", progress['vegetables'] ?? 0.0, Colors.teal),
            _buildProgressItem(
                "Colors", progress['colors'] ?? 0.0, Colors.purple),
            _buildProgressItem(
                "Shapes", progress['shapes'] ?? 0.0, Colors.indigo),
            _buildProgressItem("Birds", progress['birds'] ?? 0.0, Colors.amber),
            _buildProgressItem(
                "Months", progress['months'] ?? 0.0, Colors.cyan),
          ],
        ),
      ),
    );
  }

  double _calculateOverallProgress(Map<String, dynamic> progress) {
    if (progress.isEmpty) return 0.0;

    double total = 0.0;
    int count = 0;

    progress.forEach((key, value) {
      if (value is double) {
        total += value;
        count++;
      } else if (value is int) {
        total += value.toDouble();
        count++;
      } else if (value is num) {
        total += value.toDouble();
        count++;
      }
    });

    return count > 0 ? total / count : 0.0;
  }

  Widget _buildProgressItem(String title, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "arlrdbd",
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: progress,
            backgroundColor: Colors.grey[200],
            progressColor: color,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    // Use real-time data if available
    final achievements = _userModel?.achievements ?? [];

    // Define available achievements
    final Map<String, Map<String, dynamic>> allAchievements = {
      'first_login': {
        'title': 'First Steps',
        'description': 'Logged in for the first time',
        'icon': Icons.login,
        'color': Colors.blue,
      },
      'complete_alphabet': {
        'title': 'Alphabet Master',
        'description': 'Completed the alphabet learning module',
        'icon': Icons.abc,
        'color': Colors.green,
      },
      'complete_numbers': {
        'title': 'Number Genius',
        'description': 'Completed the numbers learning module',
        'icon': Icons.numbers,
        'color': Colors.orange,
      },
      'animal_explorer': {
        'title': 'Animal Explorer',
        'description': 'Learned about 10 different animals',
        'icon': Icons.pets,
        'color': Colors.brown,
      },
      'fruit_collector': {
        'title': 'Fruit Collector',
        'description': 'Identified all fruits correctly',
        'icon': Icons.apple,
        'color': Colors.red,
      },
      'perfect_score': {
        'title': 'Perfect Score',
        'description': 'Got 100% on a quiz',
        'icon': Icons.star,
        'color': Colors.amber,
      },
      'halfway_hero': {
        'title': 'Halfway Hero',
        'description': 'Reached 50% overall learning progress',
        'icon': Icons.trending_up,
        'color': Colors.purple,
      },
      'triple_threat': {
        'title': 'Triple Threat',
        'description': 'Mastered 3 different learning categories',
        'icon': Icons.looks_3,
        'color': Colors.indigo,
      },
      'learning_champion': {
        'title': 'Learning Champion',
        'description': 'Mastered 5 different learning categories',
        'icon': Icons.emoji_events,
        'color': Colors.deepOrange,
      },
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  "Achievements",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arlrdbd",
                  ),
                ),
                const Spacer(),
                Text(
                  "${achievements.length}/${allAchievements.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (achievements.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Complete activities to earn achievements!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: achievements.map((achievement) {
                  final achievementData = allAchievements[achievement];
                  if (achievementData == null) return Container();

                  return Tooltip(
                    message: achievementData['description'],
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: achievementData['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: achievementData['color'].withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            achievementData['icon'],
                            color: achievementData['color'],
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievementData['title'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: achievementData['color'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arlrdbd",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text("Change Password"),
              onTap: () {
                // Implement password reset functionality
                _authService.sendPasswordResetEmail(_userModel?.email ?? "");
                MotionToast.info(
                  title: const Text("Password Reset"),
                  description:
                      const Text("Password reset link sent to your email"),
                ).show(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              onTap: () {
                // Navigate to privacy policy
                Navigator.pushNamed(context, '/privacy');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Support"),
              onTap: () {
                // Implement help and support functionality
                MotionToast.info(
                  title: const Text("Help & Support"),
                  description: const Text("Coming soon!"),
                ).show(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    _buildLearningProgress(),
                    _buildAchievements(),
                    _buildAccountActions(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
