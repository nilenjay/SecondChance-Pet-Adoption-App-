import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pet_controller.dart';
import 'pet_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final PetController controller = Get.put(PetController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Adoption 🐾'),
        centerTitle: true,
      ),

      // 🔽 Main Content
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pets.isEmpty) {
          return const Center(
            child: Text('No pets available right now 🐶'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.pets.length,
          itemBuilder: (context, index) {
            final pet = controller.pets[index];
            final photo = pet['photos'] != null && pet['photos'].isNotEmpty
                ? pet['photos'][0]['medium']
                : 'https://cdn-icons-png.flaticon.com/512/616/616408.png'; // fallback image

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    photo,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  pet['name'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(pet['type'] ?? 'Unknown Type'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.teal),

                // 👇 Navigate to Pet Detail Screen
                onTap: () {
                  Get.to(() => PetDetailScreen(pet: pet));
                },
              ),
            );
          },
        );
      }),

      // 🧭 Floating button for Search Navigation
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.search),
        label: const Text('Search'),
        onPressed: () {
          Get.to(() => SearchScreen());
        },
      ),
    );
  }
}
