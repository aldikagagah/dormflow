# 📚 DormFlow Mobile - API Documentation

## Overview

DormFlow Mobile menggunakan Clean Architecture dengan pattern Repository untuk akses data.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────┐
│                   UI Layer                       │
│        (Screens, Widgets, Providers)            │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│                Domain Layer                      │
│           (Repository Interfaces)                │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│                 Data Layer                       │
│    (Repository Impl, Models, Firebase)          │
└─────────────────────────────────────────────────┘
```

---

## 📦 Core Services

### SecureStorageService

Encrypted storage untuk data sensitif.

```dart
import 'package:dormflow_mobile/core/security/security.dart';

final storage = SecureStorageService.instance;

// Save token
await storage.saveAuthToken('your-jwt-token');

// Read token
final token = await storage.getAuthToken();

// Save user session
await storage.saveUserSession(
  userId: 'user123',
  email: 'user@email.com',
  displayName: 'John Doe',
);

// Clear all
await storage.clearAll();
```

**Methods:**
| Method | Description |
|--------|-------------|
| `saveAuthToken(token)` | Save JWT token |
| `getAuthToken()` | Get saved token |
| `deleteAuthToken()` | Remove token |
| `saveUserSession(...)` | Save user info |
| `getUserSession()` | Get user info map |
| `clearAll()` | Clear all data |

---

### SecurityService

Cryptographic utilities.

```dart
final security = SecurityService.instance;

// Hashing
final hash = security.hashSHA256('password');
final hash512 = security.hashSHA512('data');

// HMAC
final hmac = security.generateHMAC('data', 'secretKey');
final valid = security.verifyHMAC('data', hmac, 'secretKey');

// JWT utilities
final isValid = security.isValidJwtFormat(token);
final payload = security.parseJwtPayload(token);
final expired = security.isJwtExpired(token);

// XSS sanitization
final safe = security.sanitizeHtml('<script>bad</script>');

// Password strength
final result = security.checkPasswordStrength('MyP@ss123');
// result.isStrong, result.score, result.feedback
```

---

### AdvancedRateLimiter

Rate limiting dengan progressive lockout.

```dart
final limiter = AdvancedRateLimiter();

// Check before action
final result = limiter.checkAndRecord(
  RateLimitAction.login,
  userId: 'user123',
);

if (!result.allowed) {
  print('Rate limited. Wait ${result.retryAfter} seconds');
  return;
}

// Proceed with action...

// Reset after success
limiter.reset(RateLimitAction.login, userId: 'user123');
```

**Actions:**
- `RateLimitAction.login` - 5 attempts/minute
- `RateLimitAction.register` - 3 attempts/minute
- `RateLimitAction.passwordReset` - 3 attempts/10min
- `RateLimitAction.sensitiveAction` - 10 attempts/minute
- `RateLimitAction.normalAction` - 30 attempts/minute

---

### SessionManager

User session management.

```dart
final session = SessionManager.instance;

// Start session after login
await session.startSession(
  token: 'jwt-token',
  userId: 'user123',
  expiryDuration: Duration(hours: 24),
);

// Check session
final isActive = await session.isSessionActive();

// Listen to session state
session.sessionStateStream.listen((state) {
  if (state == SessionState.expired) {
    // Redirect to login
  }
});

// Record activity (reset inactivity timer)
session.recordActivity();

// End session
await session.endSession();
```

---

## 📊 Data Models

### UserModel

```dart
final user = UserModel(
  id: 'user123',
  email: 'user@email.com',
  name: 'John Doe',
  photoUrl: 'https://...',
  role: UserRole.admin,
  createdAt: DateTime.now(),
);

// From Firestore
final user = UserModel.fromFirestore(doc);

// To Firestore
final map = user.toFirestore();
```

### TransactionModel

```dart
final transaction = TransactionModel(
  id: 'tx123',
  userId: 'user123',
  type: TransactionType.pemasukan,
  category: 'Gaji',
  amount: 5000000,
  description: 'Gaji bulan Januari',
  date: DateTime.now(),
  monthYear: '2026-01',
);

// Helpers
transaction.formattedAmount  // "Rp 5.000.000"
transaction.formattedDate    // "03 Jan 2026"
transaction.isIncome         // true
```

### ScheduleModel

```dart
final schedule = ScheduleModel(
  id: 'sch123',
  taskName: 'Piket Dapur',
  category: 'Piket',
  assignedMemberId: 'user123',
  assignedMemberName: 'John',
  date: DateTime.now(),
  dateString: '2026-01-03',
  weekNumber: 1,
  status: ScheduleStatus.pending,
);

// Helpers
schedule.isToday      // true/false
schedule.isPast       // true/false
schedule.isCompleted  // true/false
schedule.dayName      // "Jumat"
```

### AttendanceModel

```dart
final attendance = AttendanceModel(
  id: 'att123',
  odooId: 123,
  odooName: 'John/Check-in',
  localTime: DateTime.now(),
  checkIn: DateTime.now(),
  checkOut: null,
);

// Helpers
attendance.isCheckedIn   // true
attendance.workDuration  // Duration
```

---

## 🗄️ Repositories

### AuthRepository

```dart
final authRepo = getIt<AuthRepository>();

// Login
final result = await authRepo.login(email, password);
result.fold(
  (failure) => showError(failure.message),
  (user) => navigateToDashboard(),
);

// Register
await authRepo.register(email, password, name);

// Logout
await authRepo.logout();

// Get current user
final user = await authRepo.getCurrentUser();
```

### FinanceRepository

```dart
final financeRepo = getIt<FinanceRepository>();

// Get transactions
final result = await financeRepo.getTransactions(
  userId: 'user123',
  monthYear: '2026-01',
);

// Add transaction
await financeRepo.addTransaction(transaction);

// Get summary
final summary = await financeRepo.getMonthlySummary(
  userId: 'user123',
  monthYear: '2026-01',
);
```

### ScheduleRepository

```dart
final scheduleRepo = getIt<ScheduleRepository>();

// Get schedules for week
final schedules = await scheduleRepo.getSchedulesByWeek(
  weekNumber: 1,
  year: 2026,
);

// Add schedule
await scheduleRepo.addSchedule(schedule);

// Update status
await scheduleRepo.updateStatus(scheduleId, ScheduleStatus.selesai);
```

---

## 🎨 UI Widgets

### Animation Widgets

```dart
import 'package:dormflow_mobile/widgets/common/common.dart';

// Scale button
ScaleButton(
  onPressed: () {},
  child: Text('Click me'),
)

// Animated list item
FadeSlideTransition(
  index: 0,
  child: ListTile(...),
)

// Loading
BouncingDotsLoading()

// Success
SuccessCheckmark(size: 80)

// Counter
AnimatedCounter(value: 1000000, prefix: 'Rp ')
```

### Feedback Widgets

```dart
// Snackbars
AppSnackBar.showSuccess(context, message: 'Saved!');
AppSnackBar.showError(context, message: 'Failed');

// Dialogs
await AppDialog.showConfirmation(context, title: '...', message: '...');
await AppDialog.showDeleteConfirmation(context);
AppDialog.showLoading(context);
AppDialog.hideLoading(context);
```

### Card Widgets

```dart
// Interactive card
InteractiveCard(
  onTap: () {},
  child: Content(),
)

// Stats card
StatsCard(
  title: 'Revenue',
  value: 5000000,
  prefix: 'Rp ',
  trend: 12.5,
)

// Expandable
ExpandableCard(
  title: 'Details',
  expandedContent: DetailView(),
)
```

---

## 🔧 Utilities

### FormValidators

```dart
import 'package:dormflow_mobile/core/validators/form_validators.dart';

TextFormField(
  validator: FormValidators.email,
)

TextFormField(
  validator: (v) => FormValidators.password(v, minLength: 8),
)

TextFormField(
  validator: (v) => FormValidators.required(v, fieldName: 'Name'),
)
```

### InputSanitizer

```dart
import 'package:dormflow_mobile/core/utils/input_sanitizer.dart';

final clean = InputSanitizer.sanitizeText(userInput);
final safeHtml = InputSanitizer.stripHtml(htmlString);
final safeName = InputSanitizer.sanitizeName(name);
```

---

## 🚀 Quick Start

```dart
// 1. Initialize DI
await configureDependencies();

// 2. Get repository
final authRepo = getIt<AuthRepository>();

// 3. Use it
final result = await authRepo.login(email, password);

// 4. Handle result
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Welcome ${user.name}!'),
);
```

---

*Documentation generated: January 2026*
