import 'package:google_ml_kit/google_ml_kit.dart';

class CategoryClassifier {
  // Categories for classification
  static const String ANIMAL = 'animal';
  static const String VEGETABLE = 'vegetable';
  static const String FRUIT = 'fruit';
  static const String OTHER = 'other';

  // Lists of common animals (expanded with ML Kit detection labels)
  static final List<String> animals = [
    'cat', 'dog', 'bird', 'elephant', 'horse', 'cow', 'sheep',
    'lion', 'tiger', 'bear', 'zebra', 'giraffe', 'monkey', 'rabbit',
    'animal', 'fox', 'wolf', 'deer', 'mouse', 'rat', 'squirrel',
    // Common ML Kit animal labels
    'pet', 'wildlife', 'mammal', 'reptile', 'insect', 'amphibian',
    // Specific animals ML Kit might detect
    'turtle', 'snake', 'fish', 'frog', 'butterfly', 'bee', 'spider',
    'hamster', 'guinea pig', 'lizard', 'crocodile', 'duck', 'chicken',
    'goat', 'pig', 'donkey', 'panda', 'koala', 'kangaroo',
    // Add more general terms
    'animal', 'creature', 'beast', 'fauna'
  ];

  // Lists of common vegetables (expanded with ML Kit detection labels)
  static final List<String> vegetables = [
    'carrot', 'broccoli', 'potato', 'tomato', 'cucumber', 'onion',
    'garlic', 'pepper', 'lettuce', 'cabbage', 'eggplant', 'vegetable',
    'pumpkin', 'zucchini', 'pea', 'green bean', 'celery', 'radish',
    'spinach', 'kale', 'cauliflower', 'corn', 'beetroot', 'turnip',
    // Additional vegetables ML Kit might detect
    'leek', 'asparagus', 'artichoke', 'brussels sprout', 'chickpea',
    'lentil', 'bean', 'mushroom', 'squash', 'salad', 'green vegetable',
    'root vegetable', 'leafy green', 'produce', 'organic', 'green',
    'vegetable'
  ];

  // Lists of common fruits (expanded with ML Kit detection labels)
  static final List<String> fruits = [
    'apple', 'banana', 'orange', 'grape', 'strawberry', 'pineapple',
    'watermelon', 'peach', 'pear', 'cherry', 'blueberry', 'mango',
    'kiwi', 'lemon', 'lime', 'fruit', 'avocado', 'coconut', 'fig',
    'plum', 'apricot', 'raspberry', 'blackberry', 'melon',
    // Additional fruits ML Kit might detect
    'pomegranate', 'passionfruit', 'dragonfruit', 'guava', 'papaya',
    'lychee', 'berry', 'citrus', 'tropical fruit', 'exotic fruit',
    'fresh fruit', 'produce', 'organic fruit', 'fruit'
  ];

  // General food categories (for better detection)
  static final List<String> foodTerms = [
    'food',
    'meal',
    'snack',
    'organic',
    'produce',
    'fresh',
    'natural',
    'healthy',
    'nutrition',
    'diet',
    'grocery',
    'edible',
    'ingredient'
  ];

  // Categorize a detected object
  static String categorize(String label) {
    label = label.toLowerCase().trim();

    // Check for exact matches first
    if (animals.contains(label)) {
      return ANIMAL;
    } else if (vegetables.contains(label)) {
      return VEGETABLE;
    } else if (fruits.contains(label)) {
      return FRUIT;
    }

    // If not an exact match, check for partial matches
    for (String animal in animals) {
      if (label.contains(animal) || animal.contains(label)) {
        return ANIMAL;
      }
    }

    for (String vegetable in vegetables) {
      if (label.contains(vegetable) || vegetable.contains(label)) {
        return VEGETABLE;
      }
    }

    for (String fruit in fruits) {
      if (label.contains(fruit) || fruit.contains(label)) {
        return FRUIT;
      }
    }

    // Check if it's a food item - if so, default to vegetable since it's the most general category
    for (String term in foodTerms) {
      if (label.contains(term)) {
        return VEGETABLE;
      }
    }

    return OTHER;
  }

  // Get a description for the detected object
  static String getDescription(String label) {
    label = label.toLowerCase();
    switch (label) {
      // Animals
      case 'cat':
        return 'A cat is a small furry animal that people keep as a pet.';
      case 'dog':
        return 'A dog is a loyal animal that can be a great pet.';
      case 'bird':
        return 'Birds have wings and can fly in the sky.';
      case 'elephant':
        return 'Elephants are the largest land animals with long trunks.';
      case 'lion':
        return 'Lions are powerful big cats often called the king of the jungle.';
      case 'tiger':
        return 'Tigers have striped fur and are the largest members of the cat family.';
      case 'zebra':
        return 'Zebras have black and white stripes and look like horses.';
      case 'giraffe':
        return 'Giraffes have very long necks to reach leaves on tall trees.';

      // Vegetables
      case 'carrot':
        return 'Carrots are orange vegetables that grow underground.';
      case 'broccoli':
        return 'Broccoli is a green vegetable that looks like a small tree.';
      case 'potato':
        return 'Potatoes grow underground and can be cooked in many ways.';
      case 'tomato':
        return 'Tomatoes are red and juicy vegetables used in many dishes.';
      case 'cucumber':
        return 'Cucumbers are green and crunchy vegetables often used in salads.';
      case 'onion':
        return 'Onions can make your eyes tear up when you cut them.';

      // Fruits
      case 'apple':
        return 'Apples are crunchy fruits that come in red, green, or yellow colors.';
      case 'banana':
        return 'Bananas are yellow fruits with a curved shape.';
      case 'orange':
        return 'Oranges are round, orange-colored fruits with sweet juice inside.';
      case 'grape':
        return 'Grapes grow in bunches and can be green or purple.';
      case 'strawberry':
        return 'Strawberries are small, red fruits with seeds on the outside.';
      case 'watermelon':
        return 'Watermelons are large fruits with green skin and sweet red inside.';

      default:
        if (animals.contains(label)) {
          return 'This is an animal.';
        } else if (vegetables.contains(label)) {
          return 'This is a vegetable that is good for your health.';
        } else if (fruits.contains(label)) {
          return 'This is a fruit that is sweet and delicious.';
        } else {
          return 'This is an object.';
        }
    }
  }
}

class RealTimeDetector {
  late final ObjectDetector _objectDetector;

  RealTimeDetector() {
    print('Initializing ObjectDetector with ML Kit v0.20.0');
    // Initialize the object detector with the latest API
    // Use a different configuration that's known to work better
    _objectDetector = GoogleMlKit.vision.objectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single, // Try single image mode first
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
    print('ObjectDetector initialized successfully');
  }

  Future<List<DetectedObject>> processImage(InputImage inputImage) async {
    try {
      final List<DetectedObject> objects =
          await _objectDetector.processImage(inputImage);
      print('Processed image: detected ${objects.length} objects');

      // Print details about detected objects for debugging
      if (objects.isNotEmpty) {
        for (var i = 0; i < objects.length; i++) {
          final object = objects[i];
          print(
              'Object $i: ${object.labels.length} labels, boundingBox: ${object.boundingBox}');
          for (var label in object.labels) {
            print('  Label: ${label.text}, confidence: ${label.confidence}');
          }
        }
      } else {
        print('No objects detected in this frame');
      }

      return objects;
    } catch (e) {
      print('Error processing image: $e');
      return [];
    }
  }

  void close() {
    _objectDetector.close();
    print('ObjectDetector closed');
  }
}
