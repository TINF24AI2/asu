import 'package:asu/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const AsuApp()));
}

// Dev Alternative Main
// void main() {
//   runApp(
//     ProviderScope(
//       child: MaterialApp(
//         home: Scaffold(
//           appBar: AppBar(title: Text('Dev Placeholder')),
//           body: Center(
//             child: Text('This is a development placeholder screen.'),
//           ),
//         ),
//       ),
//     ),
//   );
// }
