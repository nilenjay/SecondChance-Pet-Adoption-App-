import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pet_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PetController controller = Get.put(PetController());

  final List<String> animalTypes = ['dog', 'cat', 'rabbit', 'bird'];

  @override
  Widget build(BuildContext context) {
    // Fetch initial data when screen opens
    controller.loadPets();
    controller.loadBreeds();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Adoption',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔘 Animal type selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: animalTypes.map((type) {
                    final isSelected = controller.selectedType.value == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(type.capitalizeFirst!),
                        selected: isSelected,
                        onSelected: (_) => controller.changeAnimalType(type),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // 🐶 Breed dropdown
              DropdownButton<String>(
                hint: const Text("Select Breed"),
                isExpanded: true,
                value: controller.selectedBreed.value.isEmpty
                    ? null
                    : controller.selectedBreed.value,
                items: controller.breeds.map((breed) {
                  return DropdownMenuItem(
                    value: breed,
                    child: Text(breed),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedBreed.value = value ?? '';
                  controller.loadPets();
                },
              ),

              const SizedBox(height: 12),

              // 👇 Pet List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshPets,
                  child: ListView.builder(
                    itemCount: controller.pets.length,
                    itemBuilder: (context, index) {
                      final pet = controller.pets[index];
                      final petName = pet['name'] ?? 'Unknown';
                      final petBreed =
                          pet['breeds']?['primary'] ?? 'Unknown breed';
                      final petPhoto = pet['photos'] != null &&
                          pet['photos'].isNotEmpty
                          ? pet['photos'][0]['medium']
                          : null;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: petPhoto != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: petPhoto,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.pets, size: 50),
                            ),
                          )
                              : const Icon(Icons.pets, size: 50),
                          title: Text(
                            petName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            petBreed,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
