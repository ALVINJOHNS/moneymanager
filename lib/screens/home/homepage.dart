import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:moneymanager/screens/category/category_add_popup.dart';
import 'package:moneymanager/screens/category/category_screen.dart';
import 'package:moneymanager/screens/transactions/add_transaction/add_transaction_screen.dart';
import 'package:moneymanager/screens/transactions/transactions_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  ValueNotifier<int> selectedindex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedindex,
        builder: (BuildContext ctx, int newint, Widget? _) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.money), label: "Transactions"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: "Categories")
            ],
            currentIndex: newint,
            onTap: (value) {
              selectedindex.value = value;
              selectedindex.notifyListeners();
            },
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedindex,
        builder: (context, newindex, _) {
          return IndexedStack(
            index: newindex,
            children: const [
              TransactionsScreen(),
              CategoryScreen(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedindex.value == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return AddTransactionScreen();
            })); //transactions add
          } else {
            showPopup(context); //categories add
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
