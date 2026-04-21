import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

/// Owner shell — hosts bottom navigation for:
/// Dashboard · Bookings · Analytics · Profile
///
/// Placeholder scaffold — replace each tab with real screens as built.
class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _tab = 0;

  static const _tabs = [
    (Icons.dashboard_rounded,   Icons.dashboard_outlined,     'Dashboard'),
    (Icons.book_online_rounded, Icons.book_online_outlined,   'Bookings'),
    (Icons.bar_chart_rounded,   Icons.bar_chart_outlined,     'Analytics'),
    (Icons.person_rounded,      Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: AppColors.dark.background,
        body: SafeArea(child: _tabBody()),
        bottomNavigationBar: _OwnerBottomNav(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          tabs: _tabs,
        ),
      ),
    );
  }

  Widget _tabBody() {
    if (_tab == 3) return _OwnerProfileTab();
    final labels = ['Dashboard', 'Bookings', 'Analytics'];
    return Center(
      child: Text(
        labels[_tab],
        style: GoogleFonts.lexend(
          color: AppColors.dark.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _OwnerProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.store_rounded, color: AppColors.primary, size: 64),
          const SizedBox(height: 16),
          Text(
            'Owner Profile',
            style: GoogleFonts.lexend(
              color: AppColors.dark.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),
          _SignOutButton(),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context.read<AuthCubit>().signOut();
        if (context.mounted) context.go('/login');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.darkSemantic.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Sign Out',
          style: GoogleFonts.manrope(
            color: AppColors.darkSemantic.error,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _OwnerBottomNav extends StatelessWidget {
  const _OwnerBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<(IconData, IconData, String)> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.dark.navBar,
        border: Border(
          top: BorderSide(color: AppColors.dark.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final (activeIcon, inactiveIcon, label) = tabs[i];
          final active = currentIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      active ? activeIcon : inactiveIcon,
                      key: ValueKey(active),
                      color: active ? AppColors.primary : AppColors.dark.textMuted,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      color: active ? AppColors.primary : AppColors.dark.textMuted,
                      fontSize: 11,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
