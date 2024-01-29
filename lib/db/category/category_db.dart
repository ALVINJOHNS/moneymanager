import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:moneymanager/screens/transactions/transactions_screen.dart';

const categoryDbName = 'category-database';

abstract class CategoryDBFunctions {
  Future<void> insertCategoryModel(CategoryModel value);
  Future<List<CategoryModel>> getCategories();
  Future<void> refreshui();
  Future<void> deleteCategoryModel(String id);
}

class CategoryDB implements CategoryDBFunctions {
  CategoryDB._internal(); //singleton start

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  } //singleton end

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);

  @override
  Future<void> insertCategoryModel(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await _categoryDB.put(value.id, value);
    refreshui();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return _categoryDB.values.toList();
  }

  @override
  Future<void> refreshui() async {
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    final allcategories = await getCategories();
    await Future.forEach(allcategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryList.value.add(category);
      } else {
        expenseCategoryList.value.add(category);
      }
    });

    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
  }

  @override
  Future<void> deleteCategoryModel(id) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    _categoryDB.delete(id);
    refreshui();
  }
}
