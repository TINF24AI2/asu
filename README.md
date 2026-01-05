# 📱 ASU - Atemschutzüberwachung
ASU is a mobile application for monitoring respiratory protection  during firefighting operations. The app was developed as a graded course project for the module **Entwicklung mobiler Applikationen** (Mobile Application Development) at **DHBW Mannheim** in winter semester 2025/2026.

## 🎯 Application Purpose
ASU offers digital support for firefighters respiratory protection monitoring and enables real-time monitoring of:
- **Trupp** information and status
- **Firefighter** management
- **Location** tracking during operations
- **Pressure** monitoring
- **Radio call numbers**
- **Operation history**

The application replaces traditional paper-based monitoring systems with a modern, Firebase-backed mobile solution.

## ✨ Features
### 👤 Authentication
- User registration and login
- Firebase Authentication integration
- Secure session management

### 🚒 Trupp Management
- Create and manage firefighter trupps
- Track trupp status and location
- Monitor air pressure levels

### 📋 Settings & Configuration
- Manage firefighter personnel list
   - QR code scanner for quick data entry
- Configure locations
- Setup radio call numbers
- Define operation statuses

### 📊 Operation Tracking
- Start and end operations
- Record operation history
- View historical data
- Export operations as PDF reports

### 🔔 Alarms & Notifications
- Pressure check reminder: Audio alarm when scheduled pressure check is overdue
- Low pressure alert: Critical alarm when air pressure drops below 60 bar
- Visual and audio notifications for all alarm types

## 🛠️ Technologies Used
| Technology            | Description                                 |
| --------------------- | ------------------------------------------- |
| **Flutter**           | Cross-platform mobile development framework |
| **Dart**              | Programming language                        |
| **Firebase Core**     | Firebase SDK integration                    |
| **Firebase Auth**     | Authentication service                      |
| **Cloud Firestore**   | NoSQL cloud database                        |
| **Riverpod**          | State management solution                   |
| **Go Router**         | Declarative routing                         |
| **Freezed**           | Code generation for immutable classes       |

## 📁 Project Structure
```
asu/
├── android/                                    # Android-specific configuration
├── assets/                                     # Static resources (icons, images, sounds)
├── lib/
│   ├── audioplayers
│   │   └── sound_service.dart
│   ├── firebase/                               # Firebase configuration and services
│   │   ├── firebase_auth_provider.dart
│   │   ├── firebase_auth_service.dart
│   │   ├── firestore_provider.dart
│   │   └── firestore_service.dart
│   ├── model/                                  # Data models
│   │   ├── einsatz/                            # Operation data models
│   │   │   ├── einsatz.dart
│   │   │   ├── einsatz.freezed.dart
│   │   │   └── einsatz.g.dart
│   │   ├── history/                            # History data models
│   │   │   ├── history.dart
│   │   │   └── history.freezed.dart
│   │   ├── settings/                           # Configuration and settings models
│   │   │   ├── firefighter.dart
│   │   │   ├── initial_settings.dart
│   │   │   ├── location.dart
│   │   │   ├── radio_call.dart
│   │   │   ├── setting_item.dart
│   │   │   └── status.dart
│   │   └── trupp/                              # Trupp data models
│   │       ├── trupp.dart
│   │       └── trupp.freezed.dart
│   ├── repositories/                           # Data Layer
│   │   ├── firefighters_repository.dart
│   │   ├── initial_settings_repository.dart
│   │   ├── locations_repository.dart
│   │   ├── radio_call_repository.dart
│   │   └── status_repository.dart
│   ├── router/                                 # Navigation routing
│   │   ├── router.dart
│   │   └── router.g.dart
│   ├── services/                               # Services
│   │   └── pdf_export_service.dart
│   ├── ui/                                     # User Interface Layer
│   │   ├── auth/                               # Authentication Screens
│   │   │   ├── auth.dart
│   │   │   ├── login.dart
│   │   │   ├── post_register.dart
│   │   │   ├── register.dart
│   │   │   └── scaffold.dart
│   │   ├── core/                               # Core UI components
│   │   │   ├── about_dialog.dart
│   │   │   ├── add_location.dart
│   │   │   ├── add_person.dart
│   │   │   ├── add_radio_call_number.dart
│   │   │   ├── add_status.dart
│   │   │   ├── add_time.dart
│   │   │   ├── core.dart
│   │   │   ├── modal_choice_sheet.dart
│   │   │   ├── person_selector.dart
│   │   │   ├── qr_scanner.dart
│   │   │   ├── scaffold.dart
│   │   │   └── widget_new_trupp.dart
│   │   ├── einsatz/                            # Operation screens
│   │   │   ├── einsatz_screen.dart
│   │   │   └── horizontal_trupp_view.dart
│   │   ├── end_einsatz/                        # End operation screens
│   │   │   ├── einsatz_completed_screen.dart
│   │   │   ├── end_einsatz_screen.dart
│   │   │   └── pdf_preview_screen.dart
│   │   ├── settings/                           # Settings screens
│   │   │   ├── initial_settings_form.dart
│   │   │   ├── settings_list_editor.dart
│   │   │   └── settings.dart
│   │   ├── trupp/                              # Trupp management screens
│   │   │   ├── alarm_view.dart
│   │   │   ├── end_handler.dart
│   │   │   ├── end.dart
│   │   │   ├── location.dart
│   │   │   ├── pressure_selector.dart
│   │   │   ├── pressure.dart
│   │   │   ├── report_handler.dart
│   │   │   ├── report.dart
│   │   │   ├── status.dart
│   │   │   └── trupp.dart
│   │   └── app.dart
│   ├── firebase_options.dart
│   ├── main.dart                               # Application entry point
│   └── pubspec.g.dart
├── analysis_options.yaml                       # Dart analyzer configuration
├── firebase.json                               # Firebase project configuration
├── firestore.rules                             # Firestore security rules
├── pubspec.lock                                # Locked versions of all dependencies
├── pubspec.yaml                                # Dependencies and project metadata
└── README.md                                   # Project documentation
```

## 📲 How to Run the App
### Prerequisites
Ensure the following tools are already installed and fully functional:
- **Flutter SDK** (version 3.35.0 or higher)
- **Dart SDK** (version 3.9.2 or higher)
- **Android Studio or Visual Studio Code with Flutter extensions**
- **Android tablet emulator or physical Android tablet device**
  - **Android API Level**: Target SDK 35 (used in test environment), Minimum SDK 33
  > **Note**: This app is optimized for tablets and should be used in landscape mode. For the best experience, use a tablet emulator (e.g., Pixel Tablet) or run the app on a physical tablet device.

### Installation Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/TINF24AI2/asu.git
   cd asu
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get --enforce-lockfile
   ```

3. **Generate code (optional, if generated files are missing):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   > **Note:** This step regenerates Freezed, Riverpod, and Go Router files. Skip if all `.g.dart` and `.freezed.dart` files are already present and up-to-date.

4. **Run the application:**
   ```bash
   flutter run
   ```

##  🚀 Outlook
The following features would exceed the time constraints of a theory semester project but would be considered for future development.
- **Account management**: User account deletion and password change functionality
- **Log tracking**: Enhanced protocol tracking for operation logs
- **Firebase resilience**: Deploy operation status via Firebase to survive device failures

## 📄 License
This project is submitted as an academic assignment for DHBW Mannheim.
