class Pet {
  final String? id;
  final String? name;
  final String? breed;
  final String? age;
  final String? gender;
  final String? description;
  final String? imageUrl;
  final String? type;

  Pet({
    this.id,
    this.name,
    this.breed,
    this.age,
    this.gender,
    this.description,
    this.imageUrl,
    this.type,
  });

  // Factory constructor to create a Pet object from JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    final photos = json['photos'] as List?;
    String? image;

    if (photos != null && photos.isNotEmpty) {
      image = photos[0]['medium'] ?? photos[0]['full'];
    }

    return Pet(
      id: json['id']?.toString(),
      name: json['name'],
      breed: json['breeds']?['primary'],
      age: json['age'],
      gender: json['gender'],
      description: json['description'],
      imageUrl: image,
      type: json['type'],
    );
  }

  // Convert Pet object to JSON (optional for saving)
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
