# Changelog

All notable changes to DormFlow Mobile will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-03

### Added

#### UI/UX Components
- **Animation Widgets** (`lib/widgets/common/animation_widgets.dart`)
  - `ScaleButton` - Press effect with 0.95 scale
  - `FadeSlideTransition` - Staggered list item animation
  - `PulseAnimation` - Infinite pulse for badges
  - `BouncingDotsLoading` - Modern loading indicator
  - `SkeletonCard`, `SkeletonListTile`, `SkeletonCircle`, `SkeletonLine`
  - `SuccessCheckmark` - Animated success indicator
  - `AnimatedCounter` - Counting number animation
  - `RotatingRefreshIcon` - Spinning refresh button

- **Card Widgets** (`lib/widgets/common/card_widgets.dart`)
  - `InteractiveCard` - Hover/tap elevation effects
  - `SlidableCard` - Swipe actions (edit/delete)
  - `ExpandableCard` - Collapsible content
  - `GradientBorderCard` - Animated gradient border
  - `StatsCard` - Statistics display with trend

- **Feedback Widgets** (`lib/widgets/common/feedback_widgets.dart`)
  - `AppSnackBar` - Styled snackbars (success/error/warning/info)
  - `AppDialog` - Confirmation, loading, success, error dialogs
  - `NotificationBanner` - In-app notification banners

#### Security Features
- `SecureStorageService` - Encrypted storage with Keychain/EncryptedPrefs
- `AdvancedRateLimiter` - Sliding window with progressive lockout
- `SecurityService` - Hashing, HMAC, JWT utilities, XSS sanitization
- `SessionManager` - Session expiry and inactivity tracking

#### Architecture
- Clean Architecture folder structure (`core/`, `data/`, `domain/`)
- Freezed data models with code generation
- Repository pattern with interfaces
- Dependency injection with GetIt

#### Code Quality
- Form validators and input sanitizers
- Rate limiting utilities
- Network connectivity checker
- 155+ unit and widget tests

### Changed

- **Design System** - Complete redesign with new color palette
  - Primary: Indigo (#4F46E5)
  - Secondary: Teal (#14B8A6)
  - 10-shade neutral scale
  - Semantic colors (success, warning, error, info)

- **Typography** - Switched to Inter font with 10 text style tokens

- **Spacing** - Token-based spacing system (xs, sm, md, lg, xl)

- **Theme** - Added full dark mode support

### Fixed

- Type casting errors across screens and services
- Import ordering issues
- 225 linting issues resolved (0 remaining)

## [0.1.0] - 2025-12-22

### Added
- Initial project setup
- Basic authentication with Firebase
- Dashboard, Finance, Attendance, Schedule, Profile screens
- Firebase Firestore integration

---

[1.0.0]: https://github.com/user/dormflow-mobile/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/user/dormflow-mobile/releases/tag/v0.1.0
