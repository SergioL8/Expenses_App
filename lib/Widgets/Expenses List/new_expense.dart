import 'package:flutter/material.dart';
import 'package:expenses_app/models/expense.dart';

class NewExpense extends StatefulWidget{

  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {

  // this variables store the user input
  final _titleControler = TextEditingController();
  final _amountControler = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  /*
  * this function presents the date picker implemented by flutter
  */
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now, // date to be selected before the user picks
      firstDate: firstDate, // oldest date that can be picked
      lastDate: now, // newest date that can be picked
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

/*
* this function is triggered when clicking save by the user
*/
void _submitExpenseData() {

  final enteredAmount = double.tryParse(_amountControler.text);
  final amountInvalid = enteredAmount == null || enteredAmount == 0; // check that the amount entered(how expensive was the expense) is not null or 0

  // check that title is not empty, that the amount is valid and that there is a selected date
  if (_titleControler.text.trim().isEmpty || amountInvalid || _selectedDate == null) {
    // if any of this conditions are met, then we want to show an error dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: const Text('Please make sure valid inputs were entered.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Ok'))
        ],
      )
    );
    return;
  }
  // else we want to add the expense so we call the function to do so, this function is passed trough the constructor
  widget.onAddExpense( Expense(
      title: _titleControler.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory)
    );
    Navigator.pop(context);
}


  /*
  * dispose function to optimize app storage
  */
  @override
  void dispose() {
    _titleControler.dispose();
    _amountControler.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom; // make sure that the keyboard ahs enough space

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      
      return  SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16 , 16, keyboardSpace + 16),
          child: Column(
            children: [
              if (width >= 600) // if the phone is in ladscape mode
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleControler,
                        maxLength: 50,
                        decoration: const InputDecoration(
                        label: Text('Title'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24,),
                  ],
                )
              else  // if the phone is in vertical mode
                TextField(
                  controller: _titleControler,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountControler,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null ? 'No date selected'
                          : formmatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month)
                        )
                      ],
                    )
                  )
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values.map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase(),),),
                      ).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          return;
                        }
                        _selectedCategory = value;
                      });
                    } ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData,
                    child: const Text('Save expense')
                  ),
                ],
              )
            ],
          )
        ),
      ),
    );
    });

    
  }
}