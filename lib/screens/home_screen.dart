import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pet_controller.dart';
import '../widgets/pet_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final PetController controller = Get.put(PetController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopt a Pet 🐶'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.to(() => SearchScreen());
        },
        icon: const Icon(Icons.search),
        label: const Text('Search'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No pets available right now 🐾',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.loadPets(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.loadPets(),
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: controller.pets.length,
            itemBuilder: (context, index) {
              final pet = controller.pets[index];
              return PetCard(pet: pet);
            },
          ),
        );
      }),
    );
  }
}
