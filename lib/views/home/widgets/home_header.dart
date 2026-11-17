import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';

import '../../../theme/app_palette.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.duaCount,
    required this.favoriteCount,
  });

  final int duaCount;
  final int favoriteCount;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رَبَّنَا',
                      style: GoogleFonts.amiri(
                        color: p.accentText,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '40 Rabbana',
                      style: GoogleFonts.cormorantGaramond(
                        color: p.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: 'Settings',
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.settings),
                    customBorder: const CircleBorder(),
                    child: Ink(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: p.accent.withValues(alpha: 0.35),
                        ),
                        gradient: RadialGradient(
                          colors: [p.orbCenter, p.orbEdge],
                        ),
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        color: p.accentText.withValues(alpha: 0.9),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Forty beautiful duas from the Qur’an',
            style: GoogleFonts.outfit(
              color: p.textSecondary,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatPill(label: 'Duas', value: '$duaCount'),
              const SizedBox(width: 10),
              _StatPill(label: 'Saved', value: '$favoriteCount'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: p.surface,
        border: Border.all(color: p.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              color: p.accentText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: p.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
