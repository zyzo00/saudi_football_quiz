import 'package:flutter/material.dart';

/// A premium, high-fidelity Leaderboard Screen for the Saudi Football Quiz.
/// Displays a stunning podium for the top 3 ranks, dynamic filter tabs, 
/// and a beautifully styled list for lower ranks. Architecture-agnostic.
class LeaderboardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dailyLeaderboard;
  final List<Map<String, dynamic>> weeklyLeaderboard;
  final List<Map<String, dynamic>> allTimeLeaderboard;
  final String currentUserId;
  final VoidCallback? onBackToHome;
  final String language;

  const LeaderboardScreen({
    Key? key,
    this.dailyLeaderboard = const [
      {'id': '1', 'name': 'أحمد الهلالي', 'points': 4500, 'time': '1:12', 'avatar': null},
      {'id': '2', 'name': 'عبدالرحمن النصر', 'points': 4200, 'time': '1:34', 'avatar': null},
      {'id': '3', 'name': 'خالد العميد', 'points': 3900, 'time': '1:45', 'avatar': null},
      {'id': '4', 'name': 'ياسر القناص', 'points': 3500, 'time': '2:01', 'avatar': null},
      {'id': '5', 'name': 'سلمان العتيبي', 'points': 3200, 'time': '2:15', 'avatar': null}, // Match active user
      {'id': '6', 'name': 'فهد المونديالي', 'points': 3000, 'time': '2:24', 'avatar': null},
      {'id': '7', 'name': 'ماجد السهم', 'points': 2800, 'time': '2:30', 'avatar': null},
    ],
    this.weeklyLeaderboard = const [
      {'id': 'user_1', 'name': 'أحمد الهلالي', 'points': 24500, 'time': '9:12', 'avatar': null},
      {'id': 'user_4', 'name': 'ياسر القناص', 'points': 22000, 'time': '10:04', 'avatar': null},
      {'id': 'user_2', 'name': 'عبدالرحمن النصر', 'points': 21900, 'time': '10:45', 'avatar': null},
      {'id': '5', 'name': 'سلمان العتيبي', 'points': 18500, 'time': '11:15', 'avatar': null},
      {'id': 'user_7', 'name': 'ماجد السهم', 'points': 16000, 'time': '12:30', 'avatar': null},
    ],
    this.allTimeLeaderboard = const [
      {'id': 'user_1', 'name': 'أحمد الهلالي', 'points': 98500, 'time': '40:12', 'avatar': null},
      {'id': 'user_2', 'name': 'عبدالرحمن النصر', 'points': 92000, 'time': '44:45', 'avatar': null},
      {'id': 'user_4', 'name': 'ياسر القناص', 'points': 89000, 'time': '42:01', 'avatar': null},
      {'id': '5', 'name': 'سلمان العتيبي', 'points': 76400, 'time': '48:15', 'avatar': null},
    ],
    this.currentUserId = '5',
    this.onBackToHome,
    this.language = 'ar',
  }) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.language == 'ar';
    
    // Localizations
    final screenTitle = isAr ? 'لوحة المتصدرين' : 'Leaderboards';
    final tabDailyText = isAr ? 'يومي' : 'Daily';
    final tabWeeklyText = isAr ? 'أسبوعي' : 'Weekly';
    final tabAllTimeText = isAr ? 'الكل' : 'All Time';
    final scoreLabel = isAr ? 'نقطة' : 'Pts';

    return Scaffold(
      backgroundColor: const Color(0xFF070E0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1411),
        elevation: 0,
        centerTitle: true,
        title: Text(
          screenTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: widget.onBackToHome,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: const Color(0xFFD4AF37),
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Tajawal'),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
          tabs: [
            Tab(text: tabDailyText),
            Tab(text: tabWeeklyText),
            Tab(text: tabAllTimeText),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab(widget.dailyLeaderboard, scoreLabel),
          _buildLeaderboardTab(widget.weeklyLeaderboard, scoreLabel),
          _buildLeaderboardTab(widget.allTimeLeaderboard, scoreLabel),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(List<Map<String, dynamic>> dataset, String scoreLabel) {
    if (dataset.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد بيانات حالياً',
          style: TextStyle(color: Colors.white60, fontFamily: 'Tajawal'),
        ),
      );
    }

    // Isolate Top 3 for Podium
    final top1 = dataset.isNotEmpty ? dataset[0] : null;
    final top2 = dataset.length > 1 ? dataset[1] : null;
    final top3 = dataset.length > 2 ? dataset[2] : null;

    // Remaining list (Rank 4+)
    final remaining = dataset.length > 3 ? dataset.sublist(3) : <Map<String, dynamic>>[];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Top 3 Podium
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place (Silver)
                if (top2 != null)
                  Expanded(
                    child: _buildPodiumItem(
                      player: top2,
                      rank: 2,
                      podiumHeight: 110,
                      badgeColor: const Color(0xFFC0C0C0), // Silver
                      scoreLabel: scoreLabel,
                    ),
                  ),
                const SizedBox(width: 8),

                // 1st Place (Gold - Taller/Center)
                if (top1 != null)
                  Expanded(
                    child: _buildPodiumItem(
                      player: top1,
                      rank: 1,
                      podiumHeight: 145,
                      badgeColor: const Color(0xFFD4AF37), // Gold
                      scoreLabel: scoreLabel,
                      hasCrown: true,
                    ),
                  ),
                const SizedBox(width: 8),

                // 3rd Place (Bronze)
                if (top3 != null)
                  Expanded(
                    child: _buildPodiumItem(
                      player: top3,
                      rank: 3,
                      podiumHeight: 95,
                      badgeColor: const Color(0xFFCD7F32), // Bronze
                      scoreLabel: scoreLabel,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // 2. Ranks List (Rank 4+)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final player = remaining[index];
                final rank = index + 4;
                final isCurrentUser = player['id'] == widget.currentUserId;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: isCurrentUser 
                        ? const Color(0xFF0C2419) // Highlight Active User in soft green
                        : Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCurrentUser 
                          ? const Color(0xFF006C35) 
                          : Colors.white.withOpacity(0.05),
                      width: isCurrentUser ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Rank number circular badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrentUser ? const Color(0xFF006C35) : Colors.white.withOpacity(0.04),
                          border: Border.all(color: Colors.white12, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            rank.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Avatar/Initials
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isCurrentUser ? const Color(0xFFD4AF37) : const Color(0xFF162520),
                        backgroundImage: player['avatar'] != null ? NetworkImage(player['avatar']) : null,
                        child: player['avatar'] == null
                            ? Text(
                                player['name'].substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: isCurrentUser ? Colors.black : Colors.white60,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'Tajawal',
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),

                      // Player Name
                      Expanded(
                        child: Text(
                          player['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                            fontFamily: 'Tajawal',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Score & Time info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${player['points']} $scoreLabel',
                            style: TextStyle(
                              color: isCurrentUser ? const Color(0xFFD4AF37) : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            player['time'] ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: remaining.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumItem({
    required Map<String, dynamic> player,
    required int rank,
    required double podiumHeight,
    required Color badgeColor,
    required String scoreLabel,
    bool hasCrown = false,
  }) {
    final isCurrentUser = player['id'] == widget.currentUserId;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown (Rank 1 Only)
        if (hasCrown)
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFD4AF37),
            size: 26,
          ),
        const SizedBox(height: 4),

        // Avatar inside Gold/Silver/Bronze Glowing Circular Frame
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF070E0B),
            border: Border.all(color: badgeColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: rank == 1 ? 30 : 25,
            backgroundColor: const Color(0xFF162520),
            backgroundImage: player['avatar'] != null ? NetworkImage(player['avatar']) : null,
            child: player['avatar'] == null
                ? Text(
                    player['name'].substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: rank == 1 ? 20 : 16,
                      fontFamily: 'Tajawal',
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),

        // Player Name
        Text(
          player['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: rank == 1 ? 14 : 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Player Score
        Text(
          '${player['points']} $scoreLabel',
          style: TextStyle(
            color: const Color(0xFFD4AF37),
            fontSize: rank == 1 ? 12 : 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 12),

        // Podium Column
        Container(
          width: double.infinity,
          height: podiumHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                badgeColor.withOpacity(0.15),
                badgeColor.withOpacity(0.04),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              top: BorderSide(color: badgeColor.withOpacity(0.4), width: 2),
              left: BorderSide(color: badgeColor.withOpacity(0.15), width: 1),
              right: BorderSide(color: badgeColor.withOpacity(0.15), width: 1),
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: badgeColor,
                fontSize: rank == 1 ? 28 : 22,
                fontWeight: FontWeight.black,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
