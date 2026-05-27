# 🏸 Find My Play Buddy

A Flutter MVP app to help people in Bangalore find sports partners nearby.

## Features
- **Profile setup** — name, area, sport, skill level, availability
- **Discover players** — filter by sport and availability
- **Connect** — send a pre-written intro message (no chat system needed)
- **Venues** — static list of popular Bangalore sports venues
- **Profile screen** — view and edit your details

---

## Project Structure

```
lib/
├── main.dart                  # App entry, bottom nav
├── theme.dart                 # Colors, text styles, theme
├── models/
│   ├── player.dart            # Player data model
│   └── venue.dart             # Venue data model
├── data/
│   ├── constants.dart         # Sports, areas, venues, dummy players
│   └── firebase_service.dart  # Firebase/Firestore (commented, ready to enable)
├── screens/
│   ├── setup_screen.dart      # Onboarding / profile creation
│   ├── discover_screen.dart   # Find players + connect bottom sheet
│   ├── venues_screen.dart     # Nearby venues list
│   └── profile_screen.dart    # My profile
└── widgets/
    └── common_widgets.dart    # Reusable: chips, tags, avatars, cards
```

---

## Getting Started

### 1. Install Flutter
https://docs.flutter.dev/get-started/install

### 2. Get dependencies
```bash
flutter pub get
```

### 3. Run (without Firebase — uses dummy data)
```bash
flutter run
```

The app works out of the box with 10 preloaded dummy players.

---

## Week 2: Connect Firebase

### Step 1: Create a Firebase project
1. Go to https://console.firebase.google.com
2. Create a project → Add an Android/iOS app
3. Enable **Firestore Database** in test mode

### Step 2: Add FlutterFire
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This generates `lib/firebase_options.dart` automatically.

### Step 3: Update main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FindMyPlayBuddyApp());
}
```

### Step 4: Enable FirebaseService
Uncomment the code in `lib/data/firebase_service.dart` and use it in
`discover_screen.dart` to replace dummy data with live Firestore queries.

---

## Firestore Data Model

```
users (collection)
  └── {userId} (document)
        name: "Mani"
        area: "Koramangala"
        sport: "Badminton"
        skill: "Intermediate"
        availability: "Weekend"
        contactInfo: ""

        requests (sub-collection)
          └── {requestId}
                fromUserId: "..."
                message: "Hey! Want to play this weekend?"
                timestamp: ...
                status: "pending"
```

### Simple filter query (no algorithm needed)
```dart
firestore
  .collection('users')
  .where('area', isEqualTo: userArea)
  .where('sport', isEqualTo: selectedSport)
  .get()
```

---

## Demo Tips
- Preloaded with **10 dummy players** across Bangalore areas
- Filter chips on Discover screen let you filter by sport and day
- Tap any player → bottom sheet → pick a pre-written message → "Sent ✓"

---

## 2-Week Plan

**Week 1 ✅**
- [x] Profile creation (name, area, sport, skill, availability)
- [x] Store in local state (swap for Firestore in Week 2)
- [x] UI screens and navigation

**Week 2**
- [ ] Connect Firebase + Firestore
- [ ] Replace dummy players with real DB queries
- [ ] Connect request sub-collection
- [ ] UI polish
