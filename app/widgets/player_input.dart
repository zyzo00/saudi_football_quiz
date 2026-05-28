import 'package:flutter/material.dart';

/// A premium, highly polished input field widget for the Saudi Football Quiz.
/// Handles text input, styling, and displays autocomplete suggestions in a clean floating layer.
class PlayerInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<Map<String, dynamic>> suggestions;
  final Function(String name)? onSuggestionTap;
  final VoidCallback? onGuessPressed;
  final String language;

  const PlayerInput({
    Key? key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.onGuessPressed,
    this.language = 'ar',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAr = language == 'ar';
    final placeholder = isAr ? 'اكتب اسم لاعب لتخمينه...' : 'Type player name to guess...';
    final buttonText = isAr ? 'تخمين' : 'Guess';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Floating Autocomplete Suggestions Panel (Sits above input in layout)
        if (suggestions.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF13221C), // Deep forest green/obsidian
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF006C35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.04),
                ),
                itemBuilder: (context, index) {
                  final player = suggestions[index];
                  final displayName = isAr ? player['name_ar'] : player['name_en'];
                  final flag = player['flag'] ?? '⚽';
                  
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Text(flag, style: const TextStyle(fontSize: 18)),
                    title: Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                      size: 12,
                    ),
                    onTap: () {
                      if (onSuggestionTap != null) {
                        onSuggestionTap!(displayName);
                      }
                    },
                  );
                },
              ),
            ),
          ),

        // 2. The Input Field + Guess Button Row
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Tajawal'),
                  cursorColor: const Color(0xFFD4AF37),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 13,
                      fontFamily: 'Tajawal',
                    ),
                    prefixIcon: Icon(
                      Icons.sports_soccer_rounded,
                      color: Colors.white.withOpacity(0.4),
                      size: 20,
                    ),
                    fillColor: Colors.white.withOpacity(0.04),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Guess button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onGuessPressed ?? () {
                  if (onSubmitted != null) {
                    onSubmitted!(controller.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006C35), // Saudi Green
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
