import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/duas_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_theme.dart';
import 'widgets/dua_audio_player.dart';

class DuaDetailView extends StatelessWidget {
  const DuaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final duaId = Get.arguments as int;
    final duasController = Get.find<DuasController>();
    final favoritesController = Get.find<FavoritesController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final dua = duasController.byId(duaId);
      final isFavorite = dua != null && favoritesController.isFavorite(dua.id);
      final fontScale = settingsController.fontScale.value;
      final showTransliteration = settingsController.showTransliteration.value;
      final showTranslation = settingsController.showTranslation.value;

      // Touch observables so Obx rebuilds on favorites/duas changes.
      favoritesController.favoriteIds.length;
      duasController.duas.length;

      if (dua == null) {
        return Scaffold(
          backgroundColor: p.background.last,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: p.textPrimary,
            leading: IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
          body: Center(
            child: Text(
              'Dua not found',
              style: TextStyle(color: p.textPrimary),
            ),
          ),
        );
      }

      return Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: p.textPrimary,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Rabbana ${dua.number}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            color: p.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => favoritesController.toggle(dua.id),
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? p.accent : p.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          dua.reference,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: p.accent.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 22),
                        DuaAudioPlayer(dua: dua),
                        const SizedBox(height: 28),
                        Text(
                          dua.arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            color: p.textPrimary,
                            fontSize: 30 * fontScale,
                            height: 1.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (showTransliteration) ...[
                          const SizedBox(height: 28),
                          const _SectionLabel(text: 'Transliteration'),
                          const SizedBox(height: 10),
                          Text(
                            dua.transliteration,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: p.accentText.withValues(alpha: 0.9),
                              fontSize: 15.5 * fontScale,
                              height: 1.55,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        if (showTranslation) ...[
                          const SizedBox(height: 28),
                          const _SectionLabel(text: 'Meaning'),
                          const SizedBox(height: 10),
                          Text(
                            dua.translation,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: p.textSecondary,
                              fontSize: 16 * fontScale,
                              height: 1.6,
                            ),
                          ),
                        ],
                        const SizedBox(height: 36),
                        Center(
                          child: TextButton.icon(
                            onPressed: () async {
                              final text = StringBuffer()
                                ..writeln(dua.arabic)
                                ..writeln()
                                ..writeln(dua.transliteration)
                                ..writeln()
                                ..writeln(dua.translation)
                                ..writeln()
                                ..writeln(dua.reference);
                              await Clipboard.setData(
                                ClipboardData(text: text.toString()),
                              );
                              Get.snackbar(
                                'Copied',
                                'Dua copied',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.emerald,
                                colorText: AppColors.ivory,
                                margin: const EdgeInsets.all(16),
                                duration: const Duration(seconds: 2),
                              );
                            },
                            icon: Icon(
                              Icons.copy_rounded,
                              color: p.accentText,
                              size: 18,
                            ),
                            label: Text(
                              'Copy dua',
                              style: GoogleFonts.outfit(
                                color: p.accentText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: GoogleFonts.outfit(
        color: p.accent.withValues(alpha: 0.65),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
      ),
    );
  }
}
