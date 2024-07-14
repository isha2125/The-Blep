import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../components/text_bubble.dart';

class MovingCharacter extends StatefulWidget {
  @override
  _MovingCharacterState createState() => _MovingCharacterState();
}

class _MovingCharacterState extends State<MovingCharacter> {
  double _xPosition = 0.0;
  double _yPosition = 0.0;
  double _speed = 50.0;
  Timer? _movementTimer;
  Timer? _pauseTimer;
  int _directionIndex = 0;
  bool _isPaused = false; // Flag to control pause state
  bool _showTextBubble = false; // Flag to control text bubble visibility
  String _currentSlang = ''; // Variable to hold current slang text

  List<String> _slangs = [
    'Hi sup?',
    'Dang you look fire.',
    'That\'s a sick choice!'
  ];

  List<Offset> _directions = [
    Offset(50.0, 0.0), // Right
    Offset(0.0, -50.0), // Up
    Offset(-50.0, 0.0), // Left
    Offset(0.0, 50.0), // Down
  ];

  @override
  void initState() {
    super.initState();
    // Initialize character position and start movement after the widget is built
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeCharacterPosition();
      _startMoving();
    });
  }

  void _initializeCharacterPosition() {
    // Get screen size to determine initial position
    final size = MediaQuery.of(context).size;
    final characterSize = 50.0;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    setState(() {
      _yPosition = size.height - characterSize - bottomNavBarHeight;
    });
  }

  void _startMoving() {
    // Start timer to move the character every 500 milliseconds
    _movementTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!_isPaused) {
        setState(() {
          _moveCharacter();
        });
      }
    });

    // Start timer to pause the movement every 15 seconds
    _pauseTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _pauseMovement();
    });
  }

  void _moveCharacter() {
    // Move character based on current direction index
    final size = MediaQuery.of(context).size;
    final characterSize = 100;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    // Calculate new position
    double newXPosition = _xPosition + _directions[_directionIndex].dx;
    double newYPosition = _yPosition + _directions[_directionIndex].dy;

    // Clamp new position within screen boundaries
    if (newXPosition < 0) {
      newXPosition = 0;
      _directionIndex = (_directionIndex + 1) % _directions.length;
    } else if (newXPosition > size.width - characterSize) {
      newXPosition = size.width - characterSize;
      _directionIndex = (_directionIndex + 1) % _directions.length;
    }

    if (newYPosition < 0) {
      newYPosition = 0;
      _directionIndex = (_directionIndex + 1) % _directions.length;
    } else if (newYPosition >
        size.height - characterSize - bottomNavBarHeight) {
      newYPosition = size.height - characterSize - bottomNavBarHeight;
      _directionIndex = (_directionIndex + 1) % _directions.length;
    }

    // Update position
    setState(() {
      _xPosition = newXPosition;
      _yPosition = newYPosition;
    });
  }

  void _pauseMovement() {
    // Pause movement for a random duration between 1 to 6 seconds
    Duration randomDuration = Duration(seconds: Random().nextInt(6) + 1);

    setState(() {
      _isPaused = true;
      _showTextBubble = true;
      _currentSlang =
          _slangs[Random().nextInt(_slangs.length)]; // Select random slang
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
    _movementTimer?.cancel(); // Clean up movement timer
    _pauseTimer?.cancel(); // Clean up pause timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _togglePause(); // Toggle pause state when pet is tapped
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            left: _xPosition,
            top: _yPosition,
            child: Image.asset(
              'assets/pet.png',
              fit: BoxFit.cover, // Use BoxFit.cover to fill the container
            ),
          ),
          if (_showTextBubble) // Show text bubble if _showTextBubble is true
            Positioned(
              left: max(
                  min(_xPosition - 30.0,
                      MediaQuery.of(context).size.width - 150.0),
                  0.0), // Adjust positioning relative to character
              top: max(_yPosition - 80.0, 0.0),
              child:
                  TextBubble(slang: _currentSlang), // Pass current slang text
            ),
        ],
      ),
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _currentSlang = 'oppsiesssss'; // Set specific slang when paused
        _showTextBubble = true; // Show text bubble when paused
      } else {
        _showTextBubble = false; // Hide text bubble when resumed
      }
    });
  }
}
