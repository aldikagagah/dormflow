import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Marks attendance for the current user.
  /// [type] should be "Masuk" or "Keluar".
  Future<String> markAttendance(String type) async {
    try {
      final user = currentUser;
      if (user == null) return 'User not logged in';

      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now); // For simple querying

      // Check for duplicates (optional but good practice)
      // For "Masuk", we might want to prevent double check-in
      if (type == 'Masuk') {
        final existing = await _db
            .collection('attendance')
            .where('userId', isEqualTo: user.uid)
            .where('date', isEqualTo: dateStr)
            .where('type', isEqualTo: 'Masuk')
            .get();

        if (existing.docs.isNotEmpty) {
           return 'Sudah absen masuk hari ini';
        }
      }

      await _db.collection('attendance').add({
        'userId': user.uid,
        'userEmail': user.email,
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'localTime': now.toIso8601String(),
        'date': dateStr, // Key for today's status query
        'status': type == 'Masuk'
             // Simple logic: Late if after 9:00 AM (example)
             ? (now.hour >= 9 ? 'Terlambat' : 'Hadir')
             : 'Selesai',
      });

      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Get today's attendance status for the current user.
  /// Returns a Map with 'checkIn' and 'checkOut' times if they exist.
  Future<Map<String, dynamic>> getTodayStatus() async {
    final user = currentUser;
    if (user == null) return {};

    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);

    final snapshot = await _db
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .where('date', isEqualTo: dateStr)
        .get();

    String? checkInTime;
    String? checkOutTime;
    String status = 'Belum Absen';

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final time = DateTime.parse((data['localTime'] as String?) ?? DateTime.now().toIso8601String());
      final formattedTime = DateFormat('hh:mm a').format(time);

      if (data['type'] == 'Masuk') {
        checkInTime = formattedTime;
        status = (data['status'] as String?) ?? 'Hadir';
      } else if (data['type'] == 'Keluar') {
        checkOutTime = formattedTime;
      }
    }

    return {
      'checkIn': checkInTime,
      'checkOut': checkOutTime,
      'status': status,
      'hasCheckedIn': checkInTime != null,
      'hasCheckedOut': checkOutTime != null,
    };
  }

  /// Stream of attendance history for the ID History Table.
  /// Limited to 20 most recent records to prevent lag.
  Stream<List<Map<String, dynamic>>> getAttendanceHistory() {
    final user = currentUser;
    if (user == null) return Stream.value([]);

    // Query with limit to prevent loading too much data
    return _db
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .limit(20) // Limit to 20 records to prevent lag
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        // Handle null timestamp gracefully
        DateTime dt;
        try {
          dt = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
        } catch (e) {
          dt = DateTime.now();
        }

        return {
          'id': doc.id,
          'date': DateFormat('dd MMM yyyy').format(dt),
          'time': DateFormat('HH:mm').format(dt),
          'type': data['type'] ?? '-',
          'status': data['status'] ?? '-',
          'timestamp': dt,
        };
      }).toList();
      // Sort client-side (newest first)
      list.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
      return list;
    });
  }
}
