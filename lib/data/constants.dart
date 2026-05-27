import 'dart:math'; // Added for randomization
import '../models/venue.dart';

class AppConstants {
  static const List<String> areas = [
    'Indiranagar', 'Koramangala', 'Whitefield', 'HSR Layout',
    'Jayanagar', 'Marathahalli', 'BTM Layout', 'Rajajinagar', 'Malleshwaram',
  ];

  static const List<Map<String, String>> sports = [
    {'label': 'Badminton', 'emoji': '🏸'},
    {'label': 'Football', 'emoji': '⚽'},
    {'label': 'Cricket', 'emoji': '🏏'},
    {'label': 'Chess', 'emoji': '♟️'},
    {'label': 'Swimming', 'emoji': '🏊'},
    {'label': 'Running', 'emoji': '🏃'},
    {'label': 'Basketball', 'emoji': '🏀'},
    {'label': 'Tennis', 'emoji': '🎾'},
  ];

  static const List<String> skillLevels = ['Beginner', 'Intermediate', 'Advanced'];
  static const List<String> availabilities = ['Weekdays', 'Weekends', 'Both'];

  // Keep venues static as they are specific locations
  static final List<Venue> venues = const [
    Venue(name: 'Play Arena', area: 'Koramangala', hours: 'Daily 6am–10pm', sports: ['Badminton', 'Squash'], emoji: '🏸'),
    Venue(name: 'Kanteerava Indoor Stadium', area: 'Cubbon Park', hours: 'Mon–Sat 7am–9pm', sports: ['Badminton', 'Basketball'], emoji: '🏟️'),
    Venue(name: 'Bangalore Football Ground', area: 'HSR Layout', hours: 'Weekends 5am–8pm', sports: ['Football', 'Cricket'], emoji: '⚽'),
    Venue(name: 'BBMP Swimming Pool', area: 'Jayanagar', hours: 'Daily 6am–8am, 4pm–7pm', sports: ['Swimming'], emoji: '🏊'),
    Venue(name: 'Cubbon Park Running Track', area: 'Cubbon Park', hours: 'Open daily, free', sports: ['Running', 'Walking'], emoji: '🏃'),
    Venue(name: 'Decathlon Sports Centre', area: 'Marathahalli', hours: 'Daily 9am–9pm', sports: ['Badminton', 'Football', 'Basketball'], emoji: '🏅'),
  ];

  // Logic to generate 1728 players with randomized sports distribution
  static final List<Map<String, dynamic>> dummyPlayers = _generateRandomPlayers(1728);

  static List<Map<String, dynamic>> _generateRandomPlayers(int count) {
    final Random random = Random();
    final List<Map<String, dynamic>> players = [];
    
    final List<String> playerNames = [
      'Pavithra', 'Swathi', 'Sumanth', 'Indira', 'Vikram', 'Bhavana', 'Lalitha', 
      'Bindhu', 'Ashwini', 'Arjun', 'Usha', 'Uma', 'Ramesh', 'Vinod', 'Saroja'
    ];

    for (int i = 1; i <= count; i++) {
      // Pick a random sport label from the sports list
      String randomSport = sports[random.nextInt(sports.length)]['label']!;
      
      players.add({
        'id': 'p$i',
        'name': '${playerNames[random.nextInt(playerNames.length)]} ${String.fromCharCode(65 + random.nextInt(26))}.',
        'area': areas[random.nextInt(areas.length)],
        'sport': randomSport, // This makes the distribution random
        'skill': skillLevels[random.nextInt(skillLevels.length)],
        'availability': availabilities[random.nextInt(availabilities.length)],
        'distanceKm': (random.nextDouble() * 8).toPrecision(1),
      });
    }
    return players;
  }
}

// Extension to help with distance formatting
extension DoubleExtension on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}