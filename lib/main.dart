import 'dart:math';
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

class _DistanceCalculatorState extends State<DistanceCalculator> with TickerProviderStateMixin { // Needed for AnimationController
  double speed = 0;
  final double reactionTime = 2.5;

  double get recommendedDistance => speed * reactionTime;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 200), // Quick shake
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: -0.01, end: 0.01).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _shakeController.repeat(reverse: true); // Repeat animation indefinitely
  }

  @override
  void dispose() {
    _shakeController.dispose(); // Important to dispose of AnimationController
    super.dispose();
  }


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
                        clipBehavior: Clip.none, // Add this line to prevent clipping
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
                              angle: 0.5*3.14159265, // added rotation
                              child: Container( // Increased the arrow size
                                width: 75,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.indigo[700],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
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
                              angle: 2.5*3.14159265,
                              child: Container( // Increased the arrow size
                                width: 75,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
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
                             // Analog Speedometer in the bottom right corner
                          Positioned(
                            bottom: 30, // move down
                            right: 30, // move right
                            child: SizedBox(
                              width: 150, // increase size to 150
                              height: 150,
                              child: AnalogSpeedometer(speed: speed, shakeAnimation: _shakeAnimation),
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

class AnalogSpeedometer extends StatelessWidget {
  final double speed;
  final Animation<double> shakeAnimation;

  const AnalogSpeedometer({Key? key, required this.speed, required this.shakeAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: speed > 0 ? shakeAnimation.value : 0, // Apply rotation only if speed > 0
          child: CustomPaint(
            painter: SpeedometerPainter(speed: speed),
          ),
        );
      },
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double speed;

  SpeedometerPainter({required this.speed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Draw speedometer outline
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, paint);

    // Draw speedometer needle
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.butt;

    // Map speed (0-200) to angle (225 degrees to -45 degrees) for 0 at bottom
    final angle = lerpDouble(225, -45, speed / 200)! * pi / 180;
    final needleLength = radius * 0.75; // Reduced length to 75% of the radius
    final needleEnd = Offset(
      center.dx + needleLength * cos(-angle),
      center.dy + needleLength * sin(-angle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center dot
    final centerDotPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 5, centerDotPaint);

    // Draw number indicators
    const int divisions = 10;
    for (int i = 0; i <= divisions; i++) {
      final value = i * 20; // Speedometer values from 0 to 200
      final angle = lerpDouble(225, -45, i / divisions)! * pi / 180; // Degrees to radians

      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textCenter = Offset(
        center.dx + (radius * 0.8) * cos(-angle) - textPainter.width / 2, // Adjust the radius fraction for positioning
        center.dy + (radius * 0.8) * sin(-angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textCenter);
    }
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed;
  }

  double lerpDouble(num a, num b, double t) {
    return a + (b - a) * t;
  }
}