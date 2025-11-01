import 'package:flutter/material.dart';

class PetDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final photo = pet['photos'] != null && pet['photos'].isNotEmpty
        ? pet['photos'][0]['large']
        : 'https://cdn-icons-png.flaticon.com/512/616/616408.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name'] ?? 'Pet Details'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Pet Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                photo,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // 🐶 Pet Name
            Text(
              pet['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 📋 Pet Info
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                _buildInfoChip('Type', pet['type']),
                _buildInfoChip('Breed', pet['breeds']?['primary']),
                _buildInfoChip('Age', pet['age']),
                _buildInfoChip('Gender', pet['gender']),
                _buildInfoChip('Size', pet['size']),
              ],
            ),

            const SizedBox(height: 20),

            // 📝 Description
            Text(
              'About ${pet['name'] ?? 'this pet'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pet['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            // 📞 Contact Info
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildContactInfo('Email', pet['contact']?['email']),
            _buildContactInfo('Phone', pet['contact']?['phone']),
            _buildContactInfo('Address', _formatAddress(pet['contact']?['address'])),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Widget: Info chip
  Widget _buildInfoChip(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.teal[50],
      side: const BorderSide(color: Colors.teal),
    );
  }

  // 🔹 Helper Widget: Contact info
  Widget _buildContactInfo(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // 🔹 Helper: Format address map
  static String? _formatAddress(Map? address) {
    if (address == null) return null;
    final city = address['city'] ?? '';
    final state = address['state'] ?? '';
    final country = address['country'] ?? '';
    return [city, state, country].where((e) => e.isNotEmpty).join(', ');
  }
}
