import 'package:get/get.dart';
import '../services/pet_service.dart';

class PetController extends GetxController {
  final PetService _petService = PetService();

  var isLoading = false.obs;
  var pets = [].obs;
  var breeds = <String>[].obs;
  var selectedType = 'dog'.obs;
  var selectedBreed = ''.obs;
  var selectedAge = ''.obs;
  var selectedGender = ''.obs;
  var errorMessage = ''.obs;

  /// Fetch breeds for the selected type (e.g., Dog, Cat)
  Future<void> loadBreeds() async {
    try {
      isLoading.value = true;
      final breedList = await _petService.fetchBreeds(selectedType.value);
      breeds.assignAll(breedList);
    } catch (e) {
      errorMessage.value = 'Failed to load breeds: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch pets (with optional filters)
  Future<void> loadPets() async {
    try {
      isLoading.value = true;
      final animals = await _petService.fetchAnimals(
        type: selectedType.value,
        location: '10001',
        breed: selectedBreed.value.isEmpty ? null : selectedBreed.value,
        age: selectedAge.value.isEmpty ? null : selectedAge.value,
        gender: selectedGender.value.isEmpty ? null : selectedGender.value,
      );
      pets.assignAll(animals);
    } catch (e) {
      errorMessage.value = 'Failed to load pets: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh pets list (for pull-to-refresh or button)
  Future<void> refreshPets() async {
    await loadPets();
  }

  /// Change selected type and reload breeds
  void changeAnimalType(String type) {
    selectedType.value = type;
    selectedBreed.value = '';
    loadBreeds();
    loadPets();
  }
}
