# 📋 Testing Documentation

Folder ini berisi dokumentasi pengujian untuk aplikasi DormFlow Mobile.

## 📁 Struktur

```
testing/
├── README.md                  # Dokumen ini
├── usability-testing.md       # Laporan Usability Testing
└── integration-testing.md     # Laporan Integration Testing

integration_test/
├── app_test.dart              # Main integration test (14 tests)
└── robots/
    └── app_robot.dart         # Test helper dengan Page Object Model

test_driver/
└── integration_test.dart      # Test driver
```

## 📊 Test Summary

| Type | Tests | Status |
|------|-------|--------|
| Unit Tests | 160 | ✅ Passed |
| Integration Tests | 14 | Ready to run |
| Usability Tests | 8 | ✅ Documented |

## 🚀 Menjalankan Test

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
# Via flutter test
flutter test integration_test/app_test.dart

# Via flutter drive
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

### VS Code
1. Buka **Run and Debug** (Ctrl+Shift+D)
2. Pilih "Integration Tests" dari dropdown
3. Klik ▶️ Run

## 📄 Dokumen Testing

- [Usability Testing](./usability-testing.md) - 8 test cases
- [Integration Testing](./integration-testing.md) - 7 test scenarios

---

*DormFlow Mobile Testing Suite - Januari 2026*
