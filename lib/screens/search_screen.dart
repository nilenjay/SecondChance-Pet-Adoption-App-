import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/search_pet_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchPetController controller = Get.put(SearchPetController());

  final List<String> animalTypes = ['dog', 'cat', 'rabbit', 'bird'];
  final List<String> ageOptions = ['baby', 'young', 'adult', 'senior'];
  final List<String> genderOptions = ['male', 'female'];

  @override
  Widget build(BuildContext context) {
    // Load initial data
    controller.loadBreeds();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Pets',
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🐾 Animal type selector
                Text(
                  "Select Animal Type",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
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

                const SizedBox(height: 16),

                // 🐶 Breed dropdown
                Text("Select Breed", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select Breed"),
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
                  },
                ),

                const SizedBox(height: 12),

                // 🕑 Age dropdown
                Text("Select Age", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select Age"),
                  value: controller.selectedAge.value.isEmpty
                      ? null
                      : controller.selectedAge.value,
                  items: ageOptions.map((age) {
                    return DropdownMenuItem(
                      value: age,
                      child: Text(age.capitalizeFirst!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedAge.value = value ?? '';
                  },
                ),

                const SizedBox(height: 12),

                // 🚻 Gender dropdown
                Text("Select Gender", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select Gender"),
                  value: controller.selectedGender.value.isEmpty
                      ? null
                      : controller.selectedGender.value,
                  items: genderOptions.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.capitalizeFirst!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedGender.value = value ?? '';
                  },
                ),

                const SizedBox(height: 20),

                // 🔍 Search button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: controller.searchPets,
                    icon: const Icon(Icons.search),
                    label: Text(
                      'Search',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🐕 Search Results
                if (controller.pets.isNotEmpty)
                  Text(
                    "Search Results",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                const SizedBox(height: 8),

                ...controller.pets.map((pet) {
                  final petName = pet['name'] ?? 'Unknown';
                  final breed = pet['breeds']?['primary'] ?? 'Unknown breed';
                  final imageUrl = pet['photos'] != null &&
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
                      leading: imageUrl != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        breed,
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}
