import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../models/pet_model.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesController controller = Get.put(FavoritesController());

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.favoritePets.isEmpty) {
          return const Center(
            child: Text(
              "No favorite pets yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.favoritePets.length,
          itemBuilder: (context, index) {
            Pet pet = controller.favoritePets[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(pet.imageUrl),
                  radius: 25,
                ),
                title: Text(pet.name),
                subtitle: Text(pet.breed),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => controller.removeFavorite(pet),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
