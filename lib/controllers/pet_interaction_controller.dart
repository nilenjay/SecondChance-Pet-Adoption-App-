import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pet_model.dart';

class PetInteractionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var favoritePets = <PetModel>[].obs;
  var adoptedPets = <PetModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    _loadAdopted();
  }

  String get userId => _auth.currentUser?.uid ?? '';

  // ✅ Add to Favorites
  Future<void> toggleFavorite(PetModel pet) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(pet.id);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
      favoritePets.removeWhere((p) => p.id == pet.id);
    } else {
      await docRef.set(pet.toJson());
      favoritePets.add(pet);
    }
  }

  // ✅ Adopt Pet
  Future<void> adoptPet(PetModel pet) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('adopted')
        .doc(pet.id);

    await docRef.set(pet.toJson());
    adoptedPets.add(pet);
  }

  // ✅ Load Favorites
  Future<void> _loadFavorites() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    favoritePets.value =
        snapshot.docs.map((doc) => PetModel.fromJson(doc.data())).toList();
  }

  // ✅ Load Adopted Pets
  Future<void> _loadAdopted() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('adopted')
        .get();
    adoptedPets.value =
        snapshot.docs.map((doc) => PetModel.fromJson(doc.data())).toList();
  }
}
