import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/db/transactions/transaction_db.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController _titleController = TextEditingController();

  TextEditingController _amountController = TextEditingController();

  CategoryType? _selectedType;

  DateTime? _selectedDate;

  String? _selectedCategory;

  CategoryModel? _selectedCategoryModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD TRANSACTION'),
        /* 
        TITLE
        AMOUNT
        DATE
        TYPE
        CATEGORY DROPDOWN
        */
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          TextButton.icon(
              onPressed: () async {
                final _date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 50)),
                  lastDate: DateTime.now(),
                );

                setState(() {
                  _selectedDate = _date;
                });
              },
              icon: Icon(Icons.calendar_month),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : '${_selectedDate.toString().substring(0, 10)}')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          _selectedCategory = null;
                        });
                      }),
                  Text('expense'),
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: CategoryType.income,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          _selectedCategory = null;
                        });
                      }),
                  Text('income'),
                ],
              ),
            ],
          ),
          _selectedType == null
              ? Container()
              : DropdownButton(
                  hint: Text('Select Category'),
                  value: _selectedCategory,
                  items: (_selectedType == CategoryType.expense
                          ? CategoryDB.instance.expenseCategoryList
                          : _selectedType == CategoryType.income
                              ? CategoryDB.instance.incomeCategoryList
                              : null)
                      ?.value
                      .map((e) {
                    return DropdownMenuItem(
                      child: Text(e.name),
                      value: e.id,
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                _addTransactionOnPressed();
              },
              child: Text('Add Transaction'))
        ],
      ),
    );
  }

  Future<void> _addTransactionOnPressed() async {
    final _titletext = _titleController.text;
    final _amountText = _amountController.text;
    if (_titletext.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedType == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    await TransactionDB.instance.addTransaction(
      TransactionModel(
        transactionName: _titletext,
        transactionAmount: _parsedAmount,
        transactionDate: _selectedDate!,
        transactionType: _selectedType!,
        transactionCategory: _selectedCategoryModel!,
      ),
    );
    TransactionDB.instance.refreshUITransactions();
    Navigator.of(context).pop();
  }
}
