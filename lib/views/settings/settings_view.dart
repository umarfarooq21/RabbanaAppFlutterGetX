import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_theme.dart';

const _appVersion = '1.0.0';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final settings = Get.find<SettingsController>();
    final favorites = Get.find<FavoritesController>();

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
                      tooltip: 'Back',
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: p.textPrimary,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          color: p.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Balances the back button so the title stays centered.
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  children: [
                    const _SectionLabel('Appearance'),
                    _Card(
                      children: [
                        _RowHeader(
                          icon: Icons.palette_outlined,
                          title: 'Theme',
                          subtitle: 'Follow your device, or pick one',
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => _SegmentedPicker<ThemeMode>(
                            value: settings.themeMode.value,
                            onChanged: settings.setThemeMode,
                            options: const [
                              (
                                ThemeMode.system,
                                'System',
                                Icons.brightness_auto_rounded,
                              ),
                              (
                                ThemeMode.light,
                                'Light',
                                Icons.light_mode_rounded,
                              ),
                              (ThemeMode.dark, 'Dark', Icons.dark_mode_rounded),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const _SectionLabel('Reading'),
                    _Card(
                      children: [
                        _RowHeader(
                          icon: Icons.format_size_rounded,
                          title: 'Text size',
                          trailing: Obx(
                            () => Text(
                              '${(settings.fontScale.value * 100).round()}%',
                              style: GoogleFonts.outfit(
                                color: p.accentText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => _FontScaleSlider(
                            value: settings.fontScale.value,
                            onChanged: settings.setFontScale,
                          ),
                        ),
                        Obx(
                          () => _TextPreview(
                            scale: settings.fontScale.value,
                            showTransliteration:
                                settings.showTransliteration.value,
                            showTranslation: settings.showTranslation.value,
                          ),
                        ),
                        const _Divider(),
                        Obx(
                          () => _SwitchRow(
                            icon: Icons.translate_rounded,
                            title: 'Show transliteration',
                            subtitle: 'Arabic written in English letters',
                            value: settings.showTransliteration.value,
                            onChanged: settings.setShowTransliteration,
                          ),
                        ),
                        const _Divider(),
                        Obx(
                          () => _SwitchRow(
                            icon: Icons.menu_book_rounded,
                            title: 'Show meaning',
                            subtitle: 'English translation of each dua',
                            value: settings.showTranslation.value,
                            onChanged: settings.setShowTranslation,
                          ),
                        ),
                      ],
                    ),
                    const _SectionLabel('Recitation'),
                    _Card(
                      children: [
                        const _RowHeader(
                          icon: Icons.graphic_eq_rounded,
                          title: 'Speed',
                          subtitle: 'How fast the Arabic is read aloud',
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => _SegmentedPicker<RecitationSpeed>(
                            value: settings.recitationSpeed.value,
                            onChanged: settings.setRecitationSpeed,
                            options: [
                              for (final s in RecitationSpeed.values)
                                (s, s.label, null),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const _SectionLabel('Data'),
                    _Card(
                      children: [
                        Obx(
                          () => _ActionRow(
                            icon: Icons.favorite_border_rounded,
                            title: 'Clear favorites',
                            subtitle: favorites.count == 0
                                ? 'No saved duas'
                                : '${favorites.count} saved '
                                      '${favorites.count == 1 ? 'dua' : 'duas'}',
                            onTap: favorites.count == 0
                                ? null
                                : () => _confirm(
                                    context,
                                    title: 'Clear favorites?',
                                    message:
                                        'This removes all ${favorites.count} '
                                        'saved duas. This cannot be undone.',
                                    action: 'Clear',
                                    onConfirm: favorites.clear,
                                  ),
                          ),
                        ),
                        const _Divider(),
                        _ActionRow(
                          icon: Icons.restart_alt_rounded,
                          title: 'Reset settings',
                          subtitle: 'Restore theme, text and audio defaults',
                          onTap: () => _confirm(
                            context,
                            title: 'Reset settings?',
                            message:
                                'Theme, text size, display and recitation '
                                'options go back to their defaults. Your '
                                'favorites are kept.',
                            action: 'Reset',
                            onConfirm: settings.resetToDefaults,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const _AboutFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
    required Future<void> Function() onConfirm,
  }) async {
    final p = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.isDarkTheme
            ? AppColors.night
            : const Color(0xFFFBF7EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: p.accent.withValues(alpha: 0.25)),
        ),
        title: Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            color: p.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.outfit(
            color: p.textSecondary,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: p.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              action,
              style: GoogleFonts.outfit(
                color: p.accentText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await onConfirm();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 22, 6, 10),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.outfit(
          color: context.palette.accent.withValues(alpha: 0.8),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.surfaceHigh, p.surfaceLow],
        ),
        border: Border.all(color: p.accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        color: context.palette.accent.withValues(alpha: 0.14),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble(this.icon, {this.dimmed = false});

  final IconData icon;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p.accent.withValues(alpha: dimmed ? 0.06 : 0.14),
        border: Border.all(
          color: p.accent.withValues(alpha: dimmed ? 0.15 : 0.32),
        ),
      ),
      child: Icon(
        icon,
        size: 18,
        color: p.accentText.withValues(alpha: dimmed ? 0.4 : 0.95),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  const _RowText({required this.title, this.subtitle, this.dimmed = false});

  final String title;
  final String? subtitle;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: dimmed
                ? p.textPrimary.withValues(alpha: 0.45)
                : p.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: GoogleFonts.outfit(
              color: p.textSecondary.withValues(alpha: dimmed ? 0.45 : 0.8),
              fontSize: 12.5,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

class _RowHeader extends StatelessWidget {
  const _RowHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBubble(icon),
        const SizedBox(width: 12),
        Expanded(
          child: _RowText(title: title, subtitle: subtitle),
        ),
        ?trailing,
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          _IconBubble(icon),
          const SizedBox(width: 12),
          Expanded(
            child: _RowText(title: title, subtitle: subtitle),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.ivory,
            activeTrackColor: AppColors.emeraldSoft,
            inactiveThumbColor: p.accentText.withValues(alpha: 0.8),
            inactiveTrackColor: p.surface,
            trackOutlineColor: WidgetStatePropertyAll(
              p.accent.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            _IconBubble(icon, dimmed: !enabled),
            const SizedBox(width: 12),
            Expanded(
              child: _RowText(
                title: title,
                subtitle: subtitle,
                dimmed: !enabled,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.palette.textSecondary.withValues(
                alpha: enabled ? 0.7 : 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedPicker<T> extends StatelessWidget {
  const _SegmentedPicker({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<(T, String, IconData?)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: p.surface,
        border: Border.all(color: p.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          for (final (option, label, icon) in options)
            Expanded(
              child: Semantics(
                selected: option == value,
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: option == value
                          ? p.accent.withValues(alpha: 0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: option == value
                            ? p.accent.withValues(alpha: 0.55)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 16,
                            color: option == value
                                ? p.accentText
                                : p.textSecondary,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: option == value
                                  ? p.accentText
                                  : p.textSecondary,
                              fontSize: 13.5,
                              fontWeight: option == value
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FontScaleSlider extends StatelessWidget {
  const _FontScaleSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final small = GoogleFonts.outfit(color: p.textSecondary, fontSize: 12);
    final large = GoogleFonts.outfit(color: p.textSecondary, fontSize: 18);
    return Row(
      children: [
        Text('A', style: small),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3.5,
              activeTrackColor: p.accent,
              inactiveTrackColor: p.accent.withValues(alpha: 0.18),
              thumbColor: p.accentText,
              overlayColor: p.accent.withValues(alpha: 0.18),
              tickMarkShape: SliderTickMarkShape.noTickMark,
            ),
            child: Slider(
              value: value,
              min: SettingsController.minFontScale,
              max: SettingsController.maxFontScale,
              divisions: 11,
              label: '${(value * 100).round()}%',
              onChanged: onChanged,
            ),
          ),
        ),
        Text('A', style: large),
      ],
    );
  }
}

class _TextPreview extends StatelessWidget {
  const _TextPreview({
    required this.scale,
    required this.showTransliteration,
    required this.showTranslation,
  });

  final double scale;
  final bool showTransliteration;
  final bool showTranslation;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: p.surfaceLow,
          border: Border.all(color: p.accent.withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            Text(
              'رَبَّنَا تَقَبَّلْ مِنَّا',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                color: p.textPrimary,
                fontSize: 30 * scale,
                height: 1.7,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (showTransliteration) ...[
              const SizedBox(height: 4),
              Text(
                'Rabbana taqabbal minna',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: p.accentText.withValues(alpha: 0.9),
                  fontSize: 15.5 * scale,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (showTranslation) ...[
              const SizedBox(height: 6),
              Text(
                'Our Lord, accept [this] from us.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: p.textSecondary,
                  fontSize: 16 * scale,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AboutFooter extends StatelessWidget {
  const _AboutFooter();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      children: [
        Text(
          'رَبَّنَا',
          style: GoogleFonts.amiri(
            color: p.accentText,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '40 Rabbana',
          style: GoogleFonts.cormorantGaramond(
            color: p.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version $_appVersion',
          style: GoogleFonts.outfit(
            color: p.textSecondary.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
