class Pet {
  final String id; // made non-nullable
  final String? name;
  final String? breed;
  final String? age;
  final String? gender;
  final String? description;
  final String? imageUrl;
  final String? type;

  Pet({
    required this.id,
    this.name,
    this.breed,
    this.age,
    this.gender,
    this.description,
    this.imageUrl,
    this.type,
  });

  // Used for external API (like PetFinder)
  factory Pet.fromJson(Map<String, dynamic> json) {
    final photos = json['photos'] as List?;
    String? image;

    if (photos != null && photos.isNotEmpty) {
      image = photos[0]['medium'] ?? photos[0]['full'];
    }

    return Pet(
      id: json['id']?.toString() ?? '', // fallback to empty string if null
      name: json['name'],
      breed: json['breeds']?['primary'],
      age: json['age'],
      gender: json['gender'],
      description: json['description'],
      imageUrl: image,
      type: json['type'],
    );
  }

  // Used for Firestore docs
  factory Pet.fromDoc(String id, Map<String, dynamic> data) {
    return Pet(
      id: id,
      name: data['name'],
      breed: data['breed'],
      age: data['age'],
      gender: data['gender'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      type: data['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'gender': gender,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
    };
  }
}
