import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:async';
import 'focus_session_log.dart';




final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FocusSessionLogAdapter());
  await Hive.openBox('userbox');
  // await Hive.box('userbox').clear();
  await Hive.openBox('taskbox');
  // await Hive.box('taskbox').clear();

  await Hive.openBox<FocusSessionLog>('sessionbox');
  runApp(const FocusBuddyApp());
}

// subject class banayi haii abb isske anadar subject name and topics honge
// Class = structure/blueprint batati hai ki object ke andar kya hoga.
//
// Object = us class ka actual instance.
//
// Constructor = object banate waqt usko initial data dene ka mechanism.
class Subject {
  String name;
  List<String> topics;
  Subject(this.name, this.topics); //constructor
}
enum Priority {
  high,
  medium,
  low,
}
enum TaskStatus {
  pending,
  inProgress,
  completed,
}
class Task {
  String id;
  String subject;
  String topic;
  String goal;
  DateTime deadline;
  Priority priority;
  int duration;
  TaskStatus status;
  DateTime createdAt;
  Task({
    required this.id,
    required this.subject,
    required this.topic,
    required this.goal,
    required this.deadline,
    required this.priority,
    required this.duration,
    required this.status,
    required this.createdAt,
  });
}
class FocusBuddyApp extends StatefulWidget {
  const FocusBuddyApp({super.key});
  @override
  State<FocusBuddyApp> createState() => _FocusBuddyAppState();
}

class _FocusBuddyAppState extends State<FocusBuddyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075985),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4FAFE),
      ),
      home: SplashScreen(),
    );
  }
}





// ...................................................SPLASHSCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 5),
          () {
        final box = Hive.box('userbox');

        final name = box.get('name');

        if (name == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      },
    );
  }

  // ---------- UI ----------
  Widget _buildLogo() {
    return SizedBox(
      height: 170,
      width: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // glowing blob behind the book
          Container(
            height: 120,
            width: 170,
            decoration: BoxDecoration(
              color: const Color(0x33FFFFFF),
              borderRadius: BorderRadius.circular(70),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33FFFFFF),
                  blurRadius: 40,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.menu_book_rounded,
            size: 90,
            color: Colors.white,
          ),
          // sparkles
          const Positioned(
            top: 4,
            right: 52,
            child: Icon(
              Icons.auto_awesome,
              size: 30,
              color: Color(0xFFFFE08A),
            ),
          ),
          const Positioned(
            top: 30,
            right: 26,
            child: Icon(
              Icons.auto_awesome,
              size: 16,
              color: Color(0xFFFFF1C2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBar() {
    return Container(
      height: 5,
      width: 120,
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.centerLeft,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Container(
            height: 5,
            width: 120 * value,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5BB2EC), Color(0xFF2B7FD0), Color(0xFF1D63B5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // waves at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 260,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(
                          color: const Color(0x33FFFFFF),
                          startFactor: 0.30,
                          endFactor: 0.12,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(
                          color: const Color(0x4D1D63B5),
                          startFactor: 0.55,
                          endFactor: 0.40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // center content with fade + scale animation
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.85 + (0.15 * value),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 20),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'FocusBuddy ',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Plan → Focus → Progress',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: Color(0xFFE3F2FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // loading bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Center(child: _buildLoadingBar()),
            ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  final double startFactor;
  final double endFactor;

  _WavePainter({
    required this.color,
    required this.startFactor,
    required this.endFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * startFactor)
      ..cubicTo(
        size.width * 0.30,
        size.height * (startFactor - 0.35),
        size.width * 0.60,
        size.height * (endFactor + 0.40),
        size.width,
        size.height * endFactor,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}










//
// .....................................................WELCOMESCREEN
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bgTop = Color(0xFFE3F2FC);
  static const Color _bgBottom = Color(0xFFF7FBFE);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);

  Widget _dot(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      height: 230,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // soft background blob
          Container(
            height: 210,
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0x66FFFFFF),
              borderRadius: BorderRadius.circular(110),
            ),
          ),

          // decorative dots
          Positioned(top: 20, left: 24, child: _dot(10, const Color(0x6638BDF8))),
          Positioned(top: 60, right: 10, child: _dot(8, const Color(0x6638BDF8))),
          Positioned(bottom: 30, right: 24, child: _dot(14, const Color(0x4D38BDF8))),
          Positioned(bottom: 50, left: 6, child: _dot(7, const Color(0x6638BDF8))),

          // book
          Container(
            height: 140,
            width: 170,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x401D4ED8),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              size: 90,
              color: Colors.white,
            ),
          ),

          // plant
          Positioned(
            left: 8,
            bottom: 18,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco_rounded,
                    size: 72, color: Color(0xFF22A06B)),
                Container(
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // clock
          Positioned(
            top: 6,
            right: 18,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBFDFF3), width: 2),
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: _primary,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIllustration(),
                          SizedBox(height: 28),
                          Text(
                            'FocusBuddy',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your study companion',
                            style: TextStyle(
                              fontSize: 18,
                              color: _textGrey,
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Plan → Focus → Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Plan your tasks, focus on what matters, and track your progress.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: _textGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InitialSetupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}











// .....................INITIALSETUPSCREEN
class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});
  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  int selectedDuration = 25;
  List<Subject> subjects = [];
  List<String> topics = [];


  final TextEditingController nameController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final box= Hive.box('userbox');
  @override
  void dispose() {
    // controllers ko dispose karna zaroori hai memory leak avoid karne ke liye
    nameController.dispose();
    hoursController.dispose();
    subjectController.dispose();
    topicController.dispose();
    super.dispose();
  }

  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bgTop = Color(0xFFF4F9FD);
  static const Color _bgBottom = Color(0xFFE3F0FA);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);
  static const Color _border = Color(0xFFD6E9F5);

  // ---------- UI HELPERS ----------
  Widget _label(String text, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: _primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint,
      {String? suffix, IconData? icon, Color fill = Colors.white}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGrey),
      suffixText: suffix,
      prefixIcon: icon == null ? null : Icon(icon, color: _textGrey),
      filled: true,
      fillColor: fill,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
    );
  }

  Widget _durationOption(int minutes) {
    final bool selected = selectedDuration == minutes;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDuration = minutes;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? _primary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? _primary : _border),
          ),
          child: Center(
            child: Text(
              '$minutes min',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : _textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topicChip(String topic, VoidCallback onDelete) {
    return Container(
      padding: const EdgeInsets.only(left: 14, top: 6, bottom: 6, right: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              topic,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _primary,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onDelete,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, size: 16, color: _textGrey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgTop,
      appBar: AppBar(
        backgroundColor: _bgTop,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _textDark,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's set up FocusBuddy",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tell us a bit about yourself to get started.',
                  style: TextStyle(fontSize: 15, color: _textGrey),
                ),
                SizedBox(height: 24),

                _label('Your Name', icon: Icons.person_outline),
                TextField(
                  controller: nameController,
                  decoration: _fieldDecoration('Enter your name'),
                ),
                SizedBox(height: 20),

                _label('How much do you want to study today?'),
                TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  decoration: _fieldDecoration(
                    'e.g. 2',
                    suffix: 'hr',
                    icon: Icons.access_time,
                  ),
                ),
                SizedBox(height: 20),

                _label('Preferred Focus Duration'),
                Row(
                  children: [
                    _durationOption(25),
                    const SizedBox(width: 10),
                    _durationOption(45),
                    const SizedBox(width: 10),
                    _durationOption(60),
                  ],
                ),
                SizedBox(height: 24),

                _label('Add Subjects & Topics', icon: Icons.menu_book_rounded),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: subjectController,
                        decoration: _fieldDecoration(
                          'Enter Subject',
                          fill: _bgTop,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: topicController,
                        decoration: _fieldDecoration(
                          'Enter Topic',
                          fill: _bgTop,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primary,
                            side: const BorderSide(color: _primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () {
                            if (topicController.text.isNotEmpty) {
                              setState(() {
                                topics.add(topicController.text);
                                topicController.clear();
                              });
                            }
                          },
                          label: Text('Add Topic'),
                        ),
                      ),

                      if (topics.isNotEmpty) ...[
                        SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(topics.length, (index) {
                            return _topicChip(topics[index], () {
                              setState(() {
                                topics.removeAt(index);
                              });
                            });
                          }),
                        ),
                      ],

                      SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0F2FE),
                            foregroundColor: _primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle_outline, size: 20),
                          onPressed: () {
                            if (subjectController.text.isNotEmpty && topics.isNotEmpty) {
                              // List<String>.from(topics) se NEW copy banti hai, taaki
                              // agla subject add karte waqt is subject ki topics
                              // change na ho (reference sharing avoid karne ke liye).
                              Subject newSubject = Subject(
                                subjectController.text,
                                List<String>.from(topics),
                              );

                              setState(() {
                                subjects.add(newSubject);
                                subjectController.clear();
                                topics = []; // reset taaki agla subject fresh list se shuru ho
                              });
                            }
                          },
                          label: Text('Save Subject'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                if (subjects.isNotEmpty) ...[
                  Text(
                    'Added Subjects',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border),
                        ),
                        child: ListTile(
                          leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6EBFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF4F63D8),
                              size: 22,
                            ),
                          ),
                          title: Text(
                            subject.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                          ),
                          subtitle: Text(
                            subject.topics.join(', '),
                            style: const TextStyle(color: _textGrey),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: Color(0xFFDC2626)),
                            onPressed: () {
                              setState(() {
                                subjects.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],

                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFB9D3E3),
                      disabledForegroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    // FIX: Ab navigation yahan hota hai — sirf jab kam se kam
                    // ek subject save ho chuka ho.
                    onPressed: subjects.isEmpty
                        ? null
                        : () {
                      box.put('name', nameController.text);
                      box.put('hours', hoursController.text);
                      box.put('duration',selectedDuration);
                      final subjectData = subjects.map((subject) {
                        return {
                          'name': subject.name,
                          'topics': subject.topics,
                        };
                      }).toList();
                      box.put('subjects', subjectData);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}








// ...............................HOMESCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bg = Color(0xFFF4F9FD);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);
  static const Color _lightBlue = Color(0xFFE8F5FC);
  static const Color _border = Color(0xFFD6E9F5);

  // ---------- UI HELPERS ----------
  Color _priorityColor(String priority) {
    if (priority == 'high') return const Color(0xFFDC2626);
    if (priority == 'medium') return const Color(0xFFEA580C);
    return const Color(0xFF16A34A);
  }

  Color _priorityBg(String priority) {
    if (priority == 'high') return const Color(0xFFFDE8E8);
    if (priority == 'medium') return const Color(0xFFFFEDD5);
    return const Color(0xFFDCFCE7);
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _chip(String text, Color bg, Color fg, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookIcon({double size = 56}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: const Color(0xFF4F63D8),
        size: size * 0.5,
      ),
    );
  }

  // ---------- "I'M STUCK" DIALOGS (same content as before) ----------
  void _showTipDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Got it"),
            ),
          ],
        );
      },
    );
  }

  void _showStuckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("I'm stuck 🤔"),
          content: const Text("what are you stuck with?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showTipDialog(
                  context,
                  "Try this 💡",
                  "Break the concept into a smaller part and spend "
                      "10 minutes reviewing the basics.",
                );
              },
              child: const Text("I don't understand the concept"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showTipDialog(
                  context,
                  "Start small 🚀",
                  "Write down the first small step you need to take. "
                      "Don't try to finish everything at once.",
                );
              },
              child: const Text("I don't know how to start"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showTipDialog(
                  context,
                  "Break it down 🧩",
                  "Break the task into a smaller 15–25 minute goal. "
                      "Focus only on that small part first.",
                );
              },
              child: const Text("This task feels too big"),
            ),
          ],
        );
      },
    );
  }

  // ---------- UI SECTIONS ----------
  Widget _buildHeader(dynamic name, dynamic focusCoins) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning 👋',
              style: TextStyle(fontSize: 16, color: _textGrey),
            ),
            const SizedBox(height: 4),
            Text(
              '${name ?? ''}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _lightBlue,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Text('🪙', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                '$focusCoins',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudyTaskScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Study Task',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildNextBestCard(dynamic task, String deadlineLabel) {
    final String priority = '${task['priority']}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF1F9FF), Color(0xFFDDF1FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14075985),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✨ Next Best Action',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bookIcon(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${task['subject']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${task['topic']}',
                      style: const TextStyle(fontSize: 15, color: _textGrey),
                    ),
                    Text(
                      '${task['goal']}',
                      style: const TextStyle(fontSize: 15, color: _textGrey),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time,
                                size: 18, color: _primary),
                            const SizedBox(width: 5),
                            Text(
                              '${task['duration']} min',
                              style: const TextStyle(
                                  fontSize: 14, color: _textDark),
                            ),
                          ],
                        ),
                        Text(
                          deadlineLabel,
                          style: const TextStyle(
                              fontSize: 14, color: _textDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: _border, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: _primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Deadline: ${_formatDate(task['deadline'])}',
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(fontSize: 14, color: _primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _chip(
                '${_capitalize(priority)} Priority',
                _priorityBg(priority),
                _priorityColor(priority),
                icon: Icons.error,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FocusSessionScreen(task: task),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 28),
              label: const Text(
                'Start Focus',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double completionPercentage) {
    final double value = (completionPercentage / 100).clamp(0.0, 1.0);

    String message;
    if (completionPercentage == 0) {
      message = "Let's get started!";
    } else if (completionPercentage >= 100) {
      message = 'All done for today! 🎉';
    } else {
      message = "You're doing great! Keep going!";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFFDCEBF5),
                    valueColor: const AlwaysStoppedAnimation(_primary),
                  ),
                ),
                Text(
                  '${completionPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Progress",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: _textGrey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFDCEBF5),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF0284C7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${completionPercentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStuckTile() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showStuckDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: _lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: const Row(
          children: [
            Text('💡', style: TextStyle(fontSize: 22)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "I'm Stuck",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: _textGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildOverdueBanner(int overdueCount) {
    return Row(
      children: [
        const Icon(Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B), size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$overdueCount tasks overdue hain.',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFC2610C),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(dynamic task) {
    final String priority = '${task['priority']}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bookIcon(size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${task['subject']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${task['topic']}',
                  style: const TextStyle(fontSize: 14, color: _textGrey),
                ),
                Text(
                  '${task['goal']}',
                  style: const TextStyle(fontSize: 13, color: _textGrey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 15, color: _textGrey),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Deadline: ${_formatDate(task['deadline'])}',
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(fontSize: 13, color: _textGrey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _chip(
                _capitalize(priority),
                _priorityBg(priority),
                _priorityColor(priority),
              ),
              const SizedBox(height: 6),
              _chip(
                _capitalize('${task['status']}'),
                const Color(0xFFDDEFFB),
                const Color(0xFF0369A1),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 16, color: _primary),
                  const SizedBox(width: 4),
                  Text(
                    '${task['duration']} min',
                    style: const TextStyle(fontSize: 13, color: _textGrey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ================= LOGIC (UNCHANGED) =================
    final box = Hive.box('userbox');
    final name = box.get('name');
    final focusCoins = box.get(
      'focusCoins',
      defaultValue: 0,
    );
    final taskBox = Hive.box('taskbox');
    final tasks = taskBox.values.toList();
    final totalTasks = tasks.length;

    final completedTasks = tasks.where(
          (task) => task['status'] == 'completed',
    ).length;
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final completedToday = tasks.where((task) {
      if (task['status'] != 'completed') {
        return false;
      }

      final completedAt = task['completedAt'];

      if (completedAt == null) {
        return false;
      }

      final completedDate = DateTime(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );

      return completedDate == today;
    }).length;

    final pendingTasks = tasks.where(
          (task) => task['status'] != 'completed',
    ).toList();
    final pendingCount = pendingTasks.length;
    final totalRelevantTasks = completedToday + pendingCount;
    double completionPercentage = totalRelevantTasks == 0
        ? 0
        : (completedToday / totalRelevantTasks) * 100;
    int getUrgency(DateTime deadline) {
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final deadlineDate = DateTime(
        deadline.year,
        deadline.month,
        deadline.day,
      );

      if (deadlineDate.isBefore(today)) {
        return 4;
      } else if (deadlineDate.isAtSameMomentAs(today)) {
        return 3;
      } else if (deadlineDate.isAtSameMomentAs(
        today.add(Duration(days: 1)),
      )) {
        return 2;
      } else {
        return 1;
      }
    }

    int getPriorityScore(String priority) {
      if (priority == 'high') {
        return 3;
      } else if (priority == 'medium') {
        return 2;
      } else {
        return 1;
      }
    }

    String getDeadlineLabel(DateTime deadline) {
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final deadlineDate = DateTime(
        deadline.year,
        deadline.month,
        deadline.day,
      );

      if (deadlineDate.isBefore(today)) {
        return '⚠️ Overdue';
      } else if (deadlineDate.isAtSameMomentAs(today)) {
        return '📅 Due Today';
      } else if (deadlineDate.isAtSameMomentAs(
        today.add(Duration(days: 1)),
      )) {
        return '📅 Due Tomorrow';
      } else {
        return '📅 Upcoming';
      }
    }

    var nextBestTask;
    if (pendingTasks.length == 1) {
      nextBestTask = pendingTasks[0];
    } else if (pendingTasks.length >= 2) {
      pendingTasks.sort((a, b) {
        final urgencyA = getUrgency(a['deadline']);
        final urgencyB = getUrgency(b['deadline']);

        final priorityA = getPriorityScore(a['priority']);
        final priorityB = getPriorityScore(b['priority']);

        if (urgencyA != urgencyB) {
          return urgencyB.compareTo(urgencyA);
        }

        if (priorityA != priorityB) {
          return priorityB.compareTo(priorityA);
        }
        return a['duration'].compareTo(b['duration']);
      });
      nextBestTask = pendingTasks[0];
    }
    for (var task in pendingTasks) {
      final urgency = getUrgency(task['deadline']);

      print(
        '${task['goal']} → Urgency: $urgency',
      );
    }
    int overdueCount = 0;

    for (var task in tasks) {
      final deadline = task['deadline'];

      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final deadlineDate = DateTime(
        deadline.year,
        deadline.month,
        deadline.day,
      );

      if (deadlineDate.isBefore(today) && task['status'] != 'completed') {
        overdueCount++;
      }
    }
    // ================= END OF LOGIC =================

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(name, focusCoins),
                const SizedBox(height: 20),
                const Text(
                  'Your study space is ready.',
                  style: TextStyle(fontSize: 16, color: _textGrey),
                ),
                const SizedBox(height: 16),
                _buildAddButton(),
                const SizedBox(height: 18),
                if (nextBestTask != null) ...[
                  _buildNextBestCard(
                    nextBestTask,
                    getDeadlineLabel(nextBestTask['deadline']),
                  ),
                  const SizedBox(height: 18),
                ],
                _buildProgressCard(completionPercentage),
                const SizedBox(height: 14),
                _buildStuckTile(),
                if (overdueCount >= 3) ...[
                  const SizedBox(height: 16),
                  _buildOverdueBanner(overdueCount),
                ],
                const SizedBox(height: 22),
                const Text(
                  'Pending Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                if (pendingTasks.isEmpty)
                  const Text(
                    'No pending tasks yet',
                    style: TextStyle(fontSize: 15, color: _textGrey),
                  )
                else
                  ...pendingTasks.map((task) => _buildTaskCard(task)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: Colors.white,
          selectedItemColor: _primary,
          unselectedItemColor: _textGrey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) async {
            if (index == 1) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudyScreen(),
                ),
              );
              setState(() {});
            }
            if (index == 2) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
              setState(() {});
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Study',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
















//............................STUDYSCREEN
class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}
class _StudyScreenState extends State<StudyScreen> {
  final subjectController = TextEditingController();

  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bgTop = Color(0xFFF4F9FD);
  static const Color _bgBottom = Color(0xFFE3F0FA);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);
  static const Color _border = Color(0xFFD6E9F5);

  // ---------- UI HELPERS ----------
  RoundedRectangleBorder get _dialogShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(22));

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGrey),
      filled: true,
      fillColor: _bgTop,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
    );
  }

  Widget _topicChip(String topic, VoidCallback onDelete) {
    return Container(
      padding: const EdgeInsets.only(left: 14, top: 6, bottom: 6, right: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              topic,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _primary,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onDelete,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, size: 16, color: _textGrey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('userbox');
    final subjects = box.get('subjects', defaultValue: []);

    return Scaffold(
      backgroundColor: _bgTop,
      appBar: AppBar(
        backgroundColor: _bgTop,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: _textDark,
        title: const Text(
          'Study',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                'Your Subjects',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              SizedBox(height: 14,),

              if (subjects.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _border),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 48, color: _primary),
                      SizedBox(height: 12),
                      Text(
                        'No subjects yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap the + button to add your first subject',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: _textGrey),
                      ),
                    ],
                  ),
                ),

              ...subjects.map<Widget>((subject) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x10075985),
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Row(
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6EBFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF4F63D8),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _textDark,
                                  ),
                                ),
                                Text(
                                  '${subject['topics'].length} topics',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete Subject',
                            icon: const Icon(Icons.delete_outline,
                                color: Color(0xFFDC2626)),
                            onPressed: () {
                              // pending tasks of this subject (completed ones are kept)
                              final taskBox = Hive.box('taskbox');
                              final affectedKeys = taskBox.keys.where((key) {
                                final t = taskBox.get(key);
                                return t['subject'] == subject['name'] &&
                                    t['status'] != 'completed';
                              }).toList();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: _dialogShape,
                                    title: const Text('Delete Subject?'),
                                    content: Text(
                                      'Do you want to delete ${subject['name']} and all its topics?'
                                          '${affectedKeys.isNotEmpty ? '\n\n${affectedKeys.length} pending task(s) of this subject will also be deleted.' : ''}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      TextButton(

                                        onPressed: () async {
                                          await taskBox.deleteAll(affectedKeys);

                                          setState(() {
                                            subjects.remove(subject);
                                          });
                                          box.put('subjects', subjects);

                                          Navigator.pop(context);
                                        },

                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Color(0xFFDC2626)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...subject['topics'].map<Widget>((topic){
                            return _topicChip(topic.toString(), () {
                              // pending tasks of this topic (completed ones are kept)
                              final taskBox = Hive.box('taskbox');
                              final affectedKeys = taskBox.keys.where((key) {
                                final t = taskBox.get(key);
                                return t['subject'] == subject['name'] &&
                                    t['topic'] == topic &&
                                    t['status'] != 'completed';
                              }).toList();

                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  shape: _dialogShape,
                                  title: const Text('Delete Topic?'),
                                  content: Text(
                                    'Do you want to delete $topic?'
                                        '${affectedKeys.isNotEmpty ? '\n\n${affectedKeys.length} pending task(s) of this topic will also be deleted.' : ''}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await taskBox.deleteAll(affectedKeys);

                                        setState(() {
                                          subject['topics'].remove(topic);
                                        });

                                        box.put('subjects', subjects);

                                        Navigator.pop(context);

                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Color(0xFFDC2626)),
                                      ),
                                    ),
                                  ],
                                );
                              });
                            });
                          }),
                        ],
                      ),

                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: _primary,
                          padding: const EdgeInsets.only(top: 8),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              final topicController = TextEditingController();

                              return AlertDialog(
                                shape: _dialogShape,
                                title: Text('Add Topic to ${subject['name']}'),
                                content: TextField(
                                  controller: topicController,
                                  decoration: _fieldDecoration('Enter topic name'),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      final topicName = topicController.text.trim();
                                      setState(() {

                                        subject['topics'].add(topicName);
                                      });
                                      box.put('subjects', subjects);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );

                            },
                          );
                        },
                        label: const Text('Add topic'),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 80,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed:(){
          showDialog(
            context: context,
            builder:(context){
              return AlertDialog(
                shape: _dialogShape,
                title:const Text('Add Subject'),
                content: TextField(
                  controller: subjectController,
                  decoration: _fieldDecoration('Enter subject name'),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final subjectName = subjectController.text.trim();
                      setState(() {
                        subjects.add({
                          'name': subjectName,
                          'topics':[],
                        });
                      });
                      box.put('subjects', subjects);
                      Navigator.pop(context);

                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}













//................ADDSTUDYTASK
class AddStudyTaskScreen extends StatefulWidget {
  const AddStudyTaskScreen({super.key});
  @override
  State<AddStudyTaskScreen> createState() => _AddStudyTaskScreenState();
}

class _AddStudyTaskScreenState extends State<AddStudyTaskScreen> {
  final TextEditingController goalController = TextEditingController();
  String? selectedSubject;
  String? selectedTopic;
  DateTime? selectedDeadline;
  Priority? selectedPriority;
  int selectedDuration = 25;
  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }

  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bgTop = Color(0xFFF4F9FD);
  static const Color _bgBottom = Color(0xFFE3F0FA);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);
  static const Color _border = Color(0xFFD6E9F5);

  // ---------- UI HELPERS ----------
  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Color _priorityColor(String name) {
    if (name == 'high') return const Color(0xFFDC2626);
    if (name == 'medium') return const Color(0xFFEA580C);
    return const Color(0xFF16A34A);
  }

  Widget _label(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownBox<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(16),
        icon: const Icon(Icons.keyboard_arrow_down, color: _textGrey),
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 15, color: _textGrey),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _choiceChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color : _border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final box = Hive.box('userbox');

    final subjects = box.get(
      'subjects',
      defaultValue: [],
    );
    List<String> topics = [];

    if (selectedSubject != null) {
      final selected = subjects.firstWhere(
            (subject) => subject['name'] == selectedSubject,
      );

      topics = List<String>.from(selected['topics']);
    }
    Future<void> selectDeadline() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );

      if (picked != null) {
        setState(() {
          selectedDeadline = picked;
        });
      }
    }
    return Scaffold(
      backgroundColor: _bgTop,
      appBar: AppBar(
        backgroundColor: _bgTop,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: _textDark,
        title: const Text(
          'Add Study Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Subject', Icons.menu_book_rounded),
                  _dropdownBox<String>(
                    value: selectedSubject,
                    hint: 'Select Subject',
                    items: subjects.map<DropdownMenuItem<String>>((subject) {
                      return DropdownMenuItem<String>(
                        value: subject['name'],
                        child: Text(subject['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value;
                        selectedTopic = null;
                      });
                    },
                  ),
                  SizedBox(height: 20,),

                  _label('Topic', Icons.bookmark_outline),
                  _dropdownBox<String>(
                    value: selectedTopic,
                    hint: selectedSubject == null
                        ? 'Select a subject first'
                        : 'Select Topic',
                    items: topics.map<DropdownMenuItem<String>>((topic) {
                      return DropdownMenuItem<String>(
                        value: topic,
                        child: Text(topic),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTopic = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),

                  _label('Goal', Icons.flag_outlined),
                  TextField(
                    controller: goalController,
                    decoration: InputDecoration(
                      hintText: 'Enter your goal',
                      hintStyle: const TextStyle(color: _textGrey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: _border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                        const BorderSide(color: _primary, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  _label('Deadline', Icons.calendar_today_outlined),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: selectDeadline,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDeadline == null
                                  ? 'Select Deadline'
                                  : '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}',
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedDeadline == null
                                    ? _textGrey
                                    : _textDark,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit_calendar_outlined,
                              color: _primary),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  _label('Priority', Icons.error_outline),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: Priority.values.map((priority) {
                      return _choiceChip(
                        label: _capitalize(priority.name),
                        selected: selectedPriority == priority,
                        color: _priorityColor(priority.name),
                        onTap: () {
                          setState(() {
                            selectedPriority = priority;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20,),

                  _label('Duration', Icons.access_time),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [25, 45, 60].map((minutes) {
                      return _choiceChip(
                        label: '$minutes min',
                        selected: selectedDuration == minutes,
                        color: _primary,
                        onTap: () {
                          setState(() {
                            selectedDuration = minutes;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 32,),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        if (selectedSubject == null ||
                            selectedTopic == null ||
                            goalController.text.isEmpty ||
                            selectedDeadline == null ||
                            selectedPriority == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }

                        Task newTask = Task(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          subject: selectedSubject!,
                          topic: selectedTopic!,
                          goal: goalController.text,
                          deadline: selectedDeadline!,
                          priority: selectedPriority!,
                          duration: selectedDuration,
                          status: TaskStatus.pending,
                          createdAt: DateTime.now(),
                        );
                        final taskData = {
                          'id': newTask.id,
                          'subject': newTask.subject,
                          'topic': newTask.topic,
                          'goal': newTask.goal,
                          'deadline': newTask.deadline,
                          'priority': newTask.priority.name,
                          'duration': newTask.duration,
                          'status': newTask.status.name,
                          'createdAt': newTask.createdAt,
                        };
                        final taskBox = Hive.box('taskbox');
                        await taskBox.add(taskData);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      label: const Text(
                        'Add Task',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}






// ............................FOCUSSCREEN
class FocusSessionScreen extends StatefulWidget {
  final Map task;

  const FocusSessionScreen({
    super.key,
    required this.task,
  });

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> with WidgetsBindingObserver,RouteAware {
  int remainingSeconds =0;
  Timer? timer;
  bool wasRunningBeforeBackground = false;
  DateTime? sessionStartTime;
  int pauseCount = 0;
  int backgroundExitCount = 0;
  DateTime? backgroundStartTime;
  int totalBackgroundSeconds = 0;
  int startRemainingSeconds = 0;
  double calculateFocusScore(
      int plannedMinutes,
      int actualFocusedSeconds,
      int backgroundSeconds,
      ) {
    final plannedSeconds = plannedMinutes * 60;

    final focusedSeconds =
        actualFocusedSeconds - backgroundSeconds;

    final score =
        (focusedSeconds / plannedSeconds) * 100;

    return score.clamp(0, 100);
  }
  double calculateOverallFocusScore(String taskId) {
    final sessionBox = Hive.box<FocusSessionLog>('sessionbox');

    final sessions = sessionBox.values
        .where((session) => session.taskId == taskId)
        .toList();

    if (sessions.isEmpty) {
      return 0;
    }

    final totalFocusedSeconds = sessions.fold<int>(
      0,
          (total, session) => total + session.actualFocusedSeconds,
    );

    final plannedSeconds = sessions.first.plannedDurationMinutes * 60;

    final score =
        (totalFocusedSeconds / plannedSeconds) * 100;

    return score.clamp(0, 100);
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final taskBox = Hive.box('taskbox');

    final taskKey = taskBox.keys.firstWhere(
          (key) => taskBox.get(key)['id'] == widget.task['id'],
    );

    final savedTask = taskBox.get(taskKey);

    final savedTime = savedTask['remainingSeconds'];

    if (savedTime != null) {
      remainingSeconds = savedTime;
    } else {
      remainingSeconds = savedTask['duration'] * 60;
    }

    startRemainingSeconds = remainingSeconds;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }

  void didPushNext() {
    if (timer?.isActive == true) {
      wasRunningBeforeBackground = true;
      timer?.cancel();
    }
  }
  void didPopNext() {
    if (wasRunningBeforeBackground && remainingSeconds > 0) {
      timer = Timer.periodic(
        Duration(seconds: 1),
            (t) {
          if (remainingSeconds > 0) {
            setState(() {
              remainingSeconds--;
            });
          } else {
            wasRunningBeforeBackground = false;
            t.cancel();
          }
        },
      );
    }
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App background mein ja rahi hai
      if (timer?.isActive == true) {
        backgroundExitCount++;

        backgroundStartTime = DateTime.now();

        wasRunningBeforeBackground = true;

        timer?.cancel();
      }
    }

    else if (state == AppLifecycleState.resumed) {
      // App wapas foreground mein aa gayi
      if (backgroundStartTime != null) {

        final backgroundDuration =
            DateTime.now().difference(backgroundStartTime!).inSeconds;

        totalBackgroundSeconds += backgroundDuration;

        // Background mein guzra hua time timer se minus karo
        if (wasRunningBeforeBackground) {
          setState(() {
            remainingSeconds =
                remainingSeconds - backgroundDuration;

            if (remainingSeconds < 0) {
              remainingSeconds = 0;
            }
          });

          // Hive mein updated remaining time save karo
          final taskBox = Hive.box('taskbox');

          final taskKey = taskBox.keys.firstWhere(
                (key) => taskBox.get(key)['id'] == widget.task['id'],
          );

          final updatedTask = taskBox.get(taskKey);

          updatedTask['remainingSeconds'] = remainingSeconds;

          taskBox.put(taskKey, updatedTask);
        }

        backgroundStartTime = null;
      }

      // Agar session background jaane se pehle running tha,
      // toh wapas aane ke baad timer continue karo.
      if (wasRunningBeforeBackground &&
          remainingSeconds > 0) {

        timer = Timer.periodic(
          const Duration(seconds: 1),
              (t) {
            if (remainingSeconds > 0) {

              setState(() {
                remainingSeconds--;
              });

              final taskBox = Hive.box('taskbox');

              final taskKey = taskBox.keys.firstWhere(
                    (key) => taskBox.get(key)['id'] == widget.task['id'],
              );

              final updatedTask = taskBox.get(taskKey);

              updatedTask['remainingSeconds'] = remainingSeconds;

              taskBox.put(taskKey, updatedTask);

            } else {
              t.cancel();
            }
          },
        );
      }
    }
  }
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  // ---------- UI COLORS ----------
  static const Color _bgTop = Color(0xFF0B1F3A);
  static const Color _bgBottom = Color(0xFF123B66);
  static const Color _accent = Color(0xFF38BDF8);
  static const Color _cardBg = Color(0x1AFFFFFF);
  static const Color _cardBorder = Color(0x33FFFFFF);

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTaskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2B4C86),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF8FB4FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.task['subject']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.task['topic']}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFB6C8E0),
                  ),
                ),
                Text(
                  '${widget.task['goal']}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFB6C8E0),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time,
                        size: 18, color: _accent),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.task['duration']} min',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCircle() {
    final totalSeconds = (widget.task['duration'] as num) * 60;
    final double progress = totalSeconds == 0
        ? 0.0
        : (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    final double size = MediaQuery.of(context).size.width * 0.75;

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              strokeCap: StrokeCap.round,
              backgroundColor: const Color(0x26FFFFFF),
              valueColor: const AlwaysStoppedAnimation(_accent),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Remaining',
                style: TextStyle(fontSize: 16, color: Color(0xFFB6C8E0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text(
          'Focus Session',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildTaskCard(),
                const SizedBox(height: 32),
                _buildTimerCircle(),
                const SizedBox(height: 36),
                Row(
                  children: [
                    _actionButton(
                      label: 'Start',
                      icon: Icons.play_arrow_rounded,
                      color: const Color(0xFF16A34A),
                      onPressed: () {
                        if (timer == null || !timer!.isActive) {
                          wasRunningBeforeBackground = true;
                          sessionStartTime = DateTime.now();
                          timer = Timer.periodic(
                            Duration(seconds: 1),
                                (t) {
                              if (remainingSeconds > 0) {
                                setState(() {
                                  remainingSeconds--;
                                });
                                final taskBox = Hive.box('taskbox');

                                final taskKey = taskBox.keys.firstWhere(
                                      (key) => taskBox.get(key)['id'] == widget.task['id'],
                                );

                                final updatedTask = taskBox.get(taskKey);

                                updatedTask['remainingSeconds'] = remainingSeconds;

                                taskBox.put(taskKey, updatedTask);
                              } else {
                                t.cancel();
                              }
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _actionButton(
                      label: 'Pause',
                      icon: Icons.pause_rounded,
                      color: const Color(0xFF2F80ED),
                      onPressed: () {
                        if (timer?.isActive == true) {
                          pauseCount++;
                        }
                        timer?.cancel();
                        wasRunningBeforeBackground=false;
                      },
                    ),
                    const SizedBox(width: 12),
                    _actionButton(
                      label: 'End',
                      icon: Icons.stop_rounded,
                      color: const Color(0xFFE5576B),
                      onPressed: (){
                        timer?.cancel();
                        final plannedSeconds = widget.task['duration'] * 60;

                        final actualFocusedSeconds =
                            startRemainingSeconds - remainingSeconds;
                        final focusedSeconds =
                            actualFocusedSeconds - totalBackgroundSeconds;
                        final focusScore = calculateFocusScore(
                          widget.task['duration'],
                          actualFocusedSeconds,
                          totalBackgroundSeconds,
                        );



                        final sessionBox = Hive.box<FocusSessionLog>('sessionbox');

                        final sessionLog = FocusSessionLog(
                          startTime: sessionStartTime ?? DateTime.now(),
                          endTime: DateTime.now(),
                          plannedDurationMinutes: widget.task['duration'],
                          pauseCount: pauseCount,
                          backgroundExitCount: backgroundExitCount,
                          totalBackgroundSeconds: totalBackgroundSeconds,
                          taskId: widget.task['id'],
                          actualFocusedSeconds: focusedSeconds,
                        );

                        sessionBox.add(sessionLog);
                        final overallFocusScore =
                        calculateOverallFocusScore(widget.task['id']);


                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ReflectionScreen(
                          task: widget.task,
                          focusScore: overallFocusScore,
                        )));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

















// ............................REFLECTIONSCREEN

class ReflectionScreen extends StatefulWidget {
  final Map task;
  final double focusScore;


  const ReflectionScreen({
    super.key,
    required this.task,
    required this.focusScore,
  });

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  String? sessionFeeling;
  String? taskResult;

  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bgTop = Color(0xFFF4F9FD);
  static const Color _bgBottom = Color(0xFFE3F0FA);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);
  static const Color _border = Color(0xFFD6E9F5);

  Widget _buildTaskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14075985),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EBFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF4F63D8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${widget.task['goal']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Focus Score: ${widget.focusScore.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _textDark,
      ),
    );
  }

  Widget _dropdownBox({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(16),
        icon: const Icon(Icons.keyboard_arrow_down, color: _textGrey),
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 15, color: _textGrey),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  DropdownMenuItem<String> _feelingItem(String value, String emoji) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: _textDark),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _resultItem(
      String value, IconData icon, Color color) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: _textDark),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill the feedback before going back.'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _bgTop,
        appBar: AppBar(
          backgroundColor: _bgTop,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          foregroundColor: _textDark,
          title: const Text(
            'Reflection',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_bgTop, _bgBottom],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                _buildTaskCard(),
                SizedBox(height: 28),

                _label('How did your session go?'),

                SizedBox(height: 10),

                _dropdownBox(
                  value: sessionFeeling,
                  hint: 'Select how it went',

                  items: [
                    _feelingItem('Easy', '😄'),
                    _feelingItem('Good', '😊'),
                    _feelingItem('Okay', '😐'),
                    _feelingItem('Difficult', '😓'),
                  ],

                  onChanged: (value) {
                    setState(() {
                      sessionFeeling = value;
                    });
                  },
                ),

                SizedBox(height: 28),

                _label('What happened with the task?'),

                SizedBox(height: 10),

                _dropdownBox(
                  value: taskResult,
                  hint: 'Select task result',

                  items: [
                    _resultItem('Completed', Icons.check_circle,
                        const Color(0xFF16A34A)),
                    _resultItem('Partially Completed', Icons.timelapse,
                        const Color(0xFFEA580C)),
                    _resultItem('Not Completed', Icons.cancel,
                        const Color(0xFFDC2626)),
                  ],

                  onChanged: (value) {
                    setState(() {
                      taskResult = value;
                    });
                  },
                ),

                SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: ()  async {
                      if(sessionFeeling== null || taskResult == null){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("please fill the feedback before saving."),
                            )
                        );
                        return;
                      }
                      if (taskResult == 'Completed' && widget.focusScore < 60) {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Low Focus Score'),
                              content: Text(
                                'Your focus score is ${widget.focusScore.toStringAsFixed(1)}%. '
                                    'Your session was short or interrupted.\n\n'
                                    'Do you still want to mark this task as completed?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text('Go Back'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Mark Completed'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm != true) {
                          return;
                        }
                      }
                      final taskBox = Hive.box('taskbox');
                      final taskKey = taskBox. keys.firstWhere(
                            (key)=> taskBox.get(key)['id'] == widget.task['id'],
                      );
                      String newStatus;
                      if(taskResult =='Completed'){
                        newStatus='completed';
                        taskBox.get(taskKey)['completedAt'] = DateTime.now();
                        final userBox = Hive.box('userbox');

                        int coins = userBox.get(
                          'focusCoins',
                          defaultValue: 0,
                        );

                        coins += 5;

                        userBox.put('focusCoins', coins);

                      }
                      else if( taskResult == 'Partially Completed'){
                        newStatus = 'inProgress';
                      }else {
                        newStatus = 'pending';
                      }
                      taskBox.get(taskKey)['status'] = newStatus;
                      taskBox.put(taskKey, taskBox.get(taskKey));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),),);
                    },
                    child: const Text(
                      'Save Reflection',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}














//....................profilescreen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ---------- UI COLORS ----------
  static const Color _primary = Color(0xFF075985);
  static const Color _bgTop = Color(0xFFF4F9FD);
  static const Color _bgBottom = Color(0xFFE3F0FA);
  static const Color _textDark = Color(0xFF0F2A3D);
  static const Color _textGrey = Color(0xFF5B7185);
  static const Color _border = Color(0xFFD6E9F5);

  // ---------- UI HELPERS ----------
  Widget _statTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: _textGrey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, {String? suffix}) {
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      filled: true,
      fillColor: _bgTop,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
    );
  }

  Widget _durationChip({
    required int minutes,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? _primary : _border),
        ),
        child: Text(
          '$minutes min',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('userbox');

    final name = box.get(
      'name',
      defaultValue: 'Student',
    );

    final hours = box.get(
      'hours',
      defaultValue: 'Not set',
    );

    final duration = box.get(
      'duration',
      defaultValue: 25,
    );

    final subjects = box.get(
      'subjects',
      defaultValue: [],
    );

    return Scaffold(
      backgroundColor: _bgTop,
      appBar: AppBar(
        backgroundColor: _bgTop,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: _textDark,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // Profile picture
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF075985)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 46,
                  backgroundColor: Color(0xFFE8F5FC),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: _primary,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Name
              Text(
                name.toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),

              const SizedBox(height: 24),

              // Daily study time
              _statTile(
                icon: Icons.schedule,
                iconColor: const Color(0xFF0284C7),
                iconBg: const Color(0xFFE0F2FE),
                label: 'Daily Study Time',
                value: '$hours hr',
              ),

              // Focus duration
              _statTile(
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFF16A34A),
                iconBg: const Color(0xFFDCFCE7),
                label: 'Focus Duration',
                value: '$duration minutes',
              ),

              // Subjects count
              _statTile(
                icon: Icons.menu_book_rounded,
                iconColor: const Color(0xFF4F63D8),
                iconBg: const Color(0xFFE6EBFF),
                label: 'Subjects',
                value: '${subjects.length}',
              ),

              const SizedBox(height: 16),

              // Edit Profile button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {

                    // Controllers
                    final nameController = TextEditingController(
                      text: name.toString(),
                    );

                    final hoursController = TextEditingController(
                      text: hours.toString(),
                    );

                    // Current selected duration
                    int selectedDuration = duration;

                    showDialog(
                      context: context,

                      builder: (context) {

                        return StatefulBuilder(
                          builder: (
                              context,
                              setDialogState,
                              ) {

                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              title: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _textDark,
                                ),
                              ),

                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // Name
                                    TextField(
                                      controller: nameController,
                                      decoration: _fieldDecoration('Name'),
                                    ),

                                    const SizedBox(height: 15),

                                    // Daily study time
                                    TextField(
                                      controller: hoursController,
                                      keyboardType:
                                      TextInputType.number,
                                      decoration: _fieldDecoration(
                                        'Daily Study Time',
                                        suffix: 'hr',
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    // Focus duration
                                    const Text(
                                      'Focus Duration',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _textDark,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [25, 45, 60].map((minutes) {
                                        return _durationChip(
                                          minutes: minutes,
                                          selected: selectedDuration == minutes,
                                          onTap: () {
                                            setDialogState(() {
                                              selectedDuration = minutes;
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),

                              actions: [

                                // Cancel
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: _textGrey),
                                  ),
                                ),

                                // Save
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {

                                    // Save name
                                    box.put(
                                      'name',
                                      nameController.text.trim(),
                                    );

                                    // Save daily study time
                                    box.put(
                                      'hours',
                                      hoursController.text.trim(),
                                    );

                                    // Save focus duration
                                    box.put(
                                      'duration',
                                      selectedDuration,
                                    );

                                    // Close dialog
                                    Navigator.pop(context);

                                    // Refresh Profile screen
                                    setState(() {});

                                  },

                                  child: const Text(
                                    'Save',
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },

                  icon: const Icon(
                    Icons.edit,
                  ),

                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

