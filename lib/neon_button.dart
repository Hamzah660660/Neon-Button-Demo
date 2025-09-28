
import 'dart:math';

import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final Color neonColor;
  final int sparkCount;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback? onPressed;
  final BorderRadius borderRadius;
  final Duration glowDuration;
  final Duration tapDuration;

  const NeonButton({
    super.key,
    required this.text,
    this.neonColor = const Color(0xFF00FFFF),
    this.sparkCount = 50,
    this.width = 260,
    this.height = 75,
    this.fontSize = 22,
    this.onPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.glowDuration = const Duration(seconds: 1),
    this.tapDuration = const Duration(milliseconds: 400),
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _tapController;
  late List<Spark> sparks;
  String buttonText = '';
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    buttonText = widget.text;
    _generateSparks();

    _glowController = AnimationController(
      duration: widget.glowDuration,
      vsync: this,
    )..repeat();

    _tapController = AnimationController(
      duration: widget.tapDuration,
      vsync: this,
    );
  }

  void _generateSparks() {
    final random = Random();
    sparks = List.generate(widget.sparkCount, (_) {
      return Spark(
        position: Offset(random.nextDouble(), random.nextDouble()),
        direction: Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5),
        radius: 2 + random.nextDouble() * 2,
      );
    });
  }

  void _handleTap() {
    _tapController.forward(from: 0);

    for (var spark in sparks) {
      spark.randomizeDirection();
    }

    setState(() {
      clicked = true;
      buttonText = "CLICKED!";
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          clicked = false;
          buttonText = widget.text;
        });
      }
    });

    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _tapController]),
      builder: (context, child) {
        final double glow = 0.6 + (_glowController.value * 0.4);
        final double tapScale = 1.0 + (1.0 - _tapController.value) * 0.05;

        for (var spark in sparks) {
          spark.update();
        }

        return GestureDetector(
          onTap: _handleTap,
          child: Transform.scale(
            scale: tapScale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: clicked
                        ? widget.neonColor.withOpacity(1.0)
                        : widget.neonColor.withOpacity(0.7),
                    blurRadius: clicked ? 50 : 35 * glow,
                    spreadRadius: clicked ? 6 : 2,
                  ),
                ],
              ),
              child: CustomPaint(
                size: Size(widget.width, widget.height),
                painter: SparkPainter(
                  color: widget.neonColor,
                  intensity: glow,
                  sparks: sparks,
                  area: Size(widget.width, widget.height),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: widget.borderRadius),
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.width * 0.15,
                        vertical: widget.height * 0.3),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.neonColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 30,
                          color: widget.neonColor,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SparkPainter extends CustomPainter {  final Color color;
  final double intensity;
  final List<Spark> sparks;
  final Size area;

  SparkPainter({
    required this.color,
    required this.intensity,
    required this.sparks,
    required this.area,
  });
//JDSLAJD
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(intensity * 0.5)
      ..style = PaintingStyle.fill;

    for (var spark in sparks) {
      final Offset pos = Offset(spark.position.dx * area.width,
          spark.position.dy * area.height);
      canvas.drawCircle(pos, spark.radius * intensity, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Spark {
  Offset position;
  Offset direction;
  double radius;
  final Random _random = Random();

  Spark({required this.position, required this.direction, required this.radius});

  void update() {
    position += direction * 0.01;
    if (position.dx < 0 || position.dx > 1) {
      direction = Offset(-direction.dx, direction.dy);
    }
    if (position.dy < 0 || position.dy > 1) {
      direction = Offset(direction.dx, -direction.dy);
    }
  }

  void randomizeDirection() {
    direction = Offset(_random.nextDouble() - 0.5, _random.nextDouble() - 0.5);
  }
}