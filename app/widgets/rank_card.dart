import 'package:flutter/material.dart';

/// A premium, reusable Rank Card Widget for the Saudi Football Quiz Leaderboard.
/// Displays user profile details, scores, ranking ranks, and elapsed time with customizable styling.
class RankCard extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String? time;
  final String? avatarUrl;
  final bool isCurrentUser;
  final VoidCallback? onTap;
  final String language;

  const RankCard({
    Key? key,
    required this.rank,
    required this.name,
    required this.points,
    this.time,
    this.avatarUrl,
    this.isCurrentUser = false,
    this.onTap,
    this.language = 'ar',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAr = language == 'ar';
    final ptsText = isAr ? 'نقطة' : 'Pts';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isCurrentUser 
              ? const Color(0xFF0C2419) // Glowing deep green for active user
              : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentUser 
                ? const Color(0xFF006C35) // Saudi Green border for active user
                : Colors.white.withOpacity(0.05),
            width: isCurrentUser ? 1.5 : 1,
          ),
          boxShadow: isCurrentUser 
              ? [
                  BoxShadow(
                    color: const Color(0xFF006C35).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // 1. Rank Circular Badge
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrentUser 
                    ? const Color(0xFF006C35) 
                    : Colors.white.withOpacity(0.04),
                border: Border.all(
                  color: isCurrentUser 
                      ? const Color(0xFFD4AF37).withOpacity(0.5) 
                      : Colors.white.withOpacity(0.1),
                  width: 0.8,
                ),
              ),
              child: Center(
                child: Text(
                  rank.toString(),
                  style: TextStyle(
                    color: isCurrentUser ? const Color(0xFFD4AF37) : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // 2. Avatar with dynamic initial letter fallback
            CircleAvatar(
              radius: 18,
              backgroundColor: isCurrentUser ? const Color(0xFFD4AF37) : const Color(0xFF162520),
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
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

            // 3. User Name (Flexible to handle long names)
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                  fontFamily: 'Tajawal',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 4. Points & Time consumed Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$points $ptsText',
                  style: TextStyle(
                    color: isCurrentUser ? const Color(0xFFD4AF37) : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                if (time != null && time!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    time!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
