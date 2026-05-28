import 'package:flutter/material.dart';

/// A premium, highly customizable Login Screen for the Saudi Football Quiz.
/// Designed to be architecture-agnostic with clear callbacks and optional parameters.
class LoginScreen extends StatefulWidget {
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final Function(String lang)? onLanguageChanged;
  final String initialLanguage;

  const LoginScreen({
    Key? key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.onLanguageChanged,
    this.initialLanguage = 'ar',
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late String _currentLanguage;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.initialLanguage;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'ar' ? 'en' : 'ar';
    });
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!(_currentLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = _currentLanguage == 'ar';
    
    // Localization Strings
    final title = isAr ? 'تحدي الـ 10 الأوائل' : 'Football Top 10';
    final subtitle = isAr ? 'مسابقة كرة القدم السعودية' : 'Saudi Football Quiz';
    final description = isAr 
        ? 'خمن أفضل 10 لاعبين بناءً على التحدي اليومي. اختبر معلوماتك الرياضية الآن!'
        : 'Guess the top 10 players based on the daily challenge. Test your football knowledge now!';
    final googleBtnText = isAr ? 'تسجيل الدخول باستخدام Google' : 'Sign in with Google';
    final appleBtnText = isAr ? 'تسجيل الدخول باستخدام Apple' : 'Sign in with Apple';
    final termsText = isAr 
        ? 'بدخولك للتطبيق، أنت توافق على الشروط والأحكام'
        : 'By signing in, you agree to our Terms & Conditions';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F261C), // Deep Forest Green
              Color(0xFF08120E), // Obsidian Dark Green/Black
              Color(0xFF030504), // Solid Pitch Black
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Custom soccer field background lines (Decorative)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: CustomPaint(
                    painter: _SoccerFieldPainter(),
                  ),
                ),
              ),

              // Language Toggle (Top Corner)
              Positioned(
                top: 16,
                right: isAr ? null : 16,
                left: isAr ? 16 : null,
                child: TextButton.icon(
                  onPressed: _toggleLanguage,
                  icon: const Icon(Icons.language, color: Color(0xFFD4AF37), size: 20), // Gold Icon
                  label: Text(
                    isAr ? 'English' : 'العربية',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                    ),
                  ),
                ),
              ),

              // Main login layout
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glowing Football Logo Placeholder
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF006C35), Color(0xFFD4AF37)], // Saudi Green to Gold
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF006C35).withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.sports_soccer,
                              size: 70,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFD4AF37), // Gold Color
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Glassmorphism Card for Description & Buttons
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  fontFamily: 'Tajawal',
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Google Login Button
                              _buildLoginButton(
                                icon: Icons.g_mobiledata_rounded,
                                label: googleBtnText,
                                color: Colors.white,
                                textColor: Colors.black87,
                                iconColor: Colors.redAccent,
                                onPressed: widget.onGoogleSignIn,
                              ),
                              const SizedBox(height: 16),

                              // Apple Login Button
                              _buildLoginButton(
                                icon: Icons.apple,
                                label: appleBtnText,
                                color: const Color(0xFF1A1A1A),
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                isOutline: true,
                                onPressed: widget.onAppleSignIn,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Footer Text
                        Text(
                          termsText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required Color iconColor,
    bool isOutline = false,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isOutline 
                ? BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter to draw decorative football pitch lines on screen background
class _SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      80.0,
      paint,
    );

    // Draw center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Draw top penalty box
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height * 0.18),
      paint,
    );

    // Draw bottom penalty box
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.82, size.width * 0.7, size.height * 0.18),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
