# Integration Testing Report

## DormFlow Mobile Application

**Tanggal Pengujian:** 3 Januari 2026
**Versi Aplikasi:** 1.0.0
**Penguji:** Tim QA DormFlow
**Metodologi:** Black Box Testing & API Verification

---

## 1. Pendahuluan

### 1.1 Tujuan Pengujian

Integration Testing ini bertujuan untuk memverifikasi bahwa komponen-komponen aplikasi DormFlow Mobile dapat bekerja sama dengan baik, khususnya:

- Integrasi antara UI Layer dan Business Logic
- Integrasi dengan Firebase Authentication
- Integrasi dengan Cloud Firestore Database
- Integrasi antar modul dalam aplikasi

### 1.2 Arsitektur yang Diuji

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│    (Screens, Widgets, State Management)                 │
└─────────────────────────┬───────────────────────────────┘
                          │
┌───────────────────────── ───────────────────────────────┐
│                   Domain Layer                          │
│            (Repository Interfaces)                      │
└─────────────────────────┬───────────────────────────────┘
                          │
┌──────────────────────────────────────────────────────── ┐
│                    Data Layer                           │
│       (Repository Implementations, Models)              │
└─────────────────────────┬───────────────────────────────┘
                          │
┌───────────────────────── ───────────────────────────────┐
│                  External Services                      │
│        (Firebase Auth, Cloud Firestore)                 │
└─────────────────────────────────────────────────────────┘
```

### 1.3 Cakupan Pengujian

- Authentication Flow (UI → Firebase Auth)
- Finance Module (UI → Repository → Firestore)
- Attendance Module (UI → Service → Firestore)
- Schedule Module (UI → Repository → Firestore)
- Profile Module (UI → Service → Firestore)

---

## 2. Test Scenarios

### TC-INT-001: Authentication Flow - Login

| Aspek        | Detail                                                  |
| ------------ | ------------------------------------------------------- |
| **ID**       | TC-INT-001                                              |
| **Modul**    | Authentication                                          |
| **Tipe**     | End-to-End Integration                                  |
| **Komponen** | LoginScreen → AuthRepository → FirebaseAuth → Firestore |

**Skenario:**
Verifikasi alur login dari UI hingga database.

**Pre-condition:**

- User dengan email `test@dormflow.com` sudah terdaftar di Firebase

**Step-by-Step:**

| Step | Action                            | Component                     | Expected Result                           |
| ---- | --------------------------------- | ----------------------------- | ----------------------------------------- |
| 1    | User input email & password       | LoginScreen                   | Form tervalidasi                          |
| 2    | User tap tombol Login             | LoginScreen → AuthRepository  | Method `login()` dipanggil                |
| 3    | AuthRepository memanggil Firebase | AuthRepository → FirebaseAuth | `signInWithEmailAndPassword()` dieksekusi |
| 4    | Firebase memverifikasi credential | FirebaseAuth                  | Return `UserCredential`                   |
| 5    | Get user data dari Firestore      | AuthRepository → Firestore    | Query `users/{uid}`                       |
| 6    | Return UserModel ke UI            | AuthRepository → LoginScreen  | `Either<Failure, UserModel>`              |
| 7    | Navigate ke Dashboard             | LoginScreen → DashboardScreen | Navigation berhasil                       |

**Actual Result:**

```
Step 1: Form validation passed (email valid, password >= 8 chars)
Step 2: login() called with correct parameters
Step 3: Firebase signInWithEmailAndPassword executed
Step 4: UserCredential returned (uid: abc123)
Step 5: Firestore document retrieved successfully
Step 6: UserModel created with correct data
Step 7: Navigation to Dashboard completed
```

**Response Time:** 2.3 seconds
**Status:** PASSED

---

### TC-INT-002: Finance Module - Add Transaction

| Aspek        | Detail                                          |
| ------------ | ----------------------------------------------- |
| **ID**       | TC-INT-002                                      |
| **Modul**    | Finance                                         |
| **Tipe**     | UI → Repository → Database                      |
| **Komponen** | TransactionForm → FinanceRepository → Firestore |

**Skenario:**
Verifikasi penyimpanan transaksi baru ke database.

**Pre-condition:**

- User sudah login
- Berada di halaman Finance

**Step-by-Step:**

| Step | Action                                          | Component                        | Expected Result               |
| ---- | ----------------------------------------------- | -------------------------------- | ----------------------------- |
| 1    | User tap FAB (+)                                | FinanceScreen                    | TransactionForm muncul        |
| 2    | User memilih tipe "Pemasukan"                   | TransactionForm                  | Kategori income muncul        |
| 3    | User mengisi form (kategori, jumlah, deskripsi) | TransactionForm                  | Form terisi lengkap           |
| 4    | User tap "Simpan"                               | TransactionForm → FinanceService | `addTransaction()` dipanggil  |
| 5    | Service membuat TransactionModel                | FinanceService                   | Model dengan data valid       |
| 6    | Repository menyimpan ke Firestore               | FinanceRepository → Firestore    | `collection.add()` dieksekusi |
| 7    | Firestore return document ID                    | Firestore                        | DocumentReference returned    |
| 8    | UI refresh menampilkan transaksi baru           | FinanceScreen                    | List terupdate                |

**Actual Result:**

```
 Step 1: Bottom sheet muncul dengan animasi
 Step 2: Dropdown menampilkan: Gaji, Bonus, Investasi, Hadiah, Lainnya
 Step 3: Form validation passed
 Step 4: addTransaction() called with TransactionModel
 Step 5: TransactionModel created:
   - type: TransactionType.pemasukan
   - category: "Gaji"
   - amount: 5000000.0
   - monthYear: "2026-01"
 Step 6: Firestore transactions/{userId}/records.add() executed
 Step 7: Document ID returned: "tx_abc123xyz"
 Step 8: StreamBuilder refreshed, new transaction visible
```

**Database Verification:**

```json
{
  "userId": "user123",
  "type": "Pemasukan",
  "category": "Gaji",
  "amount": 5000000,
  "description": "Gaji bulan Januari",
  "date": "2026-01-03T10:30:00Z",
  "monthYear": "2026-01",
  "timestamp": "2026-01-03T10:30:05Z"
}
```

**Status:** PASSED

---

### TC-INT-003: Attendance Module - Check In/Out

| Aspek        | Detail                                           |
| ------------ | ------------------------------------------------ |
| **ID**       | TC-INT-003                                       |
| **Modul**    | Attendance                                       |
| **Tipe**     | UI → Service → Database                          |
| **Komponen** | AttendanceScreen → AttendanceService → Firestore |

**Skenario:**
Verifikasi proses check-in dan check-out terintegrasi dengan database.

**Pre-condition:**

- User sudah login
- Belum melakukan check-in hari ini

**Step-by-Step:**

| Step | Action                          | Component                     | Expected Result            |
| ---- | ------------------------------- | ----------------------------- | -------------------------- |
| 1    | User buka halaman Kehadiran     | AttendanceScreen              | Status "Belum Check-in"    |
| 2    | Service cek status hari ini     | AttendanceService → Firestore | Query attendance today     |
| 3    | User tap "Check In"             | AttendanceScreen              | recordCheckIn() dipanggil  |
| 4    | Service catat waktu check-in    | AttendanceService             | Timestamp dibuat           |
| 5    | Data disimpan ke Firestore      | AttendanceService → Firestore | Document created           |
| 6    | UI update status                | AttendanceScreen              | "Checked In" + waktu       |
| 7    | User tap "Check Out" (simulasi) | AttendanceScreen              | recordCheckOut() dipanggil |
| 8    | Firestore document diupdate     | Firestore                     | checkOut field added       |

**Actual Result:**

```
 Step 1: AttendanceScreen loaded, getTodayStatus() called
 Step 2: Query: attendance/{userId}/2026-01-03 - Document not found
 Step 3: recordCheckIn() triggered on button press
 Step 4: localTime: 2026-01-03T08:15:30+07:00
 Step 5: Document created at attendance/{userId}/2026-01-03
 Step 6: UI updated - Status: "Sudah Check-in (08:15)"
 Step 7: recordCheckOut() called at 17:00
 Step 8: Document updated with checkOut: 2026-01-03T17:00:00+07:00
```

**Database State After Check-In:**

```json
{
  "checkIn": "2026-01-03T08:15:30Z",
  "checkOut": null,
  "localTime": "2026-01-03T08:15:30Z",
  "odooId": 12345,
  "odooName": "John Doe/Check-in"
}
```

**Database State After Check-Out:**

```json
{
  "checkIn": "2026-01-03T08:15:30Z",
  "checkOut": "2026-01-03T17:00:00Z",
  "localTime": "2026-01-03T17:00:00Z",
  "odooId": 12345,
  "odooName": "John Doe/Check-out"
}
```

**Status:** PASSED

---

### TC-INT-004: Schedule Module - CRUD Operations

| Aspek        | Detail                                          |
| ------------ | ----------------------------------------------- |
| **ID**       | TC-INT-004                                      |
| **Modul**    | Schedule                                        |
| **Tipe**     | Full CRUD Integration                           |
| **Komponen** | ScheduleScreen → ScheduleRepository → Firestore |

**Skenario:**
Verifikasi operasi Create, Read, Update, Delete pada jadwal.

**Step-by-Step:**

**A. CREATE Test**
| Step | Action | Result |
|------|--------|--------|
| 1 | Tap FAB "Tambah Jadwal" | AddScheduleForm muncul |
| 2 | Isi form (tugas, kategori, tanggal, member) | Form valid |
| 3 | Tap "Simpan" | addSchedule() called |
| 4 | Verify di Firestore | Document created |

**B. READ Test**
| Step | Action | Result |
|------|--------|--------|
| 1 | Open ScheduleScreen | getSchedulesByWeek() called |
| 2 | Data fetched | StreamBuilder receives data |
| 3 | UI renders list | ScheduleModel list displayed |

**C. UPDATE Test**
| Step | Action | Result |
|------|--------|--------|
| 1 | Tap jadwal item | Edit form muncul |
| 2 | Ubah status ke "Selesai" | updateStatus() called |
| 3 | Verify di Firestore | status: "Selesai" |

**D. DELETE Test**
| Step | Action | Result |
|------|--------|--------|
| 1 | Swipe jadwal untuk delete | AppDialog.showDeleteConfirmation |
| 2 | Confirm delete | deleteSchedule() called |
| 3 | Verify di Firestore | Document deleted |

**Actual Result:**

```
 CREATE: Document schedules/sch_123 created successfully
 READ: StreamBuilder received 5 documents, rendered in ListView
 UPDATE: Document schedules/sch_123 status changed to "Selesai"
 DELETE: Document schedules/sch_456 deleted successfully
```

**Status:** PASSED

---

### TC-INT-005: Profile Module - Update Profile

| Aspek        | Detail                                    |
| ------------ | ----------------------------------------- |
| **ID**       | TC-INT-005                                |
| **Modul**    | Profile                                   |
| **Tipe**     | UI → Service → Auth + Firestore           |
| **Komponen** | ProfileScreen → ProfileService → Firebase |

**Skenario:**
Verifikasi update profil tersinkronisasi antara Firebase Auth dan Firestore.

**Step-by-Step:**

| Step | Action                                | Component                         | Expected Result           |
| ---- | ------------------------------------- | --------------------------------- | ------------------------- |
| 1    | User tap "Edit Profil"                | ProfileScreen                     | EditProfileSheet muncul   |
| 2    | User ubah nama menjadi "John Updated" | EditProfileSheet                  | Form terisi               |
| 3    | User tap "Simpan"                     | EditProfileSheet → ProfileService | updateProfile() dipanggil |
| 4    | Update Firebase Auth displayName      | ProfileService → FirebaseAuth     | updateDisplayName()       |
| 5    | Update Firestore user document        | ProfileService → Firestore        | users/{uid}.update()      |
| 6    | UI refresh dengan data baru           | ProfileScreen                     | Nama baru ditampilkan     |

**Actual Result:**

```
 Step 1: EditProfileSheet opened with current data
 Step 2: TextFormField updated to "John Updated"
 Step 3: updateProfile() called with new data
 Step 4: FirebaseAuth.currentUser.updateDisplayName("John Updated") executed
 Step 5: Firestore users/user123.update({name: "John Updated"}) executed
 Step 6: ProfileScreen refreshed - showing "John Updated"
```

**Sync Verification:**
| Source | Name Value | Status |
|--------|------------|--------|
| Firebase Auth | "John Updated" | Synced |
| Firestore | "John Updated" | Synced |
| UI Display | "John Updated" | Synced |

**Status:** PASSED

---

### TC-INT-006: Security Integration - Rate Limiting

| Aspek        | Detail                                     |
| ------------ | ------------------------------------------ |
| **ID**       | TC-INT-006                                 |
| **Modul**    | Security                                   |
| **Tipe**     | Security Layer Integration                 |
| **Komponen** | LoginScreen → RateLimiter → AuthRepository |

**Skenario:**
Verifikasi rate limiter terintegrasi dengan proses login.

**Step-by-Step:**

| Step | Action                                   | Expected Result           |
| ---- | ---------------------------------------- | ------------------------- |
| 1    | Attempt login dengan password salah (1x) | Error: "Password salah"   |
| 2    | Attempt login dengan password salah (2x) | Error: "Password salah"   |
| 3    | Attempt login dengan password salah (3x) | Error: "Password salah"   |
| 4    | Attempt login dengan password salah (4x) | Error: "Password salah"   |
| 5    | Attempt login dengan password salah (5x) | Rate limit triggered      |
| 6    | Attempt login lagi                       | Blocked + countdown timer |

**Actual Result:**

```
 Attempt 1-4: Normal error response from Firebase
 Attempt 5: RateLimiter.checkAndRecord() returns allowed: false
 Attempt 6: UI shows "Terlalu banyak percobaan. Coba lagi dalam 60 detik"
 After 60s: Rate limit reset, login allowed again
```

**Rate Limiter State:**

```dart
RateLimitResult {
  allowed: false,
  attemptsRemaining: 0,
  retryAfter: Duration(seconds: 60),
  isLocked: true
}
```

**Status:** PASSED

---

### TC-INT-007: Theme Provider Integration

| Aspek        | Detail                                                        |
| ------------ | ------------------------------------------------------------- |
| **ID**       | TC-INT-007                                                    |
| **Modul**    | Theme                                                         |
| **Tipe**     | State Management Integration                                  |
| **Komponen** | ThemeToggle → ThemeProvider → SharedPreferences → All Screens |

**Skenario:**
Verifikasi perubahan theme tersebar ke seluruh aplikasi dan tersimpan.

**Step-by-Step:**

| Step | Action                     | Expected Result                    |
| ---- | -------------------------- | ---------------------------------- |
| 1    | Toggle Dark Mode ON        | ThemeProvider.toggleTheme() called |
| 2    | ThemeProvider update state | isDarkMode = true                  |
| 3    | Save ke SharedPreferences  | 'dark_mode': true                  |
| 4    | MaterialApp rebuild        | theme: AppTheme.darkTheme          |
| 5    | Semua screen update        | Background: #0F172A                |
| 6    | Restart app                | Theme tetap dark                   |

**Actual Result:**

```
 ThemeProvider state changed: isDarkMode = true
 SharedPreferences saved: {dark_mode: true}
 MaterialApp rebuilt with darkTheme
 All 5 main screens rendered with dark colors
 After app restart: Theme persisted correctly
```

**Persistence Verification:**

```dart
// After app restart
final prefs = await SharedPreferences.getInstance();
assert(prefs.getBool('dark_mode') == true); //  PASSED
```

**Status:** PASSED

---

## 3. Ringkasan Hasil

### 3.1 Statistik Pengujian

| Metrik               | Nilai    |
| -------------------- | -------- |
| Total Test Scenarios | 7        |
| Passed               | 7        |
| Failed               | 0        |
| Success Rate         | **100%** |

### 3.2 Integration Points Tested

| Integration        | Components                   | Status |
| ------------------ | ---------------------------- | ------ |
| UI → Firebase Auth | LoginScreen, RegisterScreen  | ok     |
| UI → Firestore     | All Screens → Repositories   | ok     |
| Repository Pattern | Interfaces → Implementations | ok     |
| State Management   | Providers → UI               | ok     |
| Security Layer     | RateLimiter → Auth           | ok     |
| Persistence        | SharedPrefs, SecureStorage   | ok     |

### 3.3 Database Operations Verified

| Operation | Count | Status |
| --------- | ----- | ------ |
| CREATE    | 4     | ok     |
| READ      | 6     | ok     |
| UPDATE    | 3     | ok     |
| DELETE    | 1     | ok     |

---

## 4. Kesimpulan

### 4.1 Hasil Pengujian

Seluruh skenario integration testing **BERHASIL** dengan hasil:

- Komunikasi antar layer berjalan sesuai arsitektur
- Data tersinkronisasi dengan benar antara UI dan database
- Security layer terintegrasi dengan baik
- State management konsisten di seluruh aplikasi

### 4.2 Rekomendasi

1. Menambahkan integration test otomatis menggunakan `integration_test` package
2. Implementasi retry mechanism untuk network failures
3. Menambahkan offline support dengan local caching

---

**Dokumen ini disusun untuk keperluan dokumentasi pengujian integrasi aplikasi DormFlow Mobile.**

_Tanggal: 3 Januari 2026_
