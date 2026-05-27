import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Chip selector widget ────────────────────────────────────────────────
class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF0F0F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

// ── Sport tag pill ───────────────────────────────────────────────────────
class SportTag extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const SportTag({
    super.key,
    required this.label,
    this.bg = AppColors.primaryLight,
    this.fg = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ── Avatar circle ────────────────────────────────────────────────────────
class PlayerAvatar extends StatelessWidget {
  final String initials;
  final double size;

  const PlayerAvatar({super.key, required this.initials, this.size = 48});

  static const _colors = [
    [Color(0xFFE6F1FB), Color(0xFF185FA5)],
    [Color(0xFFEAF3DE), Color(0xFF3B6D11)],
    [Color(0xFFEEEDFE), Color(0xFF534AB7)],
    [Color(0xFFFFE8DE), Color(0xFFCC5000)],
    [Color(0xFFFBEAF0), Color(0xFF993556)],
  ];

  @override
  Widget build(BuildContext context) {
    final idx = initials.isNotEmpty ? initials.codeUnitAt(0) % _colors.length : 0;
    final pair = _colors[idx];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pair[0],
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.outfit(
            fontSize: size * 0.33,
            fontWeight: FontWeight.w700,
            color: pair[1],
          ),
        ),
      ),
    );
  }
}

// ── Section card wrapper ─────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
