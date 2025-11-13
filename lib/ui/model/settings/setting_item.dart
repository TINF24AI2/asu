import 'package:cloud_firestore/cloud_firestore.dart';

// Base class model for a setting item.
class SettingItem {
  final String id;
  final String name;
  final DateTime? createdAt;

  const SettingItem({required this.id, required this.name, this.createdAt});

  Map<String, dynamic> toFirestore() {
    final map = <String, dynamic>{'name': name};
    if (createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SettingItem && id == other.id);

  @override
  int get hashCode => id.hashCode;

  // Helper to parse the common fields from a document snapshot.
  static ({String id, String name, DateTime? createdAt}) parseDoc(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final m = d.data() ?? <String, dynamic>{};
    final created = m['createdAt'];
    DateTime? createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    }
    return (id: d.id, name: m['name'] ?? '', createdAt: createdAt);
  }
}
