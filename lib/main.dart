import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: Color.fromRGBO(22, 31, 66, 1),  // Subtle dark blue accent (RGB: 22, 31, 66)
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),  // Subtle text color
        ),
      ),
      home: DistanceCalculator(),
    );
  }
}

class DistanceCalculator extends StatefulWidget {
  @override
  _DistanceCalculatorState createState() => _DistanceCalculatorState();
}

class _DistanceCalculatorState extends State<DistanceCalculator> {
  TextEditingController speedController = TextEditingController();
  double recommendedDistance = 0.0;

  // Define the reaction time in seconds (could be customizable)
  final double reactionTime = 2.5;

  void calculateDistance() {
    double speed = double.tryParse(speedController.text) ?? 0;
    setState(() {
      recommendedDistance = speed * reactionTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Distance Project'),
        backgroundColor: Color.fromRGBO(22, 31, 66, 1),  // Dark blue AppBar (RGB: 22, 31, 66)
        elevation: 0,  // Clean with no shadow
      ),
      backgroundColor: Colors.grey[100],  // Light off-white background
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust TextField size for desktop
            double inputFontSize = constraints.maxWidth > 600 ? 16 : 18;  // Smaller font size for desktop
            double inputPadding = constraints.maxWidth > 600 ? 12 : 16;  // Less padding for desktop

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: speedController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black, fontSize: inputFontSize),  // Adjust font size
                  decoration: InputDecoration(
                    labelText: 'Enter Speed (km/h)',
                    labelStyle: TextStyle(color: Colors.grey[700]),  // Soft label
                    contentPadding: EdgeInsets.symmetric(vertical: inputPadding, horizontal: inputPadding),  // Adjust padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),  // Rounded corners for input
                      borderSide: BorderSide(color: Colors.grey[400]!),  // Soft border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color.fromRGBO(22, 31, 66, 1)),  // Focused border in dark blue
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: calculateDistance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(15, 19, 36, 1),  // Subtle dark blue button
                    foregroundColor: Color.fromRGBO(225, 231, 255, 1),  // White text for contrast
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),  // More rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),  // More padding for button
                    elevation: 0,  // No shadow
                  ),
                  child: Text('Calculate', style: TextStyle(fontSize: 18)),  // Larger text for button
                ),
                SizedBox(height: 30),
                Text(
                  'Recommended Distance: ${recommendedDistance.toStringAsFixed(2)} meters',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
