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
    final characterSize = 50.0;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    _xPosition += _directions[_directionIndex].dx;
    _yPosition += _directions[_directionIndex].dy;

    // Handle screen boundaries to prevent character from going off-screen
    if (_xPosition >= size.width - characterSize && _directionIndex == 0) {
      _xPosition = size.width - characterSize;
      _directionIndex = 1;
    } else if (_yPosition <= 0 && _directionIndex == 1) {
      _yPosition = 0;
      _directionIndex = 2;
    } else if (_xPosition <= 0 && _directionIndex == 2) {
      _xPosition = 0;
      _directionIndex = 3;
    } else if (_yPosition >= size.height - characterSize - bottomNavBarHeight &&
        _directionIndex == 3) {
      _yPosition = size.height - characterSize - bottomNavBarHeight;
      _directionIndex = 0;
    }
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
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  '🐾',
                  style: TextStyle(fontSize: 24),
                ),
              ),
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
