# InfraView Pro 2.0

InfraView Pro 2 is a Flutter application that demonstrates Firebase Authentication and real-time Cloud Firestore data handling.

## Features

- Firebase initialization
- Email/password authentication
- User sign-up
- User sign-in
- Sign-out
- Firebase authentication state handling
- Firestore user profiles
- Real-time infrastructure asset data
- StreamBuilder
- Loading, empty, and error states
- Clean separation between models, services, and screens

## Firebase Authentication

The application uses Firebase Authentication with the Email/Password provider.

The authentication flow is:

```text
AuthScreen
   ↓
Sign Up / Sign In
   ↓
Firebase Authentication
   ↓
authStateChanges()
   ↓
HomeScreen
```

When the user signs out, the authentication state changes and the app automatically returns to the authentication screen.

## Firestore User Profiles

When a new account is created, the application creates a matching document in:

```text
users/<Firebase UID>
```

Example fields:

```text
uid
name
email
createdAt
```

## Infrastructure Assets

Asset data is stored in the Firestore collection:

```text
assets
```

Each asset contains:

```text
id
location
latitude
longitude
status
```

Example:

```text
id: A001
location: Rabat Center
latitude: 34.0209
longitude: -6.8416
status: Active
```

## Real-Time Data

The application listens to Firestore using:

```dart
FirebaseFirestore.instance
    .collection('assets')
    .snapshots()
```

The stream is displayed using `StreamBuilder`.

```text
Firestore
    ↓
snapshots()
    ↓
StreamBuilder
    ↓
ListView
```

When an asset changes in Firestore, the UI updates automatically.

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   └── asset_model.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── screenshots/
│   ├── ....png
└── screens/
    ├── auth_screen.dart
    └── home_screen.dart
```

## Dependencies

Important packages include:

```text
firebase_core
firebase_auth
cloud_firestore
```

See `pubspec.yaml` for the exact versions.

## Run the Project

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## Code Quality

Format:

```bash
dart format lib
```

Analyze:

```bash
flutter analyze
```

## Git Workflow

The project uses a GitFlow-style workflow:

```text
feature/* -> develop -> main
```

Examples:

```text
feature/user-auth
feature/firestore-assets
```

## Technologies

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Git
- GitHub
