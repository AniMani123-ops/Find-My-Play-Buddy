// firebase_service.dart
// ─────────────────────────────────────────────────────────────
// Uncomment and use this file once you add Firebase to your project.
// Run: flutterfire configure  (installs firebase_options.dart)
// Then update main.dart to call: await Firebase.initializeApp(...)
// ─────────────────────────────────────────────────────────────

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/player.dart';

// class FirebaseService {
//   static final _db = FirebaseFirestore.instance;
//   static const _collection = 'users';

//   /// Save or update the current user's profile
//   static Future<void> saveProfile(String userId, Player player) async {
//     await _db.collection(_collection).doc(userId).set(player.toMap());
//   }

//   /// Fetch all players matching area + sport (simple filter, no algorithm)
//   static Future<List<Player>> findPlayers({
//     required String area,
//     required String sport,
//     String? skill,
//     String? availability,
//   }) async {
//     Query query = _db
//         .collection(_collection)
//         .where('area', isEqualTo: area)
//         .where('sport', isEqualTo: sport);

//     if (skill != null) {
//       query = query.where('skill', isEqualTo: skill);
//     }

//     if (availability != null && availability != 'Both') {
//       // match players with same availability OR 'Both'
//       // Firestore doesn't support OR queries natively on the same field,
//       // so fetch and filter client-side:
//     }

//     final snapshot = await query.get();
//     return snapshot.docs
//         .map((doc) => Player.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//         .where((p) =>
//             availability == null ||
//             p.availability == availability ||
//             p.availability == 'Both')
//         .toList();
//   }

//   /// Send a connection request (stores in a sub-collection)
//   static Future<void> sendConnectionRequest({
//     required String fromUserId,
//     required String toUserId,
//     required String message,
//   }) async {
//     await _db
//         .collection(_collection)
//         .doc(toUserId)
//         .collection('requests')
//         .add({
//       'fromUserId': fromUserId,
//       'message': message,
//       'timestamp': FieldValue.serverTimestamp(),
//       'status': 'pending',
//     });
//   }
// }
