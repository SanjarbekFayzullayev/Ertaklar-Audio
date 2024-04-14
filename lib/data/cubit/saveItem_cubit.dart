import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveItemCubit extends Cubit<List<String>> {
  SaveItemCubit() : super([]);
  List<String> itemsIndex = [];
  Future<void> loadSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   itemsIndex = prefs.getStringList('itemsIndex')??[];
    emit(itemsIndex ?? []);
  }

  Future<void> saveSelected(List<String> itemsIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('itemsIndex', itemsIndex);
    emit(itemsIndex);
  }
  void removeItem(String item) {
    state.remove(item);
    saveSelected(List<String>.from(state)); // Updating SharedPreferences
  }

}
