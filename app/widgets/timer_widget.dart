import 'package:flutter/material.dart';

/// A premium, highly animated Timer and Countdown Widget for the Saudi Football Quiz.
/// Displays a sleek digital countdown, shrinking progress bar, and pulsating red warnings when low.
class TimerWidget extends StatefulWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isTimerMode;
  final String language;

  const TimerWidget({
    Key? key,
    required this.remainingSeconds,
    this.totalSeconds = 120,
    this.isTimerMode = true,
    this.language = 'ar',
  }) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Start pulsing when time is running low (< 30 seconds) in Timer Mode
    if (widget.isTimerMode && widget.remainingSeconds <= 30 && widget.remainingSeconds > 0) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isTimerMode) {
      // Infinite/Normal Mode UI
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.all_inclusive_rounded, color: Color(0xFFD4AF37), size: 24),
        ],
      );
    }

    final isAr = widget.language == 'ar';
    final timerTitle = isAr ? 'المؤقت' : 'Timer';
    final isLowTime = widget.remainingSeconds <= 30;

    // Formatting nicely as MM:SS
    final minutes = (widget.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (widget.remainingSeconds % 60).toString().padLeft(2, '0');
    final timerText = '$minutes:$seconds';

    // Calculate percentage remaining for the progress bar
    final double percentRemaining = (widget.remainingSeconds / widget.totalSeconds).clamp(0.0, 1.0);

    // Color definitions
    final themeColor = isLowTime ? Colors.redAccent : const Color(0xFFD4AF37); // Red vs Gold

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLowTime ? Colors.redAccent.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Sleek Icon + Pulsating Digital Numbers
          ScaleTransition(
            scale: isLowTime ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: themeColor,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  timerText,
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    shadows: isLowTime 
                        ? [Shadow(color: Colors.red.withOpacity(0.5), blurRadius: 8)]
                        : [],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // 2. Shrinking Progress Bar
          Container(
            width: 70,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width: 70 * percentRemaining,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: isLowTime 
                          ? [Colors.red, Colors.redAccent] 
                          : [const Color(0xFF006C35), const Color(0xFFD4AF37)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
