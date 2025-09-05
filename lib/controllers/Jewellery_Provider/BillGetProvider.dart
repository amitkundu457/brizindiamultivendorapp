import 'package:flutter/material.dart';
// import '../../Model/Jewellery_Model/LocalDataModel.dart';
import '../../models/Jewellery_Model/LocalDataModel.dart';

class BillProvider with ChangeNotifier {
  // List to store Bill data
  List<Bill> _billList = [];

  // Getter for billList
  List<Bill> get billList => _billList;

  // Method to add a new bill
  void addBill(Bill newBill) {
    _billList.add(newBill);
    notifyListeners();  // Notify listeners to update the UI
  }

  // Method to remove a bill by index or by the bill itself
  void removeBill(int index) {
    _billList.removeAt(index);  // Removes the bill at the specified index
    notifyListeners();  // Notify listeners to update the UI
  }
}
