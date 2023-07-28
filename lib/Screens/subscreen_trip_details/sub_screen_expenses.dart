// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wanderlust_new/Database/database_helper.dart';
import 'package:wanderlust_new/Screens/widgets/custom_textfield.dart';

import '../../Database/database_models.dart';
import '../../style.dart';
import '../widgets/custom_grid.dart';

class SubScreenExpense extends StatefulWidget {
  SubScreenExpense({super.key, required this.trip, this.expense});
  Trips trip;
  Expenses? expense;

  @override
  State<SubScreenExpense> createState() => _SubScreenExpenseState();
}

class _SubScreenExpenseState extends State<SubScreenExpense> {
  double? eachExp;
  final expenseController = TextEditingController();

  String expenseType = 'Food';

  final _formKey = GlobalKey<FormState>();

  List<Companions>? compList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 15,
        ),
        // Expenses
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          height: 150,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Expenses',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    height: 40,
                    width: 40,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: mainColor),
                      onPressed: () {
                        addExpensesBottomSheet(context);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 0,
              ),
              ValueListenableBuilder(
                valueListenable: totalExpenses,
                builder: (context, value, child) => Text(
                  '₹ $value',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ValueListenableBuilder(
                    valueListenable: balanceNotifire,
                    builder: (context, value, child) => Text(
                      '₹ $value',
                      style: TextStyle(
                          fontSize: 16,
                          color: value <= 0 ? Colors.red : Colors.white,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: 2),
        Container(
          constraints:
              BoxConstraints.tight(Size(MediaQuery.sizeOf(context).width, 90)),
          padding: const EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
            color: Theme.of(context).primaryColor.withOpacity(.8),
          ),
          // Expense per person
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Companions',
                      style: subTextStyle(color: Colors.white)),
                  FutureBuilder(
                    future: DatabaseHelper.instance
                        .getAllCompanions(widget.trip.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return Text(
                          '${snapshot.data!.length + 1}',
                          style: subTextStyle(color: Colors.white, size: 20),
                        );
                      }
                      return const Text('1',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis));
                    },
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expense per Person',
                      style: subTextStyle(color: Colors.white)),
                  // Text('₹  400',
                  //     style: subTextStyle(color: Colors.white, size: 20))
                  FutureBuilder(
                    future: getCompanion(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Container(
                          height: 20,
                          width: 20,
                          color: Colors.amber,
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final expensePerPerson =
                            calculateExpensePerPerson(snapshot.data ?? 1);
                        return Text('₹ ${expensePerPerson.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis));
                      }
                      return Text(
                        "₹ ${expenseNotifier.value[0].totalexpense}",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 20,
        ),
        // Seperate expense
        ValueListenableBuilder(
          valueListenable: expenseNotifier,
          builder: (context, value, child) {
            final expense = expenseNotifier.value[0];
            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / .6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              children: [
                customGrid(
                    amount: expense.food!,
                    amountColor: Theme.of(context).colorScheme.primary,
                    icon: Icons.restaurant_menu_rounded,
                    text: 'Food',
                    bgcolor: Colors.orange.shade100,
                    iconColor: Colors.orange),
                customGrid(
                    text: 'Transport',
                    amountColor: Theme.of(context).colorScheme.primary,
                    amount: expense.transport!,
                    icon: Icons.directions,
                    bgcolor: Colors.blue.shade100,
                    iconColor: Colors.blue),
                customGrid(
                    text: 'Hotel',
                    amountColor: Theme.of(context).colorScheme.primary,
                    amount: expense.hotel!,
                    icon: Icons.hotel_rounded,
                    bgcolor: Colors.purple.shade100,
                    iconColor: Colors.purple),
                customGrid(
                    text: 'Other',
                    amountColor: Theme.of(context).colorScheme.primary,
                    amount: expense.other!,
                    icon: Icons.monetization_on,
                    bgcolor: Colors.green.shade100,
                    iconColor: Colors.green)
              ],
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

// bottomsheet
  addExpensesBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: StatefulBuilder(
                builder: (context, refresh) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Expense',
                            style: subTextStyle(
                                size: 25,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          OutlinedButton(
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(100)),
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                              onPressed: () {
                                _addToDatabase();
                              },
                              child: const Text('Add'))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Expense',
                        style: subTextStyle(
                            color: secondaryColor, weight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: CustomTextField(
                          controller: expenseController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is empty';
                            } else if (value.contains(RegExp(r'[a-z]'))) {
                              return 'only numbers allowed';
                            }
                            return null;
                          },
                          label: '',
                          inputType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Catagory',
                        style: subTextStyle(
                            color: secondaryColor, weight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // DropDownButton
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 54,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: secondaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<String>(
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_down_rounded,
                                size: 28),
                          ),
                          iconEnabledColor: secondaryColor,
                          isExpanded: true,
                          underline: Container(),
                          value: expenseType,
                          onChanged: (String? newValue) {
                            refresh(() {
                              expenseType = newValue!;
                            });
                          },
                          items: <String>['Food', 'Transport', 'Hotel', 'Other']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: secondaryColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 50)
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _addToDatabase() async {
    if (_formKey.currentState!.validate()) {
      //to get expense obj
      List<Expenses> expList =
          await DatabaseHelper.instance.getExpense(widget.trip.id!);

      int? expense = int.tryParse(expenseController.text.trim());

      // to update the seperate expense
      int updatedexp = expense ?? 0;
      if (expense == null) return;

      final type = expenseType.toLowerCase();
      final currentExp = expList[0];
      if (type == 'food') {
        updatedexp += currentExp.food!;
      } else if (type == 'transport') {
        updatedexp += currentExp.transport!;
      } else if (type == 'hotel') {
        updatedexp += currentExp.hotel!;
      } else if (type == 'other') {
        updatedexp += currentExp.other!;
      }
      // adding to database
      DatabaseHelper.instance.addExpences(
          balance: currentExp.balance!,
          expType: type,
          fieldExp: updatedexp,
          newExp: expense,
          oldExp: currentExp.totalexpense!,
          tripId: currentExp.tripId!);

      setState(() {
        expenseController.text = '';
      });

      Navigator.of(context).pop();
    }
    return;
  }

// to get the companion count
  Future<int> getCompanion() async {
    final companionList =
        await DatabaseHelper.instance.getAllCompanions(widget.trip.id!);
    final noOfCompanion = companionList.length;

    return noOfCompanion;
  }

//to calculate expense per person
  double calculateExpensePerPerson(int noOfCompanion) {
    final totalExpenses = expenseNotifier.value.isEmpty
        ? 0
        : expenseNotifier.value[0].totalexpense!;
    final numberOfCompanions = noOfCompanion + 1;
    return totalExpenses / numberOfCompanions;
  }
}
