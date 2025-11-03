import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavoritesScreen({super.key});

  Future<List<Map<String, dynamic>>> _getFavoritePets() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final favoriteIds = List<String>.from(userDoc.data()?['favorites'] ?? []);

    if (favoriteIds.isEmpty) return [];

    final pets = await _firestore
        .collection('pets')
        .where(FieldPath.documentId, whereIn: favoriteIds)
        .get();

    return pets.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFavoritePets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite pets yet 🐾'));
          }

          final pets = snapshot.data!;
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pet['imageUrl'] ?? ''),
                  ),
                  title: Text(pet['name'] ?? 'Unknown'),
                  subtitle: Text(pet['species'] ?? 'Pet'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
