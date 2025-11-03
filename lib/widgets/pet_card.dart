import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/pet_model.dart';
import '../controllers/pet_interaction_controller.dart';

class PetCard extends StatelessWidget {
  final PetModel pet;
  final PetInteractionController petController = Get.find<PetInteractionController>();

  PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              pet.imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(pet.breed, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final isFav = petController.favoritePets
                          .any((p) => p.id == pet.id);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.grey,
                        ),
                        onPressed: () => petController.toggleFavorite(pet),
                      );
                    }),
                    ElevatedButton(
                      onPressed: () => petController.adoptPet(pet),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Adopt"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
