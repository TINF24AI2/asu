import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/setting_item.dart';

// Plain class model for a radio call setting item.
class RadioCallModel extends SettingItem {
  RadioCallModel({required super.id, required super.name, super.createdAt});

  factory RadioCallModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final parsed = SettingItem.parseDoc(d);
    return RadioCallModel(
      id: parsed.id,
      name: parsed.name,
      createdAt: parsed.createdAt,
    );
  }
}
