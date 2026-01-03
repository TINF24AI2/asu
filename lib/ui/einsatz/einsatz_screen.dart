import 'package:flutter/material.dart';

import '../core/core.dart';
import 'horizontal_trupp_view.dart';

class EinsatzScreen extends StatelessWidget {
  const EinsatzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AsuScaffold(
      title: Text('Atemschutzüberwachung'),
      body: HorizontalTruppView(),
    );
  }
}
