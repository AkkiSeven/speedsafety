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
        hintColor: Color.fromRGBO(22, 31, 66, 1), // Subtle dark blue accent (RGB: 22, 31, 66)
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Subtle text color
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
  double speed = 0;
  final double reactionTime = 2.5;

  double get recommendedDistance => speed * reactionTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Distance Project'),
        backgroundColor: Color.fromRGBO(22, 31, 66, 1), // Dark blue AppBar (RGB: 22, 31, 66)
        elevation: 0, // Clean with no shadow
      ),
      backgroundColor: Colors.grey[100], // Light off-white background
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Larger vertical slider on the left
            Container(
              width: MediaQuery.of(context).size.width * 0.35, // Increased width
              padding: EdgeInsets.symmetric(vertical: 20.0), // Increased height
              child: Column(
                children: [
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        value: speed,
                        min: 0,
                        max: 200,
                        onChanged: (value) {
                          setState(() {
                            speed = value;
                          });
                        },
                        activeColor: Color.fromRGBO(22, 31, 66, 1), // Accent color
                        inactiveColor: Colors.grey[400],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${speed.toStringAsFixed(0)} km/h',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(width: 40),
            // Recommended distance display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Recommended Distance:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${recommendedDistance.toStringAsFixed(2)} meters',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}