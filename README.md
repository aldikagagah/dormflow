# 🏠 DormFlow Mobile

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.35.7-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-Proprietary-red)

**Smart Dorm Management System**

Aplikasi manajemen asrama modern untuk pengelolaan jadwal, absensi, dan keuangan yang lebih efisien.

</div>

---

## 📸 Screenshots

| Login | Dashboard | Finance | Profile |
|-------|-----------|---------|---------|
| *Login Screen* | *Main Dashboard* | *Finance Tracker* | *User Profile* |

---

## ✨ Features

### 🔐 Authentication
- Email & Password login
- User registration
- Profile photo upload
- Password change

### 📅 Schedule Management
- Create, edit, delete schedules
- Day-based filtering
- Priority & category labels

### ✅ Attendance
- Check-in & Check-out
- Late detection
- Attendance history
- Real-time status

### 💰 Finance
- Income & Expense tracking
- Monthly summary
- Category-based transactions
- Transaction history

### 👤 Profile
- Edit personal info
- Photo upload to Firebase Storage
- Theme preferences (Light/Dark/System)
- Account settings

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.35.7 |
| **Language** | Dart 3.9.2 |
| **State Management** | Provider |
| **Backend** | Firebase |
| **Authentication** | Firebase Auth |
| **Database** | Cloud Firestore |
| **Storage** | Firebase Storage |
| **Local Storage** | Shared Preferences |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  firebase_core: ^4.2.1
  firebase_auth: ^6.1.2
  cloud_firestore: ^6.1.0
  firebase_storage: ^13.0.4
  provider: ^6.1.5+1
  shared_preferences: ^2.5.4
  image_picker: ^1.0.7
  intl: ^0.20.2
  fl_chart: ^1.1.1
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.35.7+
- Android SDK (API 21+)
- Firebase project setup
- Java JDK 11+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/dormflow_mobile.git
   cd dormflow_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   flutterfire configure --project=your-firebase-project
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build APK

```bash
# Debug
flutter build apk --debug

# Release (split per ABI)
flutter build apk --split-per-abi --release
```

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── providers/
│   └── theme_provider.dart   # Theme state management
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── dashboard_screen.dart
│   ├── attendance_screen.dart
│   ├── finance_screen.dart
│   ├── schedule_screen.dart
│   └── profile_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── attendance_service.dart
│   ├── finance_service.dart
│   ├── schedule_service.dart
│   └── profile_service.dart
├── widgets/
│   ├── add_schedule_form.dart
│   ├── app_header.dart
│   ├── attendance_card.dart
│   ├── custom_button.dart
│   ├── custom_textfield.dart
│   ├── edit_profile_sheet.dart
│   ├── schedule_card.dart
│   ├── theme_toggle.dart
│   └── transaction_form.dart
└── theme/
    └── app_theme.dart        # Design system
```

---

## 🔥 Firebase Setup

### Required Firebase Services

1. **Authentication** - Email/Password enabled
2. **Cloud Firestore** - Collections:
   - `users` - User profiles
   - `attendance` - Attendance records
   - `transactions` - Finance transactions
   - `schedules` - Schedule data
3. **Firebase Storage** - For profile photos

### Security Rules

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /attendance/{docId} {
      allow read, write: if request.auth != null;
    }
    match /transactions/{docId} {
      allow read, write: if request.auth != null
        && resource.data.userId == request.auth.uid;
    }
    match /schedules/{docId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Storage Rules:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_photos/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 🎨 Theme

App supports **Light**, **Dark**, and **System** themes:

- Theme preference is saved locally
- Automatically follows system preference when set to "System"
- Comprehensive design tokens in `app_theme.dart`

---

## 📱 Minimum Requirements

| Platform | Minimum Version |
|----------|-----------------|
| Android | API 21 (Android 5.0) |
| iOS | iOS 12.0 |

---

## 📄 License

This project is proprietary and confidential. Unauthorized copying, distribution, or modification is strictly prohibited.

---

## 👨‍💻 Author

**DormFlow Team**

---

*Made with ❤️ using Flutter*
