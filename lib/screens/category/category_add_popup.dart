import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryValue =
    ValueNotifier(CategoryType.income);

Future<void> showPopup(BuildContext context) async {
  final categoryNameController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: categoryNameController,
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: RadioButton(title: 'Income', type: CategoryType.income),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: RadioButton(title: 'Expence', type: CategoryType.expense),
            ),
            ElevatedButton(
                onPressed: () {
                  if (categoryNameController.text.isEmpty) {
                    return;
                  }
                  CategoryDB().insertCategoryModel(CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    name: categoryNameController.text,
                    type: selectedCategoryValue.value,
                  ));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add Category')),
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  const RadioButton({super.key, required this.title, required this.type});
  final String title;
  final CategoryType type;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        ValueListenableBuilder(
            valueListenable: selectedCategoryValue,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio(
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryValue.value = value;
                    selectedCategoryValue.notifyListeners();
                  });
            })
      ],
    );
  }
}
