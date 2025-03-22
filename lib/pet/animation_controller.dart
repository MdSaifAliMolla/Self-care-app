import 'dart:async';

class PetAnimationController {
  final String basePath;
  final Map<String, List<String>> animations;
  String currentAnimation;
  int currentFrame = 0;
  Timer? animationTimer;
  
  PetAnimationController({
    required this.basePath,
    required this.animations,
    this.currentAnimation = 'idle',
  });
  
  String get currentFramePath {
    final frames = animations[currentAnimation] ?? animations['idle']!;
    return '$basePath/$currentAnimation/${frames[currentFrame]}';
  }
  
  void startAnimation() {
    animationTimer?.cancel();
    animationTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      currentFrame = (currentFrame + 1) % (animations[currentAnimation]?.length ?? 1);
    });
  }
  
  void stopAnimation() {
    animationTimer?.cancel();
    animationTimer = null;
  }
  
  void playAnimation(String animationName) {
    if (animations.containsKey(animationName)) {
      currentAnimation = animationName;
      currentFrame = 0;
    }
  }
  
  void dispose() {
    stopAnimation();
  }
}
// import 'dart:async';

// class PetAnimationController {

//   final String basePath;

//   final int stage;

//   /// A map of animationName -> list of frames (as strings).
//   ///
//   /// Example:
//   /// {
//   ///   'idle':    ['0', '1', '2', '3', '4', '5', '6', '7'],
//   ///   'happy':   ['0', '1', '2', '3', '4', '5', '6', '7'],
//   ///   'upgrade': ['0', '1', '2', '3', '4', '5', '6', '7'],
//   /// }
//   ///
//   /// Each string in the list represents a frame index (or any identifier).
//   /// You can then parse it to determine which sub-rectangle of the sprite sheet
//   /// to draw.
//   final Map<String, List<String>> animations;

//   String currentAnimation;

//   int currentFrame = 0;

//   /// Periodic timer that updates currentFrame.
//   Timer? animationTimer;
  
//   PetAnimationController({
//     required this.basePath,
//     required this.stage,
//     required this.animations,
//     this.currentAnimation = 'idle',
//   });
  
//   /// Returns a string that references:
//   /// - The sprite sheet path: "$basePath/stage$stage/$currentAnimation_spritesheet.png"
//   /// - The current frame index (extracted from animations[currentAnimation])
//   ///
//   /// For example, if animations['idle'] = ['0','1','2','3'] and currentFrame=2,
//   /// this might return "assets/pet/stage1/idle_spritesheet.png#2"
//   ///
//   /// Your UI code can parse the "#2" part to determine which sub-rectangle
//   /// of the sprite sheet to display.
//   String get currentFramePath {
//     final frames = animations[currentAnimation] ?? animations['idle']!;
//     final frameId = frames[currentFrame];
//     // Construct the path to the sprite sheet plus a fragment with the frame index.
//     return '$basePath/${currentAnimation}_sheet.png#$frameId';
//   }
  
//   /// Starts or restarts the animation timer at a default interval of 200ms.
//   /// You can adjust the speed by changing the Duration.
//   void startAnimation() {
//     stopAnimation();
//     animationTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
//       final frames = animations[currentAnimation] ?? animations['idle']!;
//       currentFrame = (currentFrame + 1) % frames.length;
//     });
//   }
  
//   /// Stops the animation timer (freezes currentFrame).
//   void stopAnimation() {
//     animationTimer?.cancel();
//     animationTimer = null;
//   }
  
//   /// Switches to a different animation (e.g., 'happy' -> 'idle').
//   /// Resets currentFrame to 0.
//   void playAnimation(String animationName) {
//     if (animations.containsKey(animationName)) {
//       currentAnimation = animationName;
//       currentFrame = 0;
//     }
//   }
  
//   /// Cleans up resources.
//   void dispose() {
//     stopAnimation();
//   }
// }
