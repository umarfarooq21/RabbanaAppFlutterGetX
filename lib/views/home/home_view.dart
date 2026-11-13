import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/duas_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/rabbana_dua.dart';
import '../../theme/app_colors.dart';
import 'widgets/dua_list_card.dart';
import 'widgets/home_header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.nightDeep,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E3B30),
              AppColors.night,
              AppColors.nightDeep,
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Obx(
                () => HomeHeader(
                  duaCount: controller.duasController.duas.length,
                  favoriteCount: controller.favoritesController.count,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Obx(
                  () => _SearchField(
                    controller: controller.searchController,
                    hasText: controller.query.value.isNotEmpty,
                    onChanged: controller.onSearchChanged,
                    onClear: controller.clearSearch,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Row(
                    children: [
                      _FilterChip(
                        label: 'All Duas',
                        selected: controller.filter.value == HomeFilter.all,
                        onTap: () => controller.setFilter(HomeFilter.all),
                      ),
                      const SizedBox(width: 10),
                      _FilterChip(
                        label: 'Favorites',
                        selected:
                            controller.filter.value == HomeFilter.favorites,
                        trailing: controller.favoritesController.count > 0
                            ? '${controller.favoritesController.count}'
                            : null,
                        onTap: () =>
                            controller.setFilter(HomeFilter.favorites),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  final visible = controller.visibleDuas;
                  return _HomeBody(
                    duasController: controller.duasController,
                    visible: visible,
                    filter: controller.filter.value,
                    query: controller.query.value,
                    onOpen: controller.openDua,
                    onRetry: controller.retryLoad,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hasText,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.outfit(
        color: AppColors.ivory,
        fontSize: 15,
      ),
      cursorColor: AppColors.gold,
      decoration: InputDecoration(
        hintText: 'Search by meaning, number, or surah…',
        hintStyle: GoogleFonts.outfit(
          color: AppColors.mist.withValues(alpha: 0.55),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.gold.withValues(alpha: 0.85),
        ),
        suffixIcon: hasText
            ? IconButton(
                onPressed: onClear,
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.mist.withValues(alpha: 0.7),
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.18),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.18),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: selected
                ? AppColors.gold.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: selected
                  ? AppColors.gold.withValues(alpha: 0.55)
                  : AppColors.gold.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: selected ? AppColors.goldSoft : AppColors.mist,
                  fontSize: 13.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    trailing!,
                    style: GoogleFonts.outfit(
                      color: AppColors.goldSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.duasController,
    required this.visible,
    required this.filter,
    required this.query,
    required this.onOpen,
    required this.onRetry,
  });

  final DuasController duasController;
  final List<RabbanaDua> visible;
  final HomeFilter filter;
  final String query;
  final ValueChanged<RabbanaDua> onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (duasController.isLoading && !duasController.hasData) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      );
    }

    if (duasController.state.value == DuasLoadState.error &&
        !duasController.hasData) {
      return _EmptyState(
        title: 'Couldn’t load duas',
        subtitle: duasController.errorMessage.value ?? 'Please try again.',
        actionLabel: 'Retry',
        onAction: onRetry,
      );
    }

    if (visible.isEmpty) {
      final isFavorites = filter == HomeFilter.favorites;
      return _EmptyState(
        title: isFavorites ? 'No favorites yet' : 'No matches found',
        subtitle: isFavorites
            ? 'Tap the heart on any dua to save it here.'
            : 'Try a different search for “$query”.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final dua = visible[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == visible.length - 1 ? 0 : 12),
          child: DuaListCard(
            dua: dua,
            index: index,
            onTap: () => onOpen(dua),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 42,
              color: AppColors.gold.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                color: AppColors.ivory,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppColors.mist,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.outfit(
                    color: AppColors.goldSoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
