import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme') ?? 'default';
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoodModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel(initialTheme: savedTheme)),
      ],
      child: MyApp(),
    ),
  );
}

class ThemeModel with ChangeNotifier {
  String _currentTheme = 'default';
  late SharedPreferences _prefs;

  ThemeModel({String initialTheme = 'default'}) {
    _currentTheme = initialTheme;
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case 'dark':
        return _darkTheme;
      case 'pastel':
        return _pastelTheme;
      default:
        return _defaultTheme;
    }
  }

  Color getMoodBackgroundColor(String mood) {
    switch (mood) {
      case 'happy': 
        return _currentTheme == 'dark' ? Colors.yellow.shade900.withOpacity(0.3) : 
               _currentTheme == 'pastel' ? Color(0xFFFFF9C4) : Colors.yellow.shade100;
      case 'sad': 
        return _currentTheme == 'dark' ? Colors.blue.shade900.withOpacity(0.3) : 
               _currentTheme == 'pastel' ? Color(0xFFB3E5FC) : Colors.blue.shade100;
      case 'excited': 
        return _currentTheme == 'dark' ? Colors.orange.shade900.withOpacity(0.3) : 
               _currentTheme == 'pastel' ? Color(0xFFFFCCBC) : Colors.orange.shade100;
      case 'surprise': 
        return _currentTheme == 'dark' ? Colors.purple.shade900.withOpacity(0.3) : 
               _currentTheme == 'pastel' ? Color(0xFFE1BEE7) : Colors.purple.shade100;
      default: 
        return _currentTheme == 'dark' ? Color(0xFF121212) : 
               _currentTheme == 'pastel' ? Color(0xFFF8F6F0) : Colors.white;
    }
  }

  Color getButtonColor(String mood) {
    switch (mood) {
      case 'happy': return _currentTheme == 'dark' ? Colors.yellow.shade600 : Colors.yellow.shade700;
      case 'sad': return _currentTheme == 'dark' ? Colors.blue.shade600 : Colors.blue.shade700;
      case 'excited': return _currentTheme == 'dark' ? Colors.orange.shade600 : Colors.orange.shade700;
      case 'surprise': return _currentTheme == 'dark' ? Colors.purple.shade600 : Colors.purple.shade700;
      default: return Colors.grey;
    }
  }

  Color getScaffoldBackgroundColor() {
    switch (_currentTheme) {
      case 'dark': return Color(0xFF121212);
      case 'pastel': return Color(0xFFF8F6F0);
      default: return Colors.white;
    }
  }

  Color getTextColor() {
    switch (_currentTheme) {
      case 'dark': return Colors.white;
      case 'pastel': return Color(0xFF5D4037);
      default: return Colors.black87;
    }
  }

  Color getCardColor() {
    switch (_currentTheme) {
      case 'dark': return Color(0xFF1E1E1E);
      case 'pastel': return Colors.white;
      default: return Colors.white;
    }
  }

  void setDefaultTheme() {
    _currentTheme = 'default';
    _saveThemePreference();
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = 'dark';
    _saveThemePreference();
    notifyListeners();
  }

  void setPastelTheme() {
    _currentTheme = 'pastel';
    _saveThemePreference();
    notifyListeners();
  }

  void _saveThemePreference() {
    _prefs.setString('theme', _currentTheme);
  }

  static final ThemeData _defaultTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
  );

  static final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
  );

  static final ThemeData _pastelTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF8F6F0),
  );
}

class MoodModel with ChangeNotifier {
  String _currentMood = 'happy';
  Color _backgroundColor = Colors.yellow.shade100;
  final Map<String, int> _moodCounts = {'happy': 0, 'sad': 0, 'excited': 0, 'surprise': 0};
  final List<String> _moodHistory = [];

  String get currentMood => _currentMood;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get moodCounts => Map.from(_moodCounts);
  List<String> get moodHistory => List.from(_moodHistory);

  // Method to get image path for each mood
  String getMoodImagePath(String mood) {
    switch (mood) {
      case 'happy': return 'assets/happy.png';
      case 'sad': return 'assets/sad.png';
      case 'excited': return 'assets/excited.png';
      case 'surprise': return 'assets/surprise.png';
      default: return 'assets/happy.png';
    }
  }

  // Emoji text for all other places
  String getMoodEmojiText(String mood) {
    switch (mood) {
      case 'happy': return '😊';
      case 'sad': return '😢';
      case 'excited': return '🎉';
      case 'surprise': return '🤪';
      default: return '😊';
    }
  }

  void _updateBackgroundColor(String mood) {
    switch (mood) {
      case 'happy': _backgroundColor = Colors.yellow.shade100; break;
      case 'sad': _backgroundColor = Colors.blue.shade100; break;
      case 'excited': _backgroundColor = Colors.orange.shade100; break;
      case 'surprise': _backgroundColor = Colors.purple.shade100; break;
    }
  }

  void setHappy() {
    _currentMood = 'happy';
    _updateBackgroundColor('happy');
    _moodCounts['happy'] = _moodCounts['happy']! + 1;
    _updateHistory('happy');
    notifyListeners();
  }

  void setSad() {
    _currentMood = 'sad';
    _updateBackgroundColor('sad');
    _moodCounts['sad'] = _moodCounts['sad']! + 1;
    _updateHistory('sad');
    notifyListeners();
  }

  void setExcited() {
    _currentMood = 'excited';
    _updateBackgroundColor('excited');
    _moodCounts['excited'] = _moodCounts['excited']! + 1;
    _updateHistory('excited');
    notifyListeners();
  }

  void setRandomMood() {
    final random = Random();
    final moods = ['happy', 'sad', 'excited', 'surprise'];
    final randomNumber = random.nextInt(moods.length);
    final randomMood = moods[randomNumber];
    
    _currentMood = randomMood;
    _updateBackgroundColor(randomMood);
    _moodCounts[randomMood] = _moodCounts[randomMood]! + 1;
    _updateHistory(randomMood);
    notifyListeners();
  }

  void resetAll() {
    _currentMood = 'happy';
    _backgroundColor = Colors.yellow.shade100;
    _moodCounts.updateAll((key, value) => 0);
    _moodHistory.clear();
    notifyListeners();
  }

  void _updateHistory(String mood) {
    _moodHistory.insert(0, mood);
    if (_moodHistory.length > 3) {
      _moodHistory.removeLast();
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          title: 'Mood Toggle Challenge',
          theme: themeModel.themeData,
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<MoodModel, ThemeModel>(
      builder: (context, moodModel, themeModel, child) {
        return Scaffold(
          backgroundColor: moodModel.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Mood Tracker 😊',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.restart_alt, color: Colors.white),
                onPressed: () => _showResetDialog(context),
                tooltip: 'Reset All',
              ),
              IconButton(
                icon: Icon(Icons.color_lens, color: Colors.white),
                onPressed: () => _showThemeDialog(context),
                tooltip: 'Change Theme 🎨',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  
                  Consumer<ThemeModel>(
                    builder: (context, themeModel, child) {
                      return Text(
                        'How are you feeling? 🤔',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: themeModel.getTextColor(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  
                  // Only this container uses image and is rectangular
                  MoodDisplay(),
                  SizedBox(height: 40),
                  
                  // All other components use emojis
                  MoodButtons(),
                  SizedBox(height: 40),
                  
                  MoodCounterDisplay(),
                  SizedBox(height: 30),
                  
                  MoodHistoryDisplay(),
                  SizedBox(height: 30),
                  
                  _buildRandomMoodButton(context),
                  
                  SizedBox(height: 20),
                  
                  _buildResetButton(context),
                  
                  SizedBox(height: 20),
                  
                  _buildThemeIndicator(context),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRandomMoodButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Provider.of<MoodModel>(context, listen: false).setRandomMood();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8),
            Text(
              'Random Mood',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text('🎲', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return ElevatedButton.icon(
          onPressed: () => _showResetDialog(context),
          label: Text('Reset All'),
          icon: Text('🔄', style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        );
      },
    );
  }

  Widget _buildThemeIndicator(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: themeModel.getCardColor(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎨', style: TextStyle(fontSize: 14)),
              SizedBox(width: 8),
              Text(
                'Theme: ${themeModel.currentTheme.toUpperCase()}',
                style: TextStyle(
                  fontSize: 12,
                  color: themeModel.getTextColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeModel>(
          builder: (context, themeModel, child) {
            return AlertDialog(
              backgroundColor: themeModel.getCardColor(),
              title: Text(
                'Reset Everything? ⚠️',
                style: TextStyle(color: themeModel.getTextColor()),
              ),
              content: Text(
                'This will reset all mood counts, history, and current mood to default.',
                style: TextStyle(color: themeModel.getTextColor()),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel ❌', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<MoodModel>(context, listen: false).resetAll();
                    Navigator.of(context).pop();
                  },
                  child: Text('Reset 🔄', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeModel>(
          builder: (context, themeModel, child) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeModel.getCardColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose Theme 🎨',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeModel.getTextColor(),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildThemeOption(context, 'Default 🌟', 'default'),
                    _buildThemeOption(context, 'Dark 🌙', 'dark'),
                    _buildThemeOption(context, 'Pastel 🎨', 'pastel'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, String themeName) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        final isSelected = themeModel.currentTheme == themeName;
        return ListTile(
          leading: Text(_getThemeEmoji(themeName), style: TextStyle(fontSize: 20)),
          title: Text(
            title,
            style: TextStyle(
              color: themeModel.getTextColor(),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected ? Text('✅', style: TextStyle(fontSize: 16)) : null,
          onTap: () {
            switch (themeName) {
              case 'default': themeModel.setDefaultTheme(); break;
              case 'dark': themeModel.setDarkTheme(); break;
              case 'pastel': themeModel.setPastelTheme(); break;
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  String _getThemeEmoji(String themeName) {
    switch (themeName) {
      case 'default': return '🌟';
      case 'dark': return '🌙';
      case 'pastel': return '🎨';
      default: return '✨';
    }
  }
}

class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Consumer<ThemeModel>(
          builder: (context, themeModel, child) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeModel.getCardColor(),
                borderRadius: BorderRadius.circular(15), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                moodModel.getMoodImagePath(moodModel.currentMood),
                width: 200, 
                height: 200, 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 180,
                    height: 180,
                    child: Center(
                      child: Text(
                        moodModel.getMoodEmojiText(moodModel.currentMood),
                        style: TextStyle(fontSize: 80),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildMoodButton(
          context,
          'Happy 😊',
          Provider.of<MoodModel>(context, listen: false).setHappy,
        ),
        _buildMoodButton(
          context,
          'Sad 😢',
          Provider.of<MoodModel>(context, listen: false).setSad,
        ),
        _buildMoodButton(
          context,
          'Excited 🎉',
          Provider.of<MoodModel>(context, listen: false).setExcited,
        ),
      ],
    );
  }

  Widget _buildMoodButton(BuildContext context, String text, VoidCallback onPressed) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        final mood = _getMoodFromText(text);
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeModel.getButtonColor(mood),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: Text(text),
        );
      },
    );
  }

  String _getMoodFromText(String text) {
    if (text.contains('Happy')) return 'happy';
    if (text.contains('Sad')) return 'sad';
    if (text.contains('Excited')) return 'excited';
    return 'happy';
  }
}

class MoodCounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Consumer<ThemeModel>(
          builder: (context, themeModel, child) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeModel.getCardColor(),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Mood Statistics 📊',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeModel.getTextColor(),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCounterItem('😊', moodModel.moodCounts['happy']!, themeModel),
                      _buildCounterItem('😢', moodModel.moodCounts['sad']!, themeModel),
                      _buildCounterItem('🎉', moodModel.moodCounts['excited']!, themeModel),
                      _buildCounterItem('🤪', moodModel.moodCounts['surprise']!, themeModel),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterItem(String emoji, int count, ThemeModel themeModel) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
        SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeModel.getTextColor(),
          ),
        ),
      ],
    );
  }
}

class MoodHistoryDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Consumer<ThemeModel>(
          builder: (context, themeModel, child) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeModel.getCardColor(),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Recent Moods 📝',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeModel.getTextColor(),
                    ),
                  ),
                  SizedBox(height: 15),
                  moodModel.moodHistory.isEmpty
                      ? Text(
                          'No history yet 📭',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: themeModel.getTextColor().withOpacity(0.6),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: moodModel.moodHistory
                              .asMap()
                              .entries
                              .map((entry) => Column(
                                    children: [
                                      Text(
                                        '#${entry.key + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: themeModel.getTextColor().withOpacity(0.7),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        moodModel.getMoodEmojiText(entry.value),
                                        style: TextStyle(fontSize: 40),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}