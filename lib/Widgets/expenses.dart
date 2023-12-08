import 'package:expenses_app/Widgets/Chart/chart.dart';
import 'package:expenses_app/Widgets/Expenses%20List/new_expense.dart';
import 'package:expenses_app/main.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/Widgets/Expenses%20List/expenses_list.dart';


class Expenses extends StatefulWidget{

  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {

  // these two expenses are two dummy expenses
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work),

     Expense(
      title: 'Cinema',
      amount: 9.99,
      date: DateTime.now(),
      category: Category.leisure),
  ];



/*
* function called when you click the + button in the appbar
* the objective of this function is to open a modal bottom sheet which displays the widgets for the user to
* insert input
*/
void _openAddExpenseOverlay () {
  showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (ctx) => NewExpense(onAddExpense: _addExpense,), // this function includes the widgets that the user sees when opening the modalBottomsheet
  );
}

/*
* this function adds a new expense to the list taht contains all the expenses
*/
void _addExpense(Expense expense) {
  setState(() {
    _registeredExpenses.add(expense);
  });
  
}

/*
* this function removes an expense from the expenses list, and shows a snackbar with the option of undoing
* the deletion
*/
void _removeExpense(Expense expense) {
  final expenseIndex = _registeredExpenses.indexOf(expense);
  setState(() {
    _registeredExpenses.remove(expense);
  });
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Expense Deleted'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        }
      )
    ),
  );
}


  @override
  Widget build (context) {

  final width = MediaQuery.of(context).size.width;

    // here I'm just making sure that the expenses list is not empty, if it is show a message informing the user
    Widget mainContent = const Center(child: Text('No expenses found. Start adding some!'));
    if (_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'), // title of the app bar
        actions: [
          IconButton( // this button opens a bottom modal sheet with the widgets for the user to add input
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ]),
      body: width < 600 // this line is used to check for the orientation of the phone, if it's vertical show a colum with the chart and the list
      ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent, )
        ]
      )
      : Row( // if the phone is horizontal then show a row with the chart at the left and the list at the right
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent, )
        ],
      ),
      
    );
  }
}