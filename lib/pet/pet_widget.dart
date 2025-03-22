// import 'package:flutter/material.dart';
// import 'package:gsoc_smart_health_reminder/pet/animation_controller.dart';
// import 'package:gsoc_smart_health_reminder/pet/models/pet.dart';

// class PetWidget extends StatefulWidget {
//   final Pet pet;
//   final VoidCallback? onTap;
  
//   const PetWidget({
//     Key? key,
//     required this.pet,
//     this.onTap,
//   }) : super(key: key);
  
//   @override
//   _PetWidgetState createState() => _PetWidgetState();
// }

// class _PetWidgetState extends State<PetWidget> {
//   late PetAnimationController controller;
  
//   @override
//   void initState() {
//     super.initState();
//     controller = PetAnimationController(
//       basePath: 'assets/pet',
//       //stage: widget.pet.stage,
//       animations: {
//         'idle':['frame_1.png', 'frame_2.png', 'frame_3.png', 'frame_4.png', 'frame_5.png', 'frame_6.png', 'frame_7.png', 'frame_8.png'] ,
//         //'happy': ['happy1.png', 'happy2.png', 'happy3.png', 'happy4.png'],
//         //'upgrade': ['upgrade1.png', 'upgrade2.png', 'upgrade3.png', 'upgrade4.png'],
//       },
//     );
//     controller.startAnimation();
//   }
  
//   @override
//   void didUpdateWidget(PetWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.pet.stage != widget.pet.stage) {
//       controller.dispose();
//       controller = PetAnimationController(
//         basePath: 'assets/pet',
//         // stage: widget.pet.stage,
//         animations: {
//           'idle': ['0', '1', '2', '3', '4', '5', '6', '7'],
//           //'happy': ['happy1.png', 'happy2.png', 'happy3.png', 'happy4.png'],
//           //'upgrade': ['upgrade1.png', 'upgrade2.png', 'upgrade3.png', 'upgrade4.png'],
//         },
//         currentAnimation: 'upgrade',
//       );
//       controller.startAnimation();
//       Future.delayed(Duration(seconds: 2), () {
//         if (mounted) {
//           setState(() {
//             controller.playAnimation('idle');
//           });
//         }
//       });
//     }
//   }
  
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.onTap?.call();
//         setState(() {
//           controller.playAnimation('happy');
//         });
//         Future.delayed(Duration(seconds: 1), () {
//           if (mounted) {
//             setState(() {
//               controller.playAnimation('idle');
//             });
//           }
//         });
//       },
//       child: Image.asset(
//         controller.currentFramePath,
//         width: 200,
//         height: 200,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/pet/models/pet.dart';

class PetWidget extends StatefulWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetWidget({
    Key? key,
    required this.pet,
    this.onTap,
  }) : super(key: key);

  @override
  _PetWidgetState createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  late String gifPath;

  @override
  void initState() {
    super.initState();
    // Initially, show the idle gif for the current pet stage.
    gifPath = 'assets/pet/bored.gif';
  }

  @override
  void didUpdateWidget(PetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pet.stage != widget.pet.stage) {
      setState(() {
        gifPath = 'assets/pet/upgrade.gif';
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            gifPath = 'assets/pet/bored.gif';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        setState(() {
          gifPath = 'assets/pet/interogative.gif';
        });
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              gifPath = 'assets/pet/bored.gif';
            });
          }
        });
      },
      child: Image.asset(
        gifPath,
        width: 200,
        height: 200,
      ),
    );
  }
}
