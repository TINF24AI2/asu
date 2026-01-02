import 'package:flutter/material.dart';

import '../../pubspec.g.dart';

void showAsuAbout({required BuildContext context}) {
  return showAboutDialog(
    context: context,
    applicationName: Pubspec.app_name,
    applicationVersion: Pubspec.versionFull,
    applicationLegalese: Pubspec.app_legalese,
    applicationIcon: const Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Image(
        image: AssetImage('assets/icon/asu_logo.png'),
        width: 64,
        height: 64,
      ),
    ),
    children: [
      Container(
        padding: const EdgeInsets.only(top: 10.0),
        constraints: BoxConstraints.loose(const Size.fromWidth(100)),
        child: const Text(Pubspec.description, softWrap: true),
      ),
      Container(
        padding: const EdgeInsets.only(top: 10.0),
        constraints: BoxConstraints.loose(const Size.fromWidth(100)),
        child: const Text(Pubspec.app_warning, softWrap: true),
      ),
    ],
  );
}
