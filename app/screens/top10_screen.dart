import 'dart:async';
import 'package:flutter/material.dart';

/// A premium, highly interactive Top 10 Game Screen for the Saudi Football Quiz.
/// Features high-fidelity designs, autocomplete suggestions, timers, animation flips,
/// strike indicator cards, and win/loss overlay cards. Architecture-agnostic.
class Top10Screen extends StatefulWidget {
  final String challengeTitle;
  final String gameMode; // 'normal' or 'timer'
  final List<Map<String, dynamic>> targetPlayers; // 10 correct players in the list
  final List<Map<String, dynamic>> allLeaguePlayers; // Used for autocomplete suggestions
  final Function(int score, int timeUsed, bool isWin)? onGameFinished;
  final VoidCallback? onBackToHome;
  final String language;

  const Top10Screen({
    Key? key,
    this.challengeTitle = 'أفضل 10 لاعبين في الهلال (موسم 2025-2026)',
    this.gameMode = 'timer',
    this.targetPlayers = const [
      {'id': 1, 'name_ar': 'سالم الدوسري', 'name_en': 'Salem Al-Dossari', 'nationality_ar': 'سعودي', 'nationality_en': 'Saudi', 'flag': '🇸🇦', 'position_ar': 'وسط', 'position_en': 'Midfielder', 'number': 29},
      {'id': 2, 'name_ar': 'ياسين بونو', 'name_en': 'Yassine Bounou', 'nationality_ar': 'مغربي', 'nationality_en': 'Moroccan', 'flag': '🇲🇦', 'position_ar': 'حارس مرمى', 'position_en': 'Goalkeeper', 'number': 37},
      {'id': 3, 'name_ar': 'روبن نيفيز', 'name_en': 'Ruben Neves', 'nationality_ar': 'برتغالي', 'nationality_en': 'Portuguese', 'flag': '🇵🇹', 'position_ar': 'وسط', 'position_en': 'Midfielder', 'number': 8},
      {'id': 4, 'name_ar': 'خاليدو كوليبالي', 'name_en': 'Kalidou Koulibaly', 'nationality_ar': 'سنغالي', 'nationality_en': 'Senegalese', 'flag': '🇸🇳', 'position_ar': 'مدافع', 'position_en': 'Defender', 'number': 3},
      {'id': 5, 'name_ar': 'سيرجي سافيتش', 'name_en': 'Sergej Milinkovic-Savic', 'nationality_ar': 'صربي', 'nationality_en': 'Serbian', 'flag': '🇷🇸', 'position_ar': 'وسط', 'position_en': 'Midfielder', 'number': 22},
      {'id': 6, 'name_ar': 'مالكوم', 'name_en': 'Malcom', 'nationality_ar': 'برازيلي', 'nationality_en': 'Brazilian', 'flag': '🇧🇷', 'position_ar': 'مهاجم', 'position_en': 'Forward', 'number': 10},
      {'id': 7, 'name_ar': 'جواو كانسيلو', 'name_en': 'Joao Cancelo', 'nationality_ar': 'برتغالي', 'nationality_en': 'Portuguese', 'flag': '🇵🇹', 'position_ar': 'مدافع', 'position_en': 'Defender', 'number': 2},
      {'id': 8, 'name_ar': 'حسان تمبكتي', 'name_en': 'Hassan Tambakti', 'nationality_ar': 'سعودي', 'nationality_en': 'Saudi', 'flag': '🇸🇦', 'position_ar': 'مدافع', 'position_en': 'Defender', 'number': 87},
      {'id': 9, 'name_ar': 'ماركوس ليوناردو', 'name_en': 'Marcos Leonardo', 'nationality_ar': 'برازيلي', 'nationality_en': 'Brazilian', 'flag': '🇧🇷', 'position_ar': 'مهاجم', 'position_en': 'Forward', 'number': 9},
      {'id': 10, 'name_ar': 'كريم بنزيمة', 'name_en': 'Karim Benzema', 'nationality_ar': 'فرنسي', 'nationality_en': 'French', 'flag': '🇫🇷', 'position_ar': 'مهاجم', 'position_en': 'Forward', 'number': 90},
    ],
    this.allLeaguePlayers = const [
      {'name_ar': 'سالم الدوسري', 'name_en': 'Salem Al-Dossari', 'flag': '🇸🇦'},
      {'name_ar': 'ياسين بونو', 'name_en': 'Yassine Bounou', 'flag': '🇲🇦'},
      {'name_ar': 'روبن نيفيز', 'name_en': 'Ruben Neves', 'flag': '🇵🇹'},
      {'name_ar': 'خاليدو كوليبالي', 'name_en': 'Kalidou Koulibaly', 'flag': '🇸🇳'},
      {'name_ar': 'سيرجي سافيتش', 'name_en': 'Sergej Milinkovic-Savic', 'flag': '🇷🇸'},
      {'name_ar': 'مالكوم', 'name_en': 'Malcom', 'flag': '🇧🇷'},
      {'name_ar': 'جواو كانسيلو', 'name_en': 'Joao Cancelo', 'flag': '🇵🇹'},
      {'name_ar': 'حسان تمبكتي', 'name_en': 'Hassan Tambakti', 'flag': '🇸🇦'},
      {'name_ar': 'ماركوس ليوناردو', 'name_en': 'Marcos Leonardo', 'flag': '🇧🇷'},
      {'name_ar': 'كريم بنزيمة', 'name_en': 'Karim Benzema', 'flag': '🇫🇷'},
      {'name_ar': 'رياض محرز', 'name_en': 'Riyad Mahrez', 'flag': '🇩🇿'},
      {'name_ar': 'إيفان توني', 'name_en': 'Ivan Toney', 'flag': '🇬🇧'},
      {'name_ar': 'كريستيانو رونالدو', 'name_en': 'Cristiano Ronaldo', 'flag': '🇵🇹'},
      {'name_ar': 'ساديو ماني', 'name_en': 'Sadio Mane', 'flag': '🇸🇳'},
      {'name_ar': 'موسى ديابي', 'name_en': 'Moussa Diaby', 'flag': '🇫🇷'},
    ],
    this.onGameFinished,
    this.onBackToHome,
    this.language = 'ar',
  }) : super(key: key);

  @override
  State<Top10Screen> createState() => _Top10ScreenState();
}

class _Top10ScreenState extends State<Top10Screen> {
  // Game states
  late List<bool> _guessedStates;
  int _strikes = 0;
  final int _maxStrikes = 3;
  
  // Timer settings
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes
  final int _totalDuration = 120;
  bool _isGameOver = false;
  bool _isWin = false;

  // Search/Input controllers
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _guessedStates = List.generate(widget.targetPlayers.length, (_) => false);
    if (widget.gameMode == 'timer') {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _endGame(false); // Time out = Lose
      }
    });
  }

  // Guess checking algorithm
  void _submitGuess(String guess) {
    if (guess.trim().isEmpty || _isGameOver) return;
    
    final isAr = widget.language == 'ar';
    bool matched = false;
    int matchedIndex = -1;

    // Fuzzy clean guess input for easier matching
    String cleanString(String text) {
      return text
          .toLowerCase()
          .replaceAll(RegExp(r'[أإآأ]'), 'ا')
          .replaceAll(RegExp(r'[ىي]'), 'ي')
          .replaceAll(RegExp(r'ة'), 'ه')
          .replaceAll(RegExp(r'\s+'), '')
          .trim();
    }

    final cleanedGuess = cleanString(guess);

    for (int i = 0; i < widget.targetPlayers.length; i++) {
      if (_guessedStates[i]) continue; // Already solved

      final player = widget.targetPlayers[i];
      final nameAr = cleanString(player['name_ar']);
      final nameEn = cleanString(player['name_en']);

      // Matches either Arabic or English
      if (cleanedGuess == nameAr || cleanedGuess == nameEn) {
        matched = true;
        matchedIndex = i;
        break;
      }
    }

    setState(() {
      _inputController.clear();
      _suggestions = [];
    });

    if (matched && matchedIndex != -1) {
      // Success! Play sound/haptic here
      setState(() {
        _guessedStates[matchedIndex] = true;
      });

      // Show temporary flash on screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تخمين صحيح! 🎉' : 'Correct Guess! 🎉',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF006C35),
          duration: const Duration(milliseconds: 600),
        ),
      );

      // Check win condition
      if (_guessedStates.every((state) => state == true)) {
        _endGame(true);
      }
    } else {
      // Mistake! Add strike
      setState(() {
        _strikes++;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تخمين غير صحيح! ❌' : 'Incorrect Guess! ❌',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(milliseconds: 600),
        ),
      );

      if (_strikes >= _maxStrikes) {
        _endGame(false); // Strikes limit exceeded = Lose
      }
    }
  }

  void _endGame(bool isWin) {
    _timer?.cancel();
    setState(() {
      _isGameOver = true;
      _isWin = isWin;
    });

    if (widget.onGameFinished != null) {
      final score = _guessedStates.where((s) => s).length * 100;
      final timeUsed = _totalDuration - _secondsRemaining;
      widget.onGameFinished!(score, timeUsed, isWin);
    }
  }

  // Suggest players from the full dataset based on query
  void _onInputChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final isAr = widget.language == 'ar';
    final queryClean = query.toLowerCase();

    final filtered = widget.allLeaguePlayers.where((player) {
      final nameAr = player['name_ar'].toLowerCase();
      final nameEn = player['name_en'].toLowerCase();
      return nameAr.contains(queryClean) || nameEn.contains(queryClean);
    }).take(4).toList(); // Max 4 auto-suggestions to avoid screen clutter

    setState(() {
      _suggestions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.language == 'ar';
    final guessedCount = _guessedStates.where((state) => state == true).length;
    final totalCount = widget.targetPlayers.length;

    // Localizations
    final inputPlaceholder = isAr ? 'اكتب اسم لاعب لتخمينه هنا...' : 'Type player name to guess...';
    final guessBtnText = isAr ? 'تخمين' : 'Guess';
    final timerTitle = isAr ? 'المؤقت' : 'Timer';
    final strikesTitle = isAr ? 'الإنذارات' : 'Strikes';
    final winTitle = isAr ? 'تهانينا! فوز ساحق 🏆' : 'Congratulations! Huge Win 🏆';
    final winDesc = isAr 
        ? 'تمكنت من تخمين كافة اللاعبين العشرة بنجاح!' 
        : 'You guessed all 10 players correctly!';
    final loseTitle = isAr ? 'انتهت اللعبة! 😞' : 'Game Over! 😞';
    final loseDesc = isAr 
        ? 'للأسف لم تتمكن من إكمال القائمة بنجاح.' 
        : 'Unfortunately, you couldn\'t complete the list.';
    final scoreLabel = isAr ? 'النقاط المحققة' : 'Final Score';
    final playAgainText = isAr ? 'العودة للرئيسية' : 'Back to Home';
    
    // Formatting remaining timer nicely
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    final timerString = '$minutes:$seconds';

    return Scaffold(
      backgroundColor: const Color(0xFF070E0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1411),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.challengeTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: widget.onBackToHome,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 1. Dashboard Row: Timer + Progress Circle + Strikes
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  color: const Color(0xFF0B1411),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Timer Block
                      Column(
                        children: [
                          Text(
                            timerTitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                color: widget.gameMode == 'timer' && _secondsRemaining < 30
                                    ? Colors.redAccent
                                    : const Color(0xFFD4AF37),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.gameMode == 'timer' ? timerString : '∞',
                                style: TextStyle(
                                  color: widget.gameMode == 'timer' && _secondsRemaining < 30
                                      ? Colors.redAccent
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Progress Ring
                      Column(
                        children: [
                          Text(
                            '$guessedCount / $totalCount',
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 20,
                              fontWeight: FontWeight.black,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Text(
                            isAr ? 'اللاعبين المكتشفين' : 'Players Found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 10,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),

                      // Strikes Block
                      Column(
                        children: [
                          Text(
                            strikesTitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Soccer Cards (Yellow/Red) representing strikes
                          Row(
                            children: List.generate(_maxStrikes, (index) {
                              final isStruck = index < _strikes;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                width: 14,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: isStruck
                                      ? (index == _maxStrikes - 1 ? Colors.red : Colors.orangeAccent)
                                      : Colors.white.withOpacity(0.1),
                                  border: isStruck 
                                      ? null 
                                      : Border.all(color: Colors.white24, width: 0.5),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. Main 10-Slot List View
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.targetPlayers.length,
                    itemBuilder: (context, index) {
                      final isGuessed = _guessedStates[index];
                      final player = widget.targetPlayers[index];
                      return _buildPlayerSlot(index + 1, player, isGuessed);
                    },
                  ),
                ),

                // 3. Autocomplete suggestions overlay container
                if (_suggestions.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13221C),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF006C35), width: 1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _suggestions.map((player) {
                        final displayName = isAr ? player['name_ar'] : player['name_en'];
                        return ListTile(
                          dense: true,
                          leading: Text(player['flag'] ?? '⚽', style: const TextStyle(fontSize: 18)),
                          title: Text(
                            displayName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Tajawal'),
                          ),
                          onTap: () {
                            _submitGuess(displayName);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                // 4. Keyboard Input Field
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1411),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          focusNode: _focusNode,
                          onChanged: _onInputChanged,
                          style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                          cursorColor: const Color(0xFFD4AF37),
                          textInputAction: TextInputAction.go,
                          onSubmitted: (val) => _submitGuess(val),
                          decoration: InputDecoration(
                            hintText: inputPlaceholder,
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontFamily: 'Tajawal'),
                            fillColor: Colors.white.withOpacity(0.04),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _submitGuess(_inputController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006C35),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            guessBtnText,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. Game Over / Win Premium Glass Overlay
          if (_isGameOver)
            Container(
              color: Colors.black.withOpacity(0.85),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1E19),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _isWin ? const Color(0xFFD4AF37) : Colors.redAccent.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isWin ? const Color(0xFFD4AF37).withOpacity(0.2) : Colors.redAccent.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trophy/Shattered icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isWin ? const Color(0xFFD4AF37).withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                        ),
                        child: Icon(
                          _isWin ? Icons.emoji_events_rounded : Icons.heart_broken_rounded,
                          color: _isWin ? const Color(0xFFD4AF37) : Colors.redAccent,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isWin ? winTitle : loseTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isWin ? winDesc : loseDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              scoreLabel,
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontFamily: 'Tajawal', fontSize: 13),
                            ),
                            Text(
                              '${guessedCount * 100} Pts',
                              style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Action buttons
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: widget.onBackToHome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isWin ? const Color(0xFF006C35) : const Color(0xFF1E2F29),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            playAgainText,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerSlot(int rank, Map<String, dynamic> player, bool isGuessed) {
    final isAr = widget.language == 'ar';
    final playerName = isAr ? player['name_ar'] : player['name_en'];
    final nationality = isAr ? player['nationality_ar'] : player['nationality_en'];
    final position = isAr ? player['position_ar'] : player['position_en'];
    final flag = player['flag'] ?? '🇸🇦';
    final number = player['number'] ?? 'N/A';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 12.0),
      height: 60,
      decoration: BoxDecoration(
        color: isGuessed ? const Color(0xFF0B2A1B) : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGuessed 
              ? const Color(0xFF006C35) 
              : Colors.white.withOpacity(0.06),
          width: isGuessed ? 1.5 : 1,
        ),
        boxShadow: isGuessed 
            ? [BoxShadow(color: const Color(0xFF006C35).withOpacity(0.1), blurRadius: 8)]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rank Number & Flag Hint (Always visible)
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isGuessed ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Text(
                      rank.toString(),
                      style: TextStyle(
                        color: isGuessed ? Colors.black : Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Player nationality Flag (Hint)
                Text(
                  flag,
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),

            // Guess Result (Flipped with Animation)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: isGuessed
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$position • $nationality',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      )
                    : Align(
                        alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          isAr ? '؟؟؟؟؟؟؟؟' : '????????',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.12),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
              ),
            ),

            // Player Shirt Number badge (Only visible if guessed)
            if (isGuessed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 0.5),
                ),
                child: Text(
                  '#$number',
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
