import 'package:cloud_firestore/cloud_firestore.dart';

// Model for storing initial settings (default pressure and theoretical duration).
class InitialSettingsModel {
  // Central default values - used across the app for consistency
  // Needed when user skips post-register setup
  static const int kStandardMaxPressure = 300;
  static const int kStandardTheoreticalDurationMinutes = 30;

  final int defaultPressure;
  final int theoreticalDurationMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InitialSettingsModel({
    required this.defaultPressure,
    required this.theoreticalDurationMinutes,
    this.createdAt,
    this.updatedAt,
  });

  factory InitialSettingsModel.fromFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }

    return InitialSettingsModel(
      defaultPressure: data['defaultPressure'] as int? ?? kStandardMaxPressure,
      theoreticalDurationMinutes:
          data['theoreticalDurationMinutes'] as int? ??
          kStandardTheoreticalDurationMinutes,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'defaultPressure': defaultPressure,
      'theoreticalDurationMinutes': theoreticalDurationMinutes,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }
}
