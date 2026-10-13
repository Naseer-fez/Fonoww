# Campus Buddy — Student Companion 🎓

**Campus Buddy** is a modern, polished mobile application built with **Flutter** and **Material 3**, designed as a college classroom demonstration project. It provides a real-world student productivity tool combining task management, class timetables, daily inspirational quotes, and personalized academic tracking.

---

## 📱 Features & Screenshots Overview

1. **Home Dashboard**
   - Personalized student greeting & live date.
   - Live REST API **"Quote of the Day"** card with offline fallback & manual refresh.
   - Dynamic **Assignment Progress Overview** with animated percentage bar.
   - Quick statistics cards: *Pending Tasks*, *Completed Tasks*, and *Today's Classes*.
   - Today's upcoming lecture timetable preview.
   - Nearest upcoming assignments with completion shortcuts.

2. **Assignments Screen**
   - Persistent SQLite storage for tasks (`sqflite`).
   - Smooth animated filter chips: **All**, **Pending**, **Completed**.
   - Interactive task cards with animated checkboxes and status badges (*Overdue*, *Due Today*, *Upcoming*, *Completed*).
   - Add new assignment with form validation, course dropdown, and date picker.
   - Delete assignment with confirmation alert dialog.
   - Attractive empty states for empty lists.

3. **Timetable Screen**
   - Interactive weekday strip (Monday through Sunday).
   - Schedule cards displaying subject name, course code, time slot, lecture room, and professor.
   - Friendly empty state for class-free days or weekends.

4. **Profile & Settings Screen**
   - Student info hero card with initials avatar (**SN** for Naseer).
   - Academic details (Student ID, Semester, Department, GPA, Attendance).
   - **Full-App Dark Mode Toggle** persisted via `shared_preferences`.
   - Notification reminders demo toggle persisted via `shared_preferences`.
   - "Reset Sample Data" tool to easily restore initial assignments during live classroom demos.

---

## 🎨 Visual Identity & Color Palette

- **Main Background**: `#F7F8FC` (Light) / `#13141F` (Dark)
- **Cards & Surfaces**: `#FFFFFF` (Light) / `#1E2030` (Dark)
- **Primary Accent**: `#7567E8` (Soft Indigo) / `#8F83F7` (Dark Mode Accent)
- **Text (Primary)**: `#22243A` (Dark Navy) / `#F1F3F9` (Light Cream)
- **Text (Secondary)**: `#85899B` (Muted Slate) / `#969AB0`
- **Pastel Accents**:
  - Success Mint: `#4EBA87`
  - Pale Lavender: `#EDE9FE`
  - Gentle Peach: `#FFB088`
  - Soft Coral (Overdue): `#FF6B6B`

---

## 📦 Packages Used

| Package | Version | Purpose |
|---|---|---|
| [`http`](https://pub.dev/packages/http) | `^1.2.1` | REST API communication with `https://dummyjson.com/quotes/random` |
| [`sqflite`](https://pub.dev/packages/sqflite) | `^2.3.3` | Persistent local SQLite database for assignment CRUD operations |
| [`path`](https://pub.dev/packages/path) | `^1.9.0` | Cross-platform filesystem path utility for database file location |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | `^2.2.3` | Key-value persistent storage for Dark Mode and notification toggles |
| [`intl`](https://pub.dev/packages/intl) | `^0.19.0` | Date formatting and calendar representation |

---

## 📚 Syllabus Concepts Demonstrated in Code

| Concept | Location in Codebase | What It Demonstrates |
|---|---|---|
| **Variables & Data Types** | `lib/models/assignment.dart`<br>`lib/models/class_session.dart` | `int`, `String`, `DateTime`, `bool`, `List`, `Map` |
| **Classes, Constructors & Models** | `lib/models/assignment.dart`<br>`lib/models/quote.dart` | Encapsulation, named constructors, factory constructors (`fromMap`, `fromJson`), `copyWith` |
| **Stateless vs StatefulWidget** | `lib/widgets/stat_card.dart` vs<br>`lib/widgets/quote_card.dart` | Knowing when local widget state is needed vs pure presentation |
| **State Management (`setState`)** | `lib/screens/main_navigation_shell.dart`<br>`lib/screens/assignments_screen.dart` | Clean, readable state updates without overengineered third-party frameworks |
| **Widget Composition** | `lib/screens/home_screen.dart` | Combining `Column`, `Row`, `Expanded`, `SingleChildScrollView`, custom cards |
| **Form Validation & Inputs** | `lib/screens/add_assignment_screen.dart` | `Form`, `GlobalKey<FormState>`, `TextFormField`, `DropdownButtonFormField`, custom validator functions |
| **Screen Navigation** | `lib/screens/main_navigation_shell.dart`<br>`lib/screens/add_assignment_screen.dart` | Persistent bottom navigation with `IndexedStack`, plus `Navigator.push` & `Navigator.pop` returning results |
| **Asynchronous Programming** | `lib/services/database_service.dart`<br>`lib/services/quote_service.dart` | `Future`, `async/await`, `try/catch/finally`, `timeout` |
| **REST API Integration** | `lib/services/quote_service.dart`<br>`lib/widgets/quote_card.dart` | HTTP GET, JSON parsing with `jsonDecode`, loading indicator, offline fallback quote |
| **SQLite CRUD Operations** | `lib/services/database_service.dart` | Database initialization, table creation, batch seeding, insert, read all, update, delete |
| **Key-Value Persistence** | `lib/services/preferences_service.dart` | Storing and retrieving theme and settings with `shared_preferences` |
| **Animations** | `lib/screens/home_screen.dart`<br>`lib/widgets/assignment_card.dart` | `TweenAnimationBuilder` for progress bar, `AnimatedContainer` for checkboxes & filter chips |

---

## 🚀 How to Run the Application

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version 3.0.0 or higher).
- Android Studio or VS Code with Flutter extension installed.
- An Android Emulator (via Android Studio) or a physical Android phone connected via USB debugging.

### Step 1: Install Dependencies
Open a terminal in the project root (`d:\Extras\ES\Timepass`) and run:
```bash
flutter pub get
```

### Step 2: Verify Setup & Code Analysis
```bash
flutter analyze
flutter test
```

### Step 3: Launch on Android Emulator or Physical Device
1. Start your Android Emulator or connect your physical Android device.
2. Verify your device is recognized:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run
   ```

To run specifically in release or profile mode:
```bash
flutter run --release
```

---

## ⚙️ Android Network Configuration & Permissions

Network permissions are already configured in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```
This enables the app to fetch the Quote of the Day from `https://dummyjson.com/quotes/random`.

If your device is offline or the API server is unreachable, the app automatically switches to the built-in offline motivational quote fallback without freezing or crashing.

---

## 📂 Project Directory Structure

```text
lib/
├── main.dart                      # App entry point, portrait lock & theme initialization
├── models/
│   ├── assignment.dart            # Assignment entity & SQLite serialization
│   ├── class_session.dart         # College schedule model & static weekly data
│   └── quote.dart                 # Quote API entity & offline fallback
├── services/
│   ├── database_service.dart      # SQLite database singleton & CRUD methods
│   ├── preferences_service.dart   # SharedPreferences manager for theme & settings
│   └── quote_service.dart         # HTTP service with in-memory caching
├── theme/
│   └── app_theme.dart             # Material 3 light & dark theme definitions
├── widgets/
│   ├── app_bottom_navigation.dart # Modern 4-tab bottom navigation bar
│   ├── assignment_card.dart       # Task card with animated checkbox & status badge
│   ├── empty_state_widget.dart    # Clean placeholder for empty states
│   ├── quote_card.dart            # REST API quote card with refresh button
│   └── stat_card.dart             # Metric badge card for dashboard
└── screens/
    ├── main_navigation_shell.dart # Tab coordinator & state manager
    ├── home_screen.dart           # Screen 1: Home Dashboard & metrics
    ├── assignments_screen.dart    # Screen 2: Task list & filter chips
    ├── add_assignment_screen.dart # Form screen with validation & date picker
    ├── timetable_screen.dart      # Screen 3: Weekly schedule & day selectors
    └── profile_screen.dart        # Screen 4: Student credentials & settings
```
