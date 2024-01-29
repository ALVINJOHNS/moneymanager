import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';

import 'package:moneymanager/screens/category/expense_category_list.dart';
import 'package:moneymanager/screens/category/income_category_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController1;

  @override
  void initState() {
    tabController1 = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CategoryDB().refreshui(); //initstate command
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: TabBar(
            controller: tabController1,
            tabs: [
              Text(
                "income",
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
              Text(
                'expense',
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController1,
            children: [
              IncomeCategoryListWidget(),
              ExpenseCategoryListWidget(),
            ],
          ),
        )
      ],
    );
  }
}
