import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        hintColor: const Color.fromRGBO(22, 31, 66, 1),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const DistanceCalculator(),
    );
  }
}

class DistanceCalculator extends StatefulWidget {
  const DistanceCalculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        title: const Text('Recommended Distance Project'),
        backgroundColor: const Color.fromRGBO(22, 31, 66, 1),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Larger vertical slider on the left
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                        activeColor: const Color.fromRGBO(22, 31, 66, 1),
                        inactiveColor: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${speed.toStringAsFixed(0)} km/h',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),

            // Box with car in the middle AND Recommended Distance Display
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Recommended Distance:',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${recommendedDistance.toStringAsFixed(2)} meters',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Vertical Light Gray Road
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 175,
                              height: double.infinity,
                              color: Colors.grey[400],
                            ),
                          ),

                           // Arrow from Front Car (Dark Blue)
                          Positioned(
                            top: 250, // Below the car
                            left: 425,
                            child: Transform.rotate( // added Transform.rotate
                              angle: 3.5*3.14159265, // added rotation
                              child: Icon(Icons.arrow_forward, color: Colors.indigo[700], size: 30), //changed to arrow_forward
                            ),
                          ),

                          // Text Box in the Middle
                          Positioned(
                            top: 300,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                '${recommendedDistance.toStringAsFixed(2)} meters',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          // Arrow from Bottom Car (Black)
                          Positioned(
                            bottom: 250, // Above the car
                            left: 425,
                            child: Transform.rotate(
                              angle: 3.5*3.14159265,
                              child: Icon(Icons.arrow_back, color: Colors.black, size: 30), // 
                            ),
                          ),
                          // Back Car (Black)
                          Positioned(
                            bottom: 100,
                            child: SvgPicture.asset(
                              'media/car.svg',
                              height: 80,
                              width: 80,
                              color: Colors.black,
                            ),
                          ),

                          // Front Car (Dark Blue)
                          Positioned(
                            top: 100,
                            child: SvgPicture.asset(
                              'media/car.svg',
                              height: 80,
                              width: 80,
                              color: Colors.indigo[700],
                            ),
                          ),

                        ],
                      ),
                    ),
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