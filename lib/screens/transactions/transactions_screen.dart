import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/db/transactions/transaction_db.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUITransactions();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionList,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final value = newList[index];
              return Slidable(
                key: Key(value.id!),
                startActionPane: ActionPane(motion: ScrollMotion(), children: [
                  TextButton.icon(
                    onPressed: () {
                      TransactionDB.instance.deleteTransaction(value.id!);
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                  )
                ]),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        value.transactionType == CategoryType.expense
                            ? Colors.red
                            : Colors.green,
                    radius: 25,
                    child: Text(
                      parseDate(value
                          .transactionDate), //newList[index].transactionDate.toString().substring(5, 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  title: Text('${value.transactionAmount}'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value.transactionName),
                      Text('${value.transactionCategory.name}')
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: newList.length,
          );
        });
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _parsedDate = _date.split(' ');
    return '${_parsedDate.last}\n${_parsedDate.first}';
  }
}









// import 'package:flutter/material.dart';
// import 'package:moneymanager/db/transactions/transaction_db.dart';
// import 'package:moneymanager/models/transaction/transaction_model.dart';

// class TransactionsScreen extends StatelessWidget {
//   const TransactionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TransactionDB.instance.RefreshUITransactions();
//     return ListView.separated(
//       itemBuilder: (BuildContext context, int index) {
//         return TransactionListWidget(ind: index);
//       },
//       separatorBuilder: (BuildContext context, int index) {
//         return Divider();
//       },
//       itemCount: 2,
//     );
//   }
// }

// class TransactionListWidget extends StatelessWidget {
//   const TransactionListWidget({
//     required this.ind,
//     super.key,
//   });
//   final int ind;
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: TransactionDB.instance.transactionList,
//         builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
//           return ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               child: Text(
//                 newList[ind].transactionDate.toString().substring(5, 10),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             title: Text('${newList[ind].transactionAmount}'),
//             subtitle: Text(newList[ind].transactionName),
//           );
//         });
//   }
// }
