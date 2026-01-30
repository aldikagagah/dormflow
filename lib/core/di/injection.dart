/// Dependency Injection Setup untuk DormFlow Mobile
///
/// Menggunakan GetIt sebagai service locator.
/// Semua dependencies di-register di sini.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/attendance_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/finance_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../domain/repositories/repositories.dart';
import '../network/network_info.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Inisialisasi semua dependencies.
///
/// Dipanggil sekali saat aplikasi start di main.dart.
Future<void> initDependencies() async {
  // ============ EXTERNAL ============
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ============ CORE ============
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // ============ REPOSITORIES ============
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
}

/// Reset semua dependencies (untuk testing).
Future<void> resetDependencies() async {
  await sl.reset();
}
