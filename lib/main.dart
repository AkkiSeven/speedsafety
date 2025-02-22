import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

class _DistanceCalculatorState extends State<DistanceCalculator>
    with TickerProviderStateMixin {
  double _speed = 0; // Private variable for the slider's current value
  double speed = 0; // Public variable for the displayed speed and calculations
  final double reactionTime = 2.5; // Reaction time in seconds
  final double deceleration = 2.0; // Deceleration in m/s^2

  double get recommendedDistance {
    // Convert speed from km/h to m/s
    double speedMs = speed * (5 / 18);

    // Calculate reaction distance
    double reactionDistance = speedMs * reactionTime;

    // Calculate braking distance
    double brakingDistance = (speedMs * speedMs) / (2 * deceleration);

    // Calculate total stopping distance
    double totalDistance = reactionDistance + brakingDistance;
    return totalDistance;
  }

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _roadLineController;
  late Animation<double> _roadLineAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _shakeAnimation =
        Tween<double>(begin: -0.01, end: 0.01).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
    _shakeController.repeat(reverse: true);

    _roadLineController = AnimationController(
      duration: const Duration(seconds: 2), // Adjust duration for speed
      vsync: this,
    );
    _roadLineAnimation = Tween<double>(begin: 0, end: 1).animate(_roadLineController)
      ..addListener(() {
        setState(() {}); // Trigger rebuild on animation tick
      });

    _startStopRoadLineAnimation();
  }

  void _startStopRoadLineAnimation() {
    if (speed > 0) {
      // Adjust the animation duration based on speed
      final animationDuration = 2 - (speed / 200) * 1.5; // Example: Reduce duration from 2s to 0.5s
      _roadLineController.duration = Duration(milliseconds: (animationDuration * 1000).toInt());
      _roadLineController.repeat();
    } else {
      _roadLineController.stop();
    }
  }

  @override
  void didUpdateWidget(covariant DistanceCalculator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (speed != (oldWidget.key as ValueKey<double>?)?.value) {
      _startStopRoadLineAnimation();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _roadLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Convert speed from km/h to m/s
    double speedMs = speed * (5 / 18);

    // Calculate reaction distance
    double reactionDistance = speedMs * reactionTime;

    // Calculate braking distance
    double brakingDistance = (speedMs * speedMs) / (2 * deceleration);

    // Calculate total stopping distance
    double totalDistance = reactionDistance + brakingDistance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Safe Distance Project'),
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
                        value: _speed, // Use _speed for the slider's value
                        min: 0,
                        max: 200,
                        onChanged: (value) {
                          setState(() {
                            _speed = value; // Update _speed while dragging
                          });
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            speed = value; // Update speed only when released
                            _startStopRoadLineAnimation(); // Update animation
                          });
                        },
                        activeColor: const Color.fromRGBO(22, 31, 66, 1),
                        inactiveColor: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_speed.toStringAsFixed(0)} km/h', // Display _speed while dragging
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Box with car in the middle AND Recommended Safe Distance Display
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Recommended Safe Distance:',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${recommendedDistance.toStringAsFixed(2)} meters',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
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
                        clipBehavior: Clip.none,
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
                          // Back Car (Black) - now animated
                          Positioned(
                            bottom: 100,
                            child: SvgPicture.asset(
                              'media/car.svg',
                              height: 80,
                              width: 80,
                              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                            ),
                          ),
                          // Front Car (Dark Blue) - now animated
                          Positioned(
                            top: 100,
                            child: SvgPicture.asset(
                              'media/car.svg',
                              height: 80,
                              width: 80,
                              colorFilter: const ColorFilter.mode(Colors.indigo, BlendMode.srcIn)
                            ),
                          ),
                          // Text Box in the Middle with Arrows
                          Positioned(
                            top: 300,
                            child: Column(
                              children: [const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.black,
                                    size: 30, // Adjust size as needed
                                  ),
                                Container(
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
                                const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.black,
                                    size: 30, // Adjust size as needed
                                  ),
                              ],
                            ),
                          ),
                          // Math Display (Top Left)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Speed: ${speed.toStringAsFixed(2)} km/h',
                                  style: const TextStyle(fontSize: 15, color: Colors.black),
                                ),
                                Text(
                                  'Reaction Time: ${reactionTime.toStringAsFixed(2)} s',
                                  style: const TextStyle(fontSize: 15, color: Colors.black),
                                ),
                                Text(
                                  'Deceleration: ${deceleration.toStringAsFixed(2)} m/s²',
                                  style: const TextStyle(fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          // Analog Speedometer in the bottom right corner
                          Positioned(
                            bottom: 300, // move down
                            right: 950, // move right
                            child: SizedBox(
                              width: 150, // increase size to 150
                              height: 150,
                              child: AnalogSpeedometer(
                                  speed: speed,
                                  shakeAnimation: _shakeAnimation),
                            ),
                          ),
                          // Road Lines
                          AnimatedBuilder(
                            animation: _roadLineAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: RoadLinePainter(
                                  animationValue: _roadLineAnimation.value,
                                  speed: speed,
                                ),
                                size: const Size(220, double.infinity), // Road width and height
                              );
                            },
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

class RoadLinePainter extends CustomPainter {
  final double animationValue;
  final double speed;

  RoadLinePainter({required this.animationValue, required this.speed});

  @override
  void paint(Canvas canvas, Size size) {
    final roadWidth = size.width;
    final roadHeight = size.height;
    const lineHeight = 20.0; // Height of each line
    const lineSpacing = 80.0; // Spacing between lines
    final lineYOffset = animationValue * lineSpacing; // Animated offset

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw lines on the left and right sides of the road
    for (double y = lineYOffset; y < roadHeight; y += lineSpacing) {
      // Left side
      canvas.drawRect(
        Rect.fromLTWH(
          roadWidth * 0.15, // Adjust horizontal position
          y % roadHeight,
          5, // Line width
          lineHeight,
        ),
        paint,
      );

      // Right side
      canvas.drawRect(
        Rect.fromLTWH(
          roadWidth * 0.8, // Adjust horizontal position
          y % roadHeight,
          5, // Line width
          lineHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RoadLinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.speed != speed;
  }
}

class AnalogSpeedometer extends StatelessWidget {
  final double speed;
  final Animation<double> shakeAnimation;
  const AnalogSpeedometer(
      {super.key, required this.speed, required this.shakeAnimation});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: speed > 0
              ? shakeAnimation.value
              : 0, // Apply rotation only if speed > 0
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
    final angle = lerpDouble(225, -45, speed / 200) * pi / 180;
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
      final angle =
          lerpDouble(225, -45, i / divisions) * pi / 180; // Degrees to radians
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textCenter = Offset(
        center.dx +
            (radius * 0.8) * cos(-angle) -
            textPainter.width / 2, // Adjust the radius fraction for positioning
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