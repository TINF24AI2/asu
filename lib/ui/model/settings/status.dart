import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/setting_item.dart';

// Plain class model for a status setting item.
class StatusModel extends SettingItem {
  StatusModel({required super.id, required super.name, super.createdAt});

  factory StatusModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final parsed = SettingItem.parseDoc(d);
    return StatusModel(
      id: parsed.id,
      name: parsed.name,
      createdAt: parsed.createdAt,
    );
  }
}
