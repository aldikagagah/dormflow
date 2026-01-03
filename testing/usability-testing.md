# Usability Testing Report

## DormFlow Mobile Application

**Tanggal Pengujian:** 3 Januari 2026
**Versi Aplikasi:** 1.0.0
**Penguji:** Tim QA DormFlow
**Metodologi:** Manual Testing & User Observation

---

## 1. Pendahuluan

### 1.1 Tujuan Pengujian

Usability Testing ini bertujuan untuk mengevaluasi kemudahan penggunaan (usability) aplikasi DormFlow Mobile dari perspektif pengguna akhir. Pengujian difokuskan pada:

- Kemudahan navigasi antar fitur
- Kejelasan informasi yang ditampilkan
- Waktu respon aplikasi
- Kepuasan pengguna secara keseluruhan

### 1.2 Ruang Lingkup

Pengujian mencakup fitur-fitur utama aplikasi:

- Autentikasi (Login & Register)
- Dashboard
- Manajemen Keuangan
- Pencatatan Kehadiran
- Manajemen Jadwal
- Profil Pengguna

### 1.3 Kriteria Keberhasilan

- Task Success Rate ≥ 90%
- Average Task Completion Time sesuai standar
- User Satisfaction Score ≥ 4/5

---

## 2. Test Cases

### TC-US-001: Login dengan Kredensial Valid

| Aspek         | Detail                                                           |
| ------------- | ---------------------------------------------------------------- |
| **ID**        | TC-US-001                                                        |
| **Nama**      | Login dengan Kredensial Valid                                    |
| **Tujuan**    | Memastikan pengguna dapat melakukan login dengan mudah dan cepat |
| **Prasyarat** | Pengguna sudah memiliki akun terdaftar                           |

**Langkah Pengujian:**

1. Buka aplikasi DormFlow Mobile
2. Masukkan email yang terdaftar pada field "Email"
3. Masukkan password yang benar pada field "Password"
4. Tekan tombol "Masuk"

**Expected Result:**

- Form validasi berjalan dengan baik
- Loading indicator muncul selama proses autentikasi
- Pengguna diarahkan ke halaman Dashboard setelah login berhasil
- Waktu proses login tidak lebih dari 3 detik

**Actual Result:**

- Form validasi berfungsi dengan baik (menampilkan error jika field kosong)
- Loading indicator (BouncingDotsLoading) muncul selama proses
- Redirect ke Dashboard berhasil dalam 2.1 detik
- Snackbar sukses muncul dengan pesan "Login berhasil"

**Status:** PASSED

---

### TC-US-002: Registrasi Akun Baru

| Aspek         | Detail                                                       |
| ------------- | ------------------------------------------------------------ |
| **ID**        | TC-US-002                                                    |
| **Nama**      | Registrasi Akun Baru                                         |
| **Tujuan**    | Memastikan proses registrasi mudah dipahami dan diselesaikan |
| **Prasyarat** | Belum memiliki akun                                          |

**Langkah Pengujian:**

1. Buka aplikasi dan tekan "Daftar"
2. Isi field Nama Lengkap
3. Isi field Email dengan format yang valid
4. Isi field Password (minimal 8 karakter)
5. Isi field Konfirmasi Password
6. Tekan tombol "Daftar"

**Expected Result:**

- Validasi real-time pada setiap field
- Feedback visual jika password tidak match
- Proses registrasi selesai dalam waktu wajar
- Redirect ke halaman Login atau Dashboard

**Actual Result:**

- Validasi email menampilkan error untuk format tidak valid
- Password strength indicator memberikan feedback visual
- Konfirmasi password match validation berfungsi
- Registrasi selesai dalam 3.5 detik
- Dialog sukses muncul dengan animasi checkmark

**Status:** PASSED

---

### TC-US-003: Navigasi Dashboard

| Aspek         | Detail                                                       |
| ------------- | ------------------------------------------------------------ |
| **ID**        | TC-US-003                                                    |
| **Nama**      | Navigasi Dashboard                                           |
| **Tujuan**    | Memastikan pengguna dapat menavigasi menu utama dengan mudah |
| **Prasyarat** | Pengguna sudah login                                         |

**Langkah Pengujian:**

1. Dari Dashboard, amati tampilan bottom navigation
2. Tekan ikon "Keuangan"
3. Tekan ikon "Kehadiran"
4. Tekan ikon "Jadwal"
5. Tekan ikon "Profil"
6. Kembali ke "Dashboard"

**Expected Result:**

- Semua navigasi dapat diakses dalam 1 tap
- Transisi antar halaman smooth (< 500ms)
- Ikon aktif terhighlight dengan jelas
- Tidak ada lag atau freeze

**Actual Result:**

- Bottom navigation responsif, semua menu dapat diakses
- Transisi menggunakan PageView dengan animasi smooth
- Ikon aktif menampilkan warna primary (#4F46E5)
- Tidak ada lag, performa baik

**Status:** PASSED

---

### TC-US-004: Menambah Transaksi Keuangan

| Aspek         | Detail                                                    |
| ------------- | --------------------------------------------------------- |
| **ID**        | TC-US-004                                                 |
| **Nama**      | Menambah Transaksi Keuangan                               |
| **Tujuan**    | Memastikan pengguna dapat mencatat transaksi dengan mudah |
| **Prasyarat** | Pengguna berada di halaman Keuangan                       |

**Langkah Pengujian:**

1. Tekan tombol FAB (+) di halaman Keuangan
2. Pilih tipe transaksi (Pemasukan/Pengeluaran)
3. Pilih kategori dari dropdown
4. Masukkan jumlah nominal
5. Tambahkan deskripsi (opsional)
6. Tekan tombol "Simpan"

**Expected Result:**

- Form muncul dalam bottom sheet
- Dropdown kategori sesuai tipe transaksi
- Keyboard numerik muncul untuk field jumlah
- Validasi untuk field wajib
- Feedback sukses setelah penyimpanan

**Actual Result:**

- Bottom sheet muncul dengan animasi slide-up
- Kategori berubah sesuai tipe (Income/Expense categories)
- Keyboard numerik muncul otomatis
- Validasi "Jumlah harus diisi" berfungsi
- AppSnackBar.showSuccess muncul setelah simpan

**Status:** PASSED

---

### TC-US-005: Melakukan Check-In Kehadiran

| Aspek         | Detail                                                        |
| ------------- | ------------------------------------------------------------- |
| **ID**        | TC-US-005                                                     |
| **Nama**      | Melakukan Check-In Kehadiran                                  |
| **Tujuan**    | Memastikan proses check-in intuitif dan cepat                 |
| **Prasyarat** | Pengguna berada di halaman Kehadiran, belum check-in hari ini |

**Langkah Pengujian:**

1. Buka halaman Kehadiran
2. Amati status kehadiran hari ini
3. Tekan tombol "Check In"
4. Konfirmasi check-in jika diperlukan

**Expected Result:**

- Status kehadiran terkini ditampilkan dengan jelas
- Tombol check-in prominent dan mudah ditemukan
- Feedback sukses dengan timestamp
- UI terupdate menampilkan status "Checked In"

**Actual Result:**

- Status ditampilkan dengan card prominent di atas
- Tombol check-in besar dengan gradient primary
- Loading indicator saat proses
- SuccessCheckmark animation muncul
- Waktu check-in ditampilkan: "08:15:30"

**Status:** PASSED

---

### TC-US-006: Melihat Jadwal Mingguan

| Aspek         | Detail                                                    |
| ------------- | --------------------------------------------------------- |
| **ID**        | TC-US-006                                                 |
| **Nama**      | Melihat Jadwal Mingguan                                   |
| **Tujuan**    | Memastikan jadwal ditampilkan dengan jelas dan informatif |
| **Prasyarat** | Pengguna berada di halaman Jadwal                         |

**Langkah Pengujian:**

1. Buka halaman Jadwal
2. Amati tampilan jadwal minggu ini
3. Scroll untuk melihat jadwal lainnya
4. Tap pada salah satu jadwal untuk detail

**Expected Result:**

- Jadwal dikelompokkan per hari
- Informasi tugas, waktu, dan nama petugas jelas
- Warna kategori membedakan jenis tugas
- List dapat di-scroll dengan smooth

**Actual Result:**

- Jadwal dikelompokkan dengan header tanggal
- Setiap card menampilkan: tugas, kategori, assigned member
- Kategori dibedakan dengan warna (Piket=blue, Ngaji=green, dll)
- FadeSlideTransition memberikan animasi masuk yang smooth
- EmptyStateWidget muncul jika tidak ada jadwal

**Status:** PASSED

---

### TC-US-007: Edit Profil Pengguna

| Aspek         | Detail                                                           |
| ------------- | ---------------------------------------------------------------- |
| **ID**        | TC-US-007                                                        |
| **Nama**      | Edit Profil Pengguna                                             |
| **Tujuan**    | Memastikan pengguna dapat mengubah informasi profil dengan mudah |
| **Prasyarat** | Pengguna berada di halaman Profil                                |

**Langkah Pengujian:**

1. Buka halaman Profil
2. Tekan tombol "Edit Profil"
3. Ubah nama atau nomor telepon
4. Tekan tombol "Simpan"

**Expected Result:**

- Bottom sheet edit profil muncul dengan data existing
- Field dapat diedit dengan mudah
- Validasi input berjalan
- Perubahan tersimpan dan terlihat langsung

**Actual Result:**

- EditProfileSheet muncul dengan data terisi
- Keyboard muncul otomatis pada field yang diklik
- Validasi nama (minimal 2 karakter) berfungsi
- Perubahan tersimpan ke Firestore dalam 1.5 detik
- Profil terupdate tanpa perlu refresh manual

**Status:** PASSED

---

### TC-US-008: Dark Mode Toggle

| Aspek         | Detail                                               |
| ------------- | ---------------------------------------------------- |
| **ID**        | TC-US-008                                            |
| **Nama**      | Dark Mode Toggle                                     |
| **Tujuan**    | Memastikan pengguna dapat mengubah tema dengan mudah |
| **Prasyarat** | Pengguna berada di halaman Profil atau Settings      |

**Langkah Pengujian:**

1. Buka halaman Profil
2. Temukan toggle Dark Mode
3. Aktifkan Dark Mode
4. Amati perubahan tampilan
5. Nonaktifkan Dark Mode

**Expected Result:**

- Toggle mudah ditemukan
- Perubahan tema instan tanpa delay
- Semua halaman mengikuti tema yang dipilih
- Preferensi tersimpan

**Actual Result:**

- ThemeToggle widget tersedia di Profil
- Transisi tema smooth (< 200ms)
- Semua screen menggunakan AppTheme.darkTheme
- Preferensi tersimpan di SharedPreferences

**Status:** PASSED

---

## 3. Ringkasan Hasil

### 3.1 Statistik Pengujian

| Metrik           | Nilai    |
| ---------------- | -------- |
| Total Test Cases | 8        |
| Passed           | 8        |
| Failed           | 0        |
| Success Rate     | **100%** |

### 3.2 Task Completion Time

| Task            | Target        | Actual | Status |
| --------------- | ------------- | ------ | ------ |
| Login           | < 3s          | 2.1s   | ok     |
| Register        | < 5s          | 3.5s   | 0k     |
| Navigation      | < 0.5s/screen | 0.3s   | ok     |
| Add Transaction | < 30s         | 22s    | ok     |
| Check-In        | < 5s          | 3s     | ok     |
| View Schedule   | < 2s          | 1.2s   | ok     |
| Edit Profile    | < 20s         | 15s    | ok     |
| Theme Toggle    | Instant       | < 0.2s | ok     |

### 3.3 User Satisfaction Score

Berdasarkan System Usability Scale (SUS):

| Aspek               | Skor (1-5) |
| ------------------- | ---------- |
| Kemudahan Navigasi  | 4.5        |
| Kejelasan Informasi | 4.3        |
| Kecepatan Respon    | 4.7        |
| Desain Visual       | 4.6        |
| Kepuasan Overall    | 4.5        |
| **Rata-rata**       | **4.52**   |

---

## 4. Kesimpulan

### 4.1 Kelebihan

1. **Navigasi Intuitif** - Bottom navigation dan page transitions yang smooth
2. **Feedback Visual** - Animasi dan snackbar yang informatif
3. **Performa Baik** - Waktu respon di bawah standar yang ditetapkan
4. **Konsistensi Desain** - Design system yang teraplikasi dengan baik

### 4.2 Rekomendasi Perbaikan

1. Menambahkan onboarding tutorial untuk pengguna baru
2. Menambahkan fitur search pada halaman jadwal
3. Menampilkan tooltip pada ikon-ikon yang kurang familiar

---

**Dokumen ini disusun untuk keperluan dokumentasi pengujian aplikasi DormFlow Mobile.**

_Tanggal: 3 Januari 2026_
