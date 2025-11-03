import 'package:get/get.dart';
import '../services/pet_service.dart';

class SearchPetController extends GetxController {
  final PetService _petService = PetService();

  var isLoading = false.obs;
  var pets = [].obs;
  var breeds = <String>[].obs;
  var errorMessage = ''.obs;

  var selectedType = 'dog'.obs;
  var selectedBreed = ''.obs;
  var selectedAge = ''.obs;
  var selectedGender = ''.obs;

  /// Load available breeds for selected type
  Future<void> loadBreeds() async {
    try {
      isLoading.value = true;
      final data = await _petService.fetchBreeds(selectedType.value);
      breeds.assignAll(data);
    } catch (e) {
      errorMessage.value = 'Failed to load breeds: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Perform pet search based on filters
  Future<void> searchPets() async {
    try {
      isLoading.value = true;
      final data = await _petService.fetchAnimals(
        type: selectedType.value,
        breed: selectedBreed.value.isEmpty ? null : selectedBreed.value,
        age: selectedAge.value.isEmpty ? null : selectedAge.value,
        gender: selectedGender.value.isEmpty ? null : selectedGender.value,
        location: '10001', // common location for testing
      );
      pets.assignAll(data);
    } catch (e) {
      errorMessage.value = 'Failed to search pets: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Change animal type and refresh breed list
  void changeAnimalType(String type) {
    selectedType.value = type;
    selectedBreed.value = '';
    loadBreeds();
  }

  /// Clear all filters
  void clearFilters() {
    selectedBreed.value = '';
    selectedAge.value = '';
    selectedGender.value = '';
    pets.clear();
  }
}
