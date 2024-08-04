import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/timer_screen.dart';

void main() => runApp(StopwatchTimerApp());

class StopwatchTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch & Timer',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.orangeAccent,
        ),
        textTheme: TextTheme(
          // No text styles defined here, applying directly to widgets
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Background color
            foregroundColor: Colors.tealAccent, // Text color
            side: BorderSide(color: Colors.tealAccent, width: 2), // Border color and width
            textStyle: _customTextStyle(16.0),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.tealAccent, width: 2), // Border color and width
            foregroundColor: Colors.tealAccent, // Text color
            textStyle: _customTextStyle(16.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.tealAccent, // Text color
            textStyle: _customTextStyle(16.0),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.tealAccent, // Icon color
          size: 24, // Icon size
        ),
      ),
      home: HomeScreen(),
    );
  }

  TextStyle _customTextStyle(double fontSize) {
    return GoogleFonts.ubuntu(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.tealAccent,
      shadows: [
        Shadow(
          blurRadius: 15.0, // Increased blur for a stronger glow effect
          color: Colors.tealAccent,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    StopwatchScreen(),
    TimerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Stopwatch & Timer',
            style: _customTextStyle(24.0),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_bottom),
            label: 'Timer',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  TextStyle _customTextStyle(double fontSize) {
    return GoogleFonts.ubuntu(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.tealAccent,
      shadows: [
        Shadow(
          blurRadius: 15.0, // Increased blur for a stronger glow effect
          color: Colors.tealAccent,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
}
