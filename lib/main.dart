import 'package:asu/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
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
