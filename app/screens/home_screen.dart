import 'package:flutter/material.dart';

/// A premium, highly customizable Home Screen for the Saudi Football Quiz.
/// Designed to be architecture-agnostic with clear callbacks and default mock data.
class HomeScreen extends StatefulWidget {
  final String userName;
  final String? userAvatarUrl;
  final int userPoints;
  final int userRank;
  final List<Map<String, String>> availableTeams;
  final Function(String mode, String? teamKey)? onStartGame;
  final VoidCallback? onNavigateToLeaderboard;
  final VoidCallback? onLogout;
  final String language;

  const HomeScreen({
    Key? key,
    this.userName = 'سلمان العتيبي',
    this.userAvatarUrl,
    this.userPoints = 1250,
    this.userRank = 24,
    this.availableTeams = const [
      {'key': 'alhilal', 'name_ar': 'الهلال', 'name_en': 'Al-Hilal', 'color': '0xFF0055A5'},
      {'key': 'alnassr', 'name_ar': 'النصر', 'name_en': 'Al-Nassr', 'color': '0xFFF9C80E'},
      {'key': 'alittihad', 'name_ar': 'الاتحاد', 'name_en': 'Al-Ittihad', 'color': '0xFFFEF200'},
      {'key': 'alahli', 'name_ar': 'الأهلي', 'name_en': 'Al-Ahli', 'color': '0xFF008D57'},
      {'key': 'alshabab', 'name_ar': 'الشباب', 'name_en': 'Al-Shabab', 'color': '0xFF8E8E93'},
      {'key': 'alqadisiyah', 'name_ar': 'القادسية', 'name_en': 'Al-Qadisiyah', 'color': '0xFFC0392B'},
      {'key': 'altaawoun', 'name_ar': 'التعاون', 'name_en': 'Al-Taawoun', 'color': '0xFFF39C12'},
      {'key': 'neom', 'name_ar': 'نيوم', 'name_en': 'Neom', 'color': '0xFF1ABC9C'},
    ],
    this.onStartGame,
    this.onNavigateToLeaderboard,
    this.onLogout,
    this.language = 'ar',
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMode = 'normal'; // 'normal' or 'timer'
  String? _selectedTeamKey; // null means all teams (Saudi League)

  @override
  Widget build(BuildContext context) {
    final isAr = widget.language == 'ar';

    // Localizations
    final dailyChallengeText = isAr ? 'التحدي اليومي' : 'Daily Challenge';
    final dailyDesc = isAr 
        ? 'خمن أفضل 10 لاعبين لليوم وحقق الصدارة!' 
        : 'Guess today\'s top 10 players and conquer the ranks!';
    final startBtnText = isAr ? 'ابدأ اللعب الآن' : 'Start Play Now';
    final chooseModeText = isAr ? 'اختر طور اللعب' : 'Choose Game Mode';
    final normalModeText = isAr ? 'اللعب العادي' : 'Normal Play';
    final timerModeText = isAr ? 'تحدي دقيقتين' : '2-Min Timer';
    final filterByTeamText = isAr ? 'اختر ناديك المفضل (اختياري)' : 'Choose Your Club (Optional)';
    final allLeagueText = isAr ? 'كل نجوم دوري روشن' : 'All Roshn Stars';
    final pointsText = isAr ? 'نقطة' : 'Pts';
    final rankText = isAr ? 'الترتيب: #${widget.userRank}' : 'Rank: #${widget.userRank}';

    return Scaffold(
      backgroundColor: const Color(0xFF070E0B), // Solid pitch dark green background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Profile & Log Out Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Avatar with gold border
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: const Color(0xFF006C35),
                          backgroundImage: widget.userAvatarUrl != null 
                              ? NetworkImage(widget.userAvatarUrl!) 
                              : null,
                          child: widget.userAvatarUrl == null
                              ? Text(
                                  widget.userName.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Tajawal',
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${widget.userPoints} $pointsText',
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1.5,
                                height: 12,
                                color: Colors.white24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                rankText,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Logout Button
                  IconButton(
                    onPressed: widget.onLogout,
                    icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.04),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 2. Glowing Daily Challenge Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF006C35), // Saudi Green
                      Color(0xFF0A3E22), // Deep Green
                      Color(0xFF0C1F15), // Very Dark Green
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3), // Gold Border outline
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF006C35).withOpacity(0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD4AF37), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Color(0xFFD4AF37), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                dailyChallengeText,
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.sports_soccer_sharp,
                          color: Colors.white.withOpacity(0.3),
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Topic Title
                    const Text(
                      'أفضل 10 هدافين لنادي الهلال تاريخياً في دوري المحترفين',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dailyDesc,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Button inside Card
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.onStartGame != null) {
                            widget.onStartGame!(_selectedMode, _selectedTeamKey);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37), // Pure Gold
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        child: Text(
                          startBtnText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 3. Choose Game Mode Segment
              Text(
                chooseModeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildModeCard(
                      icon: Icons.play_arrow_rounded,
                      title: normalModeText,
                      description: isAr ? 'تخمين هادئ بدون وقت محدد' : 'Guess calmly with no time limits',
                      isSelected: _selectedMode == 'normal',
                      onTap: () => setState(() => _selectedMode = 'normal'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildModeCard(
                      icon: Icons.timer,
                      title: timerModeText,
                      description: isAr ? 'أجب بسرعة البرق في دقيقتين!' : 'Sprint through the answers in 2 mins!',
                      isSelected: _selectedMode == 'timer',
                      onTap: () => setState(() => _selectedMode = 'timer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 4. Custom Filters (Clubs/Category)
              Text(
                filterByTeamText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              // Horizontal Team Selector Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // League wide Chip
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                      child: ChoiceChip(
                        label: Text(
                          allLeagueText,
                          style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                        ),
                        selected: _selectedTeamKey == null,
                        selectedColor: const Color(0xFF006C35),
                        backgroundColor: Colors.white.withOpacity(0.04),
                        labelStyle: TextStyle(
                          color: _selectedTeamKey == null ? Colors.white : Colors.white60,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedTeamKey = null);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _selectedTeamKey == null 
                                ? const Color(0xFF006C35) 
                                : Colors.white10,
                          ),
                        ),
                      ),
                    ),
                    // Specific Team Chips
                    ...widget.availableTeams.map((team) {
                      final isSelected = _selectedTeamKey == team['key'];
                      final teamName = isAr ? team['name_ar'] : team['name_en'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(
                            teamName!,
                            style: const TextStyle(fontFamily: 'Tajawal'),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF006C35),
                          backgroundColor: Colors.white.withOpacity(0.04),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white60,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedTeamKey = selected ? team['key'] : null;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF006C35) : Colors.white10,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 5. Custom premium Bottom Navigation
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1411), // Extremely deep green/black
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Menu Icon (Active)
            IconButton(
              icon: const Icon(Icons.home_filled, color: Color(0xFFD4AF37), size: 28),
              onPressed: () {},
            ),
            // Play Quick Button (Central Glowing Launcher)
            InkWell(
              onTap: () {
                if (widget.onStartGame != null) {
                  widget.onStartGame!(_selectedMode, _selectedTeamKey);
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF006C35), Color(0xFFD4AF37)],
                  ),
                  boxShadow: [
                    BoxShadow(color: Color(0xFF006C35), blurRadius: 10, spreadRadius: 1),
                  ],
                ),
                child: const Icon(Icons.sports_soccer, color: Colors.white, size: 26),
              ),
            ),
            // Leaderboard Menu Icon (Inactive)
            IconButton(
              icon: Icon(Icons.leaderboard_outlined, color: Colors.white.withOpacity(0.6), size: 28),
              onPressed: widget.onNavigateToLeaderboard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.01),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF006C35) : Colors.white.withOpacity(0.06),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFF006C35).withOpacity(0.15), blurRadius: 10)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.white38,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
