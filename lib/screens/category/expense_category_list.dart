import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/models/category/category_model.dart';

class ExpenseCategoryListWidget extends StatelessWidget {
  const ExpenseCategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryList,
      builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
        return ListView.separated(
            itemBuilder: (ctx, ind) {
              return ListTile(
                leading: Text(newlist[ind].name),
                trailing: IconButton(
                    onPressed: () {
                      CategoryDB().deleteCategoryModel(newlist[ind].id);
                    },
                    icon: Icon(Icons.delete)),
              );
            },
            separatorBuilder: (BuildContext ctx, int ind) {
              return Divider();
            },
            itemCount: newlist.length);
      },
    );
  }
}
