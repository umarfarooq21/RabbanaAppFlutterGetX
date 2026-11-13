import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/rabbana_dua.dart';
import '../../../theme/app_colors.dart';

class DuaAudioPlayer extends StatefulWidget {
  const DuaAudioPlayer({super.key, required this.dua});

  final RabbanaDua dua;

  @override
  State<DuaAudioPlayer> createState() => _DuaAudioPlayerState();
}

class _DuaAudioPlayerState extends State<DuaAudioPlayer>
    with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  late final AnimationController _waveController;

  bool _ready = false;
  bool _loading = true;
  bool _speaking = false;
  bool _paused = false;
  double _progress = 0;
  String? _error;

  String get _spokenArabic => widget.dua.arabic.trim();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _initTts();
  }

  @override
  void didUpdateWidget(covariant DuaAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dua.id != widget.dua.id) {
      _stopPlayback(resetProgress: true);
    }
  }

  Future<void> _initTts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      _tts.setStartHandler(() {
        if (!mounted) return;
        setState(() {
          _speaking = true;
          _paused = false;
        });
        _waveController.repeat();
      });

      _tts.setCompletionHandler(() {
        if (!mounted) return;
        _waveController.stop();
        _waveController.value = 0;
        setState(() {
          _speaking = false;
          _paused = false;
          _progress = 1;
        });
      });

      _tts.setCancelHandler(() {
        if (!mounted) return;
        _waveController.stop();
        _waveController.value = 0;
        setState(() {
          _speaking = false;
          _paused = false;
        });
      });

      _tts.setPauseHandler(() {
        if (!mounted) return;
        _waveController.stop();
        setState(() {
          _speaking = false;
          _paused = true;
        });
      });

      _tts.setContinueHandler(() {
        if (!mounted) return;
        _waveController.repeat();
        setState(() {
          _speaking = true;
          _paused = false;
        });
      });

      _tts.setErrorHandler((message) {
        if (!mounted) return;
        _waveController.stop();
        setState(() {
          _speaking = false;
          _paused = false;
          _error = 'Unable to play this dua audio.';
        });
      });

      _tts.setProgressHandler((text, start, end, word) {
        if (!mounted || text.isEmpty) return;
        setState(() {
          _progress = (end / text.length).clamp(0.0, 1.0);
        });
      });

      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      // Prefer a clear Arabic voice when the platform exposes one.
      final voices = await _tts.getVoices;
      if (voices is List) {
        final arabicVoices = voices.whereType<Map>().where((voice) {
          final locale = '${voice['locale'] ?? ''}.'.toLowerCase();
          return locale.startsWith('ar');
        }).toList();
        if (arabicVoices.isNotEmpty) {
          final preferred = Map<String, String>.from(
            arabicVoices.first.map(
              (key, value) => MapEntry('$key', '$value'),
            ),
          );
          await _tts.setVoice(preferred);
        }
      }

      if (!mounted) return;
      setState(() {
        _ready = true;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _ready = false;
        _loading = false;
        _error = 'Arabic speech is unavailable on this device.';
      });
    }
  }

  Future<void> _togglePlay() async {
    if (!_ready || _spokenArabic.isEmpty) return;

    if (_speaking) {
      await _tts.pause();
      return;
    }

    if (_paused) {
      await _tts.speak(_spokenArabic);
      return;
    }

    setState(() => _progress = 0);
    await _tts.stop();
    await _tts.speak(_spokenArabic);
  }

  Future<void> _replay() async {
    if (!_ready || _spokenArabic.isEmpty) return;
    await _tts.stop();
    setState(() {
      _progress = 0;
      _paused = false;
      _speaking = false;
    });
    await _tts.speak(_spokenArabic);
  }

  Future<void> _stopPlayback({bool resetProgress = false}) async {
    await _tts.stop();
    _waveController.stop();
    _waveController.value = 0;
    if (!mounted) return;
    setState(() {
      _speaking = false;
      _paused = false;
      if (resetProgress) _progress = 0;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _speaking;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.emerald.withValues(alpha: 0.45),
            Colors.white.withValues(alpha: 0.05),
            AppColors.night.withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: active ? 0.14 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(
                  Icons.graphic_eq_rounded,
                  color: AppColors.goldSoft.withValues(alpha: 0.95),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Listen to this dua',
                      style: GoogleFonts.cormorantGaramond(
                        color: AppColors.ivory,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Speaks the Arabic on screen',
                      style: GoogleFonts.outfit(
                        color: AppColors.mist,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, _) {
                  return _MiniWaveform(
                    active: active,
                    t: _waveController.value,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_error != null) ...[
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppColors.goldSoft.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _initTts,
              child: Text(
                'Try again',
                style: GoogleFonts.outfit(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else ...[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3.5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: AppColors.gold,
                inactiveTrackColor: AppColors.gold.withValues(alpha: 0.18),
                thumbColor: AppColors.goldSoft,
                overlayColor: AppColors.gold.withValues(alpha: 0.18),
              ),
              child: Slider(
                value: _progress,
                onChanged: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    active
                        ? 'Playing on-screen Arabic'
                        : (_paused ? 'Paused' : 'Ready'),
                    style: GoogleFonts.outfit(
                      color: AppColors.mist,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(_progress * 100).round()}%',
                    style: GoogleFonts.outfit(
                      color: AppColors.mist,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PlayerIconButton(
                  icon: Icons.replay_rounded,
                  onTap: _ready ? _replay : null,
                ),
                const SizedBox(width: 18),
                _PlayButton(
                  loading: _loading,
                  playing: _speaking,
                  onTap: _togglePlay,
                ),
                const SizedBox(width: 18),
                _PlayerIconButton(
                  icon: Icons.stop_rounded,
                  onTap: _ready
                      ? () => _stopPlayback(resetProgress: true)
                      : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.loading,
    required this.playing,
    required this.onTap,
  });

  final bool loading;
  final bool playing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.goldSoft,
                AppColors.gold,
                AppColors.emeraldSoft,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.nightDeep,
                    ),
                  )
                : Icon(
                    playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: AppColors.nightDeep,
                    size: 36,
                  ),
          ),
        ),
      ),
    );
  }
}

class _PlayerIconButton extends StatelessWidget {
  const _PlayerIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: onTap == null
            ? AppColors.mist.withValues(alpha: 0.35)
            : AppColors.goldSoft,
        size: 28,
      ),
    );
  }
}

class _MiniWaveform extends StatelessWidget {
  const _MiniWaveform({required this.active, required this.t});

  final bool active;
  final double t;

  @override
  Widget build(BuildContext context) {
    const heights = [0.35, 0.7, 1.0, 0.55, 0.85, 0.45];
    return SizedBox(
      width: 42,
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++)
            Container(
              width: 3.5,
              height: 22 *
                  (active
                      ? (0.28 +
                          heights[i] *
                              (0.45 +
                                  0.55 *
                                      ((math.sin((t * math.pi * 2) + i) + 1) /
                                          2)))
                      : heights[i] * 0.45),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppColors.gold.withValues(alpha: active ? 0.9 : 0.35),
              ),
            ),
        ],
      ),
    );
  }
}
