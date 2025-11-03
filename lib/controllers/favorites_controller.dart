import 'package:get/get.dart';
import '../models/pet_model.dart';

class FavoritesController extends GetxController {
  var favoritePets = <Pet>[].obs;

  void addFavorite(Pet pet) {
    if (!favoritePets.contains(pet)) {
      favoritePets.add(pet);
    }
  }

  void removeFavorite(Pet pet) {
    favoritePets.remove(pet);
  }
}
