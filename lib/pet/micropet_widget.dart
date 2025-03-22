// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class MicropetWidget extends StatelessWidget {
//   final double petSize = 50.0;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MicropetModel>(
//       builder: (context, micropet, child) {
//         return Positioned(
//           left: micropet.position.dx,
//           top: micropet.position.dy,
//           child: GestureDetector(
//             onPanUpdate: (details) {
//               micropet.updatePosition(
//                 micropet.position + details.delta,
//                 MediaQuery.of(context).size,
//                 Size(petSize, petSize),
//               );
//             },
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               child: Image.asset(
//                 _getPetImage(micropet.mood),
//                 width: petSize,
//                 height: petSize,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _getPetImage(PetMood mood) {
//     switch (mood) {
//       case PetMood.happy:
//         return 'assets/pet_happy.png';
//       case PetMood.neutral:
//         return 'assets/pet_neutral.png';
//       case PetMood.sad:
//         return 'assets/pet_sad.png';
//     }
//   }
// }
