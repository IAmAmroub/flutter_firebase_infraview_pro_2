# InfraView Pro 2.0

InfraView Pro 2.0 is a Flutter application designed for infrastructure asset monitoring and field operations.

The project demonstrates Firebase Authentication, real-time Cloud Firestore data, GPS location services, Google Maps integration, camera and gallery access, and biometric authentication.

The application was developed incrementally across multiple phases.

---

## Features

### Phase 1 — Firebase Integration

- Firebase initialization
- Email/password authentication
- User sign-up
- User sign-in
- User sign-out
- Firebase authentication state handling
- Firestore user profiles
- Real-time infrastructure asset data
- `StreamBuilder` for live Firestore updates
- Loading, empty, and error states
- Separation between models, services, and screens

### Phase 2 — Device Integration

- Current GPS location
- Runtime location permission handling
- Google Maps integration
- Current technician location on the map
- Firestore asset markers
- Real-time marker updates
- Work Log screen
- Camera image capture
- Gallery image selection
- Local image preview
- Face ID / fingerprint authentication
- Biometric quick access for returning users
- Session-aware biometric authentication

---

## Authentication

The application uses Firebase Authentication with the Email/Password provider.

### Authentication Flow

```text
App
 ↓
Firebase Authentication State
 ↓
Is user authenticated?
 ├── No  → AuthScreen
 │          ↓
 │     Sign Up / Sign In
 │          ↓
 │     Firebase Authentication
 │
 └── Yes → AuthGate
            ↓
       Session Check
            ↓
       ┌────┴─────┐
       │          │
 Fresh Login   Returning User
       │          │
       ↓          ↓
 HomeScreen   BiometricGate
                  ↓
           Face ID/Fingerprint
                  ↓
              HomeScreen
```

A fresh email/password authentication allows the user to enter the application directly.

When an authenticated user returns to the application later, biometric authentication can be used as a quick-access security layer.

Signing out ends the Firebase session and requires email/password authentication again.

---

## Firebase Authentication State

The application listens to:

```dart
FirebaseAuth.instance.authStateChanges()
```

This allows the UI to automatically respond when the user signs in or signs out.

```text
Signed Out
    ↓
AuthScreen

Signed In
    ↓
AuthGate
```

---

## Firestore User Profiles

When a new Firebase account is created, the application creates a matching user profile in Cloud Firestore.

The document path follows:

```text
users/<Firebase UID>
```

Example:

```text
users
└── FirebaseUserUid
    ├── uid
    ├── name
    ├── email
    └── createdAt
```

Using the Firebase Authentication UID associates the Firestore profile with the authenticated user.

---

## Infrastructure Assets

Infrastructure asset data is stored in the Firestore collection:

```text
assets
```

Each asset contains information such as:

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

The application converts Firestore documents into `AssetModel` objects.

---

## Real-Time Firestore Data

The application listens to infrastructure assets using a Firestore snapshot stream:

```dart
FirebaseFirestore.instance
    .collection('assets')
    .snapshots()
```

The data flow is:

```text
Cloud Firestore
      ↓
assets collection
      ↓
snapshots()
      ↓
Stream<List<AssetModel>>
      ↓
Flutter UI
```

Changes made to Firestore are automatically reflected in the application without requiring a manual refresh.

---

## Location Services

Phase 2 introduces device geolocation using the `geolocator` package.

The application checks:

1. Whether location services are enabled.
2. Whether location permission has already been granted.
3. Whether permission needs to be requested.
4. Whether permission was denied.
5. Whether permission was permanently denied.

The location flow is:

```text
HomeScreen
    ↓
LocationService
    ↓
Check location services
    ↓
Check permission
    ↓
Request permission if needed
    ↓
Geolocator
    ↓
Position
    ↓
Latitude / Longitude
    ↓
Google Map
```

The technician's current GPS coordinates are used to initialize the map.

---

## Google Maps

The application uses `google_maps_flutter` to display infrastructure assets geographically.

The map displays:

- Technician's current location
- Current-location button
- Infrastructure asset markers
- Asset location
- Asset status

The map is initially centered on the technician's GPS position.

### Asset Marker Flow

```text
Cloud Firestore
      ↓
assets snapshots()
      ↓
List<AssetModel>
      ↓
latitude + longitude
      ↓
Set<Marker>
      ↓
GoogleMap
```

Because the markers are created from a Firestore stream, changes to asset information are reflected on the map in real time.

---

## Google Maps API Configuration

Google Maps requires an API key.

For Android, configure the API key inside:

```text
android/app/src/main/AndroidManifest.xml
```

Inside the `<application>` element:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

---

## Work Log

Phase 2 introduces a Work Log screen for field technicians.

The technician can:

- Take a new photo using the camera
- Select an existing photo from the gallery
- Preview the selected image inside the application

The image flow is:

```text
WorkLogScreen
      ↓
Add Photo
      ↓
┌─────────────────────┐
│ Camera              │
│ Photo Gallery       │
└─────────────────────┘
      ↓
ImagePicker
      ↓
XFile
      ↓
Image Preview
```

The selected image is currently handled locally.

Uploading work-log images to remote storage is outside the current project scope.

---

## Biometric Authentication

The application uses `local_auth` to provide biometric quick access.

Depending on the device, this can include:

- Face ID
- Fingerprint authentication

The biometric flow is:

```text
Returning User
      ↓
Firebase session exists
      ↓
AuthGate
      ↓
BiometricGateScreen
      ↓
Face ID / Fingerprint
      ↓
Authentication successful
      ↓
HomeScreen
```

A signed-out user cannot use biometric authentication to bypass Firebase Authentication.

---

## Session Management

`shared_preferences` is used to distinguish a fresh email/password login from a returning authenticated session.

After a successful fresh login:

```text
Email + Password
      ↓
Firebase Authentication
      ↓
Skip biometric once
      ↓
HomeScreen
```

When the application is opened again:

```text
Existing Firebase Session
      ↓
No biometric skip
      ↓
Biometric Authentication
      ↓
HomeScreen
```

Signing out clears the temporary session state.

---

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   └── asset_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── location_service.dart
│   ├── biometric_service.dart
│   └── session_service.dart
│
└── screens/
    ├── auth_screen.dart
    ├── auth_gate.dart
    ├── biometric_gate_screen.dart
    ├── home_screen.dart
    └── work_log_screen.dart
```

---

## Main Dependencies

The project uses the following Flutter packages:

```text
firebase_core
firebase_auth
cloud_firestore
google_maps_flutter
geolocator
image_picker
local_auth
shared_preferences
```

See `pubspec.yaml` for the exact versions installed in the project.

---

## Platform Configuration

### Android

Location permissions are configured in:

```text
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission
    android:name="android.permission.ACCESS_FINE_LOCATION" />

<uses-permission
    android:name="android.permission.ACCESS_COARSE_LOCATION" />

<uses-permission
    android:name="android.permission.USE_BIOMETRIC" />
```

The Google Maps API key is configured inside the `<application>` element:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

For biometric authentication, `MainActivity` uses:

```kotlin
FlutterFragmentActivity
```

instead of:

```kotlin
FlutterActivity
```

### iOS

The application defines usage descriptions in:

```text
ios/Runner/Info.plist
```

for:

- Location access
- Camera access
- Photo library access
- Face ID

Example:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>
    InfraView Pro uses your location to display your current position
    and nearby assets.
</string>

<key>NSCameraUsageDescription</key>
<string>
    InfraView Pro uses the camera to document asset maintenance work.
</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>
    InfraView Pro uses the photo library to attach asset documentation.
</string>

<key>NSFaceIDUsageDescription</key>
<string>
    InfraView Pro uses Face ID for secure quick access.
</string>
```

---

## Firebase Configuration

The project requires a Firebase project configured with:

- Firebase Authentication
- Email/Password authentication provider
- Cloud Firestore

FlutterFire configuration generates:

```text
lib/firebase_options.dart
```

Firebase is initialized before starting the Flutter application:

```dart
WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/infraview-pro-2.git
```

Enter the project:

```bash
cd infraview-pro-2
```

Install dependencies:

```bash
flutter pub get
```

Check the Flutter environment:

```bash
flutter doctor
```

Run static analysis:

```bash
flutter analyze
```

Run the application:

```bash
flutter run
```

A real device is recommended for testing:

- GPS
- Camera
- Gallery
- Face ID / fingerprint

---

## Testing the Application

### Authentication

Test:

```text
Sign Up
→ Firestore user profile created
→ Sign Out
→ Sign In
```

### Firestore

Test:

```text
Open HomeScreen
→ Change an asset in Firebase Console
→ Verify the application updates automatically
```

### Location

Test:

```text
Allow location permission
→ Verify current GPS location
→ Verify map centers on current position
```

### Google Maps

Test:

```text
Open HomeScreen
→ Verify map loads
→ Verify current-location indicator
→ Verify Firestore asset markers
→ Tap asset marker
```

### Work Log

Test:

```text
Open Work Log
→ Take Photo
→ Verify preview

Open Work Log
→ Choose from Gallery
→ Verify preview
```

### Biometrics

Test:

```text
Sign in with email/password
→ HomeScreen

Close and reopen application
→ Face ID / fingerprint requested
→ Authenticate
→ HomeScreen

Sign out
→ AuthScreen
```

---

## Code Quality

Format the Dart source code:

```bash
dart format lib
```

Run static analysis:

```bash
flutter analyze
```

Before committing changes:

```bash
git status
```

---

## Git Workflow

The project follows a GitFlow-style workflow.

```text
main
  ↓
develop
  ↓
feature/*
```

Phase 2 development is performed on:

```text
feature/device-integration
```

The general workflow is:

```text
feature/*
    ↓
develop
    ↓
main
```

Example:

```bash
git switch develop
git pull origin develop

git switch -c feature/device-integration

# Development...

git add .
git commit -m "Add Phase 2 device integration"
git push -u origin feature/device-integration

git switch develop
git merge --no-ff feature/device-integration
git push origin develop

git switch main
git merge --no-ff develop
git push origin main
```

---

## Technologies

- Flutter
- Dart
- Firebase
- Firebase Authentication
- Cloud Firestore
- FlutterFire
- Google Maps
- Geolocator
- Image Picker
- Local Authentication
- Shared Preferences
- Git
- GitHub

---

## Current Scope

InfraView Pro 2.0 currently demonstrates a field-oriented infrastructure monitoring workflow using Firebase and native device capabilities.

The current implementation supports authentication, real-time infrastructure data, asset visualization on Google Maps, technician geolocation, local work-log image capture/selection, and biometric quick access.

Future versions could extend the project with features such as:

- Firebase Storage for work-log images
- Asset creation and editing
- Work-log persistence in Firestore
- Asset search and filtering
- Marker status customization
- Push notifications
- Offline data support
- Role-based access control
