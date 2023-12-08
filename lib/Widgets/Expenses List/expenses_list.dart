import 'package:expenses_app/Widgets/Expenses%20List/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/models/expense.dart';

class ExpensesList extends StatelessWidget{

  const ExpensesList({super.key, required this.expenses, required this.onRemoveExpense});

  final void Function(Expense expense)onRemoveExpense;
  final List<Expense> expenses;

  @override
  Widget build(context) {
    return ListView.builder( // here we use the listView widget to present the list of expenses
      itemCount: expenses.length, // this sests the amount of items that listview has to create
      itemBuilder: (ctx, index) => Dismissible( // the dismissible widget is used to delete expenses by sliding the card
        background: Container( // just some scheming being done here
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal)
        ),
        key: ValueKey(expenses[index]), // needed to know what item we are deleting
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]); // this function deletes the expense from the expenses list if slided this function comes from the constructor
        },
        child: ExpenseItem(expenses[index],), // the child is this custom widget which is a card that presents the expense information
      ) ,
    );
  }
}