import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/player_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _playersCollection {
    return _db.collection('users').doc(userId).collection('players');
  }

  Future<String?> validatePlayer(Player player) async {
    // validacao idade
    if (player.age < 16) {
      return "O jogador deve ter pelo menos 16 anos.";
    }

    // validacao mesmo nome
    final querySnapshot = await _playersCollection
        .where('name', isEqualTo: player.name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        if (doc.id != player.id) {
          return "Já existe um jogador com o nome '${player.name}'.";
        }
      }
    }

    return null;
  }

  Future<void> addPlayer(Player player) async {
    await _playersCollection.add(player.toMap());
  }

  Stream<List<Player>> getPlayersStream() {
    return _playersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Player.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updatePlayer(Player player) async {
    if (player.id == null) return;
    await _playersCollection.doc(player.id).update(player.toMap());
  }

  Future<void> deletePlayer(String id) async {
    await _playersCollection.doc(id).delete();
  }
}
