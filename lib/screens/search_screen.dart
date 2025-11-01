import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pet_controller.dart';
import '../widgets/pet_card.dart';
import 'pet_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final PetController controller = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Search Pets'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧩 Filter Section
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedType.value,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'dog', child: Text('Dog')),
                          DropdownMenuItem(value: 'cat', child: Text('Cat')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeAnimalType(value);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedGender.value.isEmpty
                            ? null
                            : controller.selectedGender.value,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Any')),
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                        ],
                        onChanged: (value) {
                          controller.selectedGender.value = value ?? '';
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 🔍 Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.loadPets(),
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🐕 Pet Results Section
                if (controller.errorMessage.value.isNotEmpty)
                  Center(child: Text(controller.errorMessage.value))
                else if (controller.pets.isEmpty)
                  const Center(
                    child: Text(
                      'No pets available right now.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true, // ✅ prevents overflow
                    physics: const NeverScrollableScrollPhysics(), // ✅ avoids nested scroll conflicts
                    itemCount: controller.pets.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final pet = controller.pets[index];
                      return GestureDetector(
                        onTap: () => Get.to(() => PetDetailScreen(pet: pet)),
                        child: PetCard(pet: pet),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
