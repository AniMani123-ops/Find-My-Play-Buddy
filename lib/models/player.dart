class Player {
  final String id;
  final String name;
  final String area;
  final String sport;
  final String skill;
  final String availability;
  final String? contactInfo;
  final double? distanceKm;

  const Player({
    required this.id,
    required this.name,
    required this.area,
    required this.sport,
    required this.skill,
    required this.availability,
    this.contactInfo,
    this.distanceKm,
  });

  // Convert to Firestore map
  Map<String, dynamic> toMap() => {
        'name': name,
        'area': area,
        'sport': sport,
        'skill': skill,
        'availability': availability,
        'contactInfo': contactInfo ?? '',
      };

  // Create from Firestore snapshot
  factory Player.fromMap(String id, Map<String, dynamic> map) => Player(
        id: id,
        name: map['name'] ?? '',
        area: map['area'] ?? '',
        sport: map['sport'] ?? '',
        skill: map['skill'] ?? '',
        availability: map['availability'] ?? '',
        contactInfo: map['contactInfo'],
      );

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
