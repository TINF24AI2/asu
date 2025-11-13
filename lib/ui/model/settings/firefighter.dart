import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/setting_item.dart';

// Plain class model for a firefighter setting item.
class FirefighterModel extends SettingItem {
  FirefighterModel({required super.id, required super.name, super.createdAt});

  factory FirefighterModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final parsed = SettingItem.parseDoc(d);
    return FirefighterModel(
      id: parsed.id,
      name: parsed.name,
      createdAt: parsed.createdAt,
    );
  }
}
