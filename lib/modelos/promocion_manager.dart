import 'package:flutter/material.dart';

import 'promocion_item.dart';

class PromocionManager extends ChangeNotifier {
  final _promocionItems = <PromocionItem>[];
  int _selectedIndex = -1;
  bool _createNewItem = false;

  List<PromocionItem> get promocionItems => List.unmodifiable(_promocionItems);
  int get selectedIndex => _selectedIndex;
  PromocionItem? get selectedGroceryItem =>
      selectedIndex != -1 ? _promocionItems[selectedIndex] : null;
  bool get isCreatingNewItem => _createNewItem;

  void createNewItem() {
    _createNewItem = true;
    notifyListeners();
  }

  void deleteItem(int index) {
    _promocionItems.removeAt(index);
    notifyListeners();
  }

  void groceryItemTapped(int index) {
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void setSelectedGroceryItem(String id) {
    final index = promocionItems.indexWhere((element) => element.id == id);
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void addItem(PromocionItem item) {
    _promocionItems.add(item);
    _createNewItem = false;
    notifyListeners();
  }

  void updateItem(PromocionItem item, int index) {
    _promocionItems[index] = item;
    _selectedIndex = -1;
    _createNewItem = false;
    notifyListeners();
  }

  void completeItem(int index, bool change) {
    final item = _promocionItems[index];
    _promocionItems[index] = item.copyWith(isComplete: change);
    notifyListeners();
  }
}
