import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name ?? "Pet Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  pet.imageUrl ??
                      'https://cdn-icons-png.flaticon.com/512/616/616408.png',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pet info
            Text(
              pet.name ?? 'Unknown Pet',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Breed: ${pet.breed ?? "N/A"}'),
            Text('Age: ${pet.age ?? "N/A"}'),
            Text('Gender: ${pet.gender ?? "N/A"}'),
            const SizedBox(height: 16),

            // Pet description
            const Text(
              'Description',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              pet.description ??
                  'No description available for this adorable pet.',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
