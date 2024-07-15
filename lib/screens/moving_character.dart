import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../components/text_bubble.dart';
import '../service/slang.dart';

class MovingCharacter extends StatefulWidget {
  @override
  _MovingCharacterState createState() => _MovingCharacterState();
}

class _MovingCharacterState extends State<MovingCharacter>
    with SingleTickerProviderStateMixin {
  double _xPosition = 0.0;
  double _yPosition = 0.0;
  double _speed = 50.0;
  Timer? _movementTimer;
  Timer? _pauseTimer;
  int _directionIndex = 0;
  bool _isPaused = false;
  bool _showTextBubble = false;
  double _rotationAngle = 0.0;
  String _currentSlang = '';

  List<Offset> _directions = [
    Offset(50.0, 0.0), // Right
    Offset(0.0, -50.0), // Up
    Offset(-50.0, 0.0), // Left
    Offset(0.0, 50.0), // Down
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCharacterPosition();
      _startMoving();
    });
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10.0, end: 10.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _initializeCharacterPosition() {
    final size = MediaQuery.of(context).size;
    final characterSize = 50.0;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    setState(() {
      _yPosition = size.height - characterSize - bottomNavBarHeight;
    });
  }

  void _startMoving() {
    _movementTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!_isPaused) {
        setState(() {
          _moveCharacter();
        });
      }
    });

    _pauseTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _pauseMovement();
    });
  }

  void _moveCharacter() {
    final size = MediaQuery.of(context).size;
    final characterSize = 100;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    double newXPosition = _xPosition + _directions[_directionIndex].dx;
    double newYPosition = _yPosition + _directions[_directionIndex].dy;

    if (newXPosition < 0) {
      newXPosition = 0;
      _directionIndex = (_directionIndex + 1) % _directions.length;
      _updateRotationAngle();
    } else if (newXPosition > size.width - characterSize) {
      newXPosition = size.width - characterSize;
      _directionIndex = (_directionIndex + 1) % _directions.length;
      _updateRotationAngle();
    }

    if (newYPosition < 0) {
      newYPosition = 0;
      _directionIndex = (_directionIndex + 1) % _directions.length;
      _updateRotationAngle();
    } else if (newYPosition >
        size.height - characterSize - bottomNavBarHeight) {
      newYPosition = size.height - characterSize - bottomNavBarHeight;
      _directionIndex = (_directionIndex + 1) % _directions.length;
      _updateRotationAngle();
    }

    setState(() {
      _xPosition = newXPosition;
      _yPosition = newYPosition;
    });
  }

  void _updateRotationAngle() {
    setState(() {
      _rotationAngle -= pi / 2;
      if (_rotationAngle >= 2 * pi) {
        _rotationAngle = 0;
      }
    });
  }

  void _pauseMovement() async {
    Duration randomDuration = Duration(seconds: Random().nextInt(6) + 1);

    setState(() {
      _isPaused = true;
      _showTextBubble = true;
      _currentSlang = SlangProvider().getRandomSlang(); // Fetch random slang
    });

    Timer(randomDuration, () {
      if (mounted) {
        setState(() {
          _isPaused = false;
          _showTextBubble = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _pauseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _togglePause();
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            left: _xPosition,
            top: _yPosition,
            child: Transform.rotate(
              angle: _rotationAngle,
              child: Transform.translate(
                offset: Offset(_animation.value, 0),
                child: Image.asset(
                  'assets/pet.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (_showTextBubble)
            Positioned(
              left: _calculateTextBubbleLeft(),
              top: _calculateTextBubbleTop(),
              child: TextBubble(slang: _currentSlang), // Pass selected slang
            ),
        ],
      ),
    );
  }

  double _calculateTextBubbleLeft() {
    final size = MediaQuery.of(context).size;
    final characterSize = 100.0;
    final textBubbleWidth = 150.0;

    if (_xPosition + characterSize / 2 < size.width / 2) {
      // Pet is on the left half of the screen
      return min(_xPosition + characterSize, size.width - textBubbleWidth);
    } else {
      // Pet is on the right half of the screen
      return max(_xPosition - textBubbleWidth, 0);
    }
  }

  double _calculateTextBubbleTop() {
    final size = MediaQuery.of(context).size;
    final characterSize = 100.0;
    final textBubbleHeight = 50.0;

    if (_yPosition + characterSize / 2 < size.height / 2) {
      // Pet is on the top half of the screen
      return min(_yPosition + characterSize, size.height - textBubbleHeight);
    } else {
      // Pet is on the bottom half of the screen
      return max(_yPosition - textBubbleHeight, 0);
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _showTextBubble = true;
        _currentSlang = SlangProvider().getRandomSlang(); // Fetch random slang
      } else {
        _showTextBubble = false;
      }
    });
  }
}
