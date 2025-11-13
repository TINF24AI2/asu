import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/setting_item.dart';

// Plain class model for a location setting item.
class LocationModel extends SettingItem {
  LocationModel({required super.id, required super.name, super.createdAt});

  factory LocationModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final parsed = SettingItem.parseDoc(d);
    return LocationModel(
      id: parsed.id,
      name: parsed.name,
      createdAt: parsed.createdAt,
    );
  }
}
