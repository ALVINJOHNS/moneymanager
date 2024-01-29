import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/models/category/category_model.dart';

class IncomeCategoryListWidget extends StatelessWidget {
  const IncomeCategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB.instance.incomeCategoryList,
      builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
        return ListView.separated(
            itemBuilder: (BuildContext ctx, int ind) {
              return ListTile(
                leading: Text(newlist[ind].name),
                trailing: IconButton(
                    onPressed: () {
                      CategoryDB.instance.deleteCategoryModel(newlist[ind].id);
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
