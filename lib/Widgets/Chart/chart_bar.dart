import 'package:flutter/material.dart';

/*
* This widget forms a bar of weight "fill" which is passed in the constructor. This bar being the individual 
* chart for each category in the general chart
*/
class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  });

  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark; // this line is used to determina if the system is currently in dark or bright mode
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox( // this widget sizes it's child to a fraction of it's total space
          heightFactor: fill, // the fill variable stores the fraction for the size of the box
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}