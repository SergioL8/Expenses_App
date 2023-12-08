import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formmatter = DateFormat.yMd();
const uuid = Uuid(); 

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense{

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formmatter.format(date);
  }
}

// this model stores a category and a list with all the expenses that are assigned to that category
class ExpenseBucket {

  const ExpenseBucket({required this.category, required this.expenses});

  // this lines here populates the expenses list by comparing the category argument with the allExpenses list
  // for it you have to pass an expenses list, which is done when call in chart.dart
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
  : expenses = allExpenses.where((expense) => expense.category == category).toList();


  final Category category;
  final List<Expense> expenses;

  // this getter computes the total amount of expenses per category
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}

