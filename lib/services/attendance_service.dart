import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> markAttendance(String type) async {
    try {
      final now = DateTime.now();

      await _db.collection("attendance").add({
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'localTime': now.toIso8601String(),
      });

      return "success";
    } catch (e) {
      return "error: $e";
    }
  }
}
