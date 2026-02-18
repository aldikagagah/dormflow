# Contributing to DormFlow Mobile

Terima kasih telah tertarik untuk berkontribusi pada DormFlow Mobile! 🎉

## 📋 Daftar Isi

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Testing](#testing)
- [Pull Request](#pull-request)

---

## Code of Conduct

Proyek ini mengikuti standar perilaku profesional. Harap:
- Bersikap hormat dan inklusif
- Menerima kritik konstruktif dengan baik
- Fokus pada apa yang terbaik untuk proyek

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase CLI (untuk konfigurasi)

### Setup

1. **Clone repository**
   ```bash
   git clone https://github.com/username/dormflow-mobile.git
   cd dormflow-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Firebase**
   - Letakkan `google-services.json` di `android/app/`
   - Letakkan `GoogleService-Info.plist` di `ios/Runner/`

5. **Run the app**
   ```bash
   flutter run
   ```

## Development Workflow

### Branch Naming

- `feature/nama-fitur` - Fitur baru
- `bugfix/deskripsi-bug` - Perbaikan bug
- `hotfix/deskripsi` - Perbaikan urgent
- `docs/deskripsi` - Dokumentasi

### Commit Messages

Gunakan format [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat` - Fitur baru
- `fix` - Perbaikan bug
- `docs` - Dokumentasi
- `style` - Formatting (tidak mengubah kode)
- `refactor` - Refactoring kode
- `test` - Menambah/memperbaiki test
- `chore` - Maintenance

**Contoh:**
```
feat(finance): add transaction filtering by category

- Added dropdown filter on finance screen
- Implemented filter logic in repository
```

## Code Style

### Dart/Flutter Guidelines

- Gunakan `flutter analyze` sebelum commit
- Maksimal 0 errors dan 0 warnings
- Ikuti [Effective Dart](https://dart.dev/guides/language/effective-dart)

### Formatting

```bash
dart format lib/ test/
```

### Import Ordering

1. Dart imports
2. Flutter imports
3. Package imports
4. Project imports

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dormflow_mobile/core/core.dart';
```

### File Structure

```
lib/
├── core/           # Core utilities, DI, validators
├── data/           # Models, repository implementations
├── domain/         # Repository interfaces
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Business logic services
├── theme/          # App theming
└── widgets/        # Reusable widgets
```

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/validators/form_validators_test.dart
```

### Test Structure

```
test/
├── core/           # Core unit tests
├── helpers/        # Test helpers & mocks
├── widgets/        # Widget tests
└── widget_test.dart
```

### Writing Tests

- Satu test file per file yang ditest
- Gunakan `group()` untuk mengelompokkan related tests
- Naming: `should [expected behavior] when [condition]`

```dart
group('FormValidators', () {
  group('email', () {
    test('should return null for valid email', () {
      expect(FormValidators.email('test@email.com'), isNull);
    });
  });
});
```

## Pull Request

### Before Submitting

- [ ] Run `flutter analyze` - 0 issues
- [ ] Run `flutter test` - All passing
- [ ] Run `dart format lib/ test/` - Formatted
- [ ] Update documentation if needed
- [ ] Add tests for new features

### PR Template

```markdown
## Description
[Deskripsi perubahan]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests added/updated
- [ ] All tests passing

## Screenshots (if applicable)
[Tambahkan screenshot]
```

### Review Process

1. Create PR dengan deskripsi lengkap
2. Request review dari maintainer
3. Address feedback yang diberikan
4. Squash commits jika diminta
5. Merge setelah approval

---

## 📞 Contact

Jika ada pertanyaan, silakan buka [Issue](https://github.com/username/dormflow-mobile/issues) baru.

---

*Terima kasih sudah berkontribusi! 🙏*
