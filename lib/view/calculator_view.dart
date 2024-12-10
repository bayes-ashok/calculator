import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _textController = TextEditingController();
  final _historyController = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "/",
    "*",
    "<-",
    "1",
    "2",
    "3",
    "+",
    "4",
    "5",
    "6",
    "-",
    "7",
    "8",
    "9",
    "=",
    "%",
    "0",
    ".",
    "*"
  ];

  String displayText = "";
  String historyText = "";
  String operation = "";
  double? firstNumber;
  double? secondNumber;
  String temp = "";
  bool flag = false;

  String formatNumber(double number) {
    return number == number.toInt()
        ? number.toInt().toString()
        : number.toStringAsFixed(2);
  }

  void handleInput(String input) {
    setState(() {
      if (input == "C") {
        displayText = "";
        historyText = "";
        firstNumber = null;
        secondNumber = null;
        operation = "";
        temp = "";
        flag = false;
      } else if (input == "<-") {
        if (displayText.isNotEmpty) {
          displayText = displayText.substring(0, displayText.length - 1);
        }
      } else if (["+", "-", "*", "/", "%"].contains(input)) {
        if (displayText.isNotEmpty && operation.isEmpty) {
          firstNumber = double.tryParse(displayText);
          temp = displayText;
          operation = input;
          historyText = "${formatNumber(firstNumber!)} $input";
          displayText = temp;
          flag = true;
        }
      } else if (input == "=") {
        if (displayText.isNotEmpty &&
            firstNumber != null &&
            operation.isNotEmpty) {
          secondNumber = double.tryParse(displayText);
          if (secondNumber != null) {
            double result = 0.0;
            switch (operation) {
              case "+":
                result = firstNumber! + secondNumber!;
                break;
              case "-":
                result = firstNumber! - secondNumber!;
                break;
              case "*":
                result = firstNumber! * secondNumber!;
                break;
              case "/":
                result = secondNumber == 0
                    ? double.nan
                    : firstNumber! / secondNumber!;
                break;
              case "%":
                result = firstNumber! % secondNumber!;
                break;
            }
            displayText = formatNumber(result);
            historyText += " ${formatNumber(secondNumber!)} =";
            firstNumber = null;
            secondNumber = null;
            operation = "";
            temp = "";
            flag = false;
          }
        }
      } else {
        if (flag) {
          displayText = input;
          flag = false;
        } else {
          displayText += input;
        }
      }
      _historyController.text = historyText;
      _textController.text = displayText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ashok Calculator App',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _historyController,
                    readOnly: true,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                  ),
                  TextField(
                    controller: _textController,
                    readOnly: true,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: lstSymbols.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      handleInput(lstSymbols[index]);
                    },
                    child: Text(
                      lstSymbols[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
