import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/stats_model.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_widgets.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HackatimeStats? _stats;
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  String? _error;
  String _selectedRange = '7 days';
  late AnimationController _refreshController;

  final List<String> _ranges = ['7 days', '14 days', '30 days'];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final days = _selectedRange == '7 days' ? 7 : _selectedRange == '14 days' ? 14 : 30;
      final end = DateTime.now();
      final start = end.subtract(Duration(days: days));

      final results = await Future.wait([
        ApiService.getCurrentUser(),
        ApiService.getSummaries(start: start, end: end),
      ]);

      setState(() {
        _user = results[0] as Map<String, dynamic>?;
        _stats = results[1] as HackatimeStats?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data';
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    _refreshController.repeat();
    await _loadData();
    _refreshController.stop();
    _refreshController.reset();
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SettingsSheet(
        onLogout: () async {
          await ApiService.clearCredentials();
          if (mounted) {
            Navigator.of(context).pop();
            // Force rebuild the app
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const _LogoutRedirect()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.3, -0.8),
                  radius: 1.2,
                  colors: [
                    AppTheme.accentPurple.withOpacity(0.12),
                    AppTheme.background,
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppTheme.accentBlue,
              backgroundColor: AppTheme.cardColor,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _user?['display_name'] ?? _user?['username'] ?? 'Coder',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              RotationTransition(
                                turns: _refreshController,
                                child: IconButton(
                                  onPressed: _refresh,
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _showSettings,
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Range selector
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: _RangeSelector(
                        ranges: _ranges,
                        selected: _selectedRange,
                        onSelect: (range) {
                          setState(() => _selectedRange = range);
                          _loadData();
                        },
                      ),
                    ),
                  ),
                  // Content
                  if (_isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (_error != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppTheme.accentPink,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_stats != null) ...[
                    // Total time card
                    SliverToBoxAdapter(
                      child: TotalTimeCard(
                        totalTime: _stats!.totalTime,
                        dailyAverage: _stats!.dailyAverage,
                        totalSeconds: _stats!.totalSeconds,
                      ),
                    ),
                    // Activity chart
                    SliverToBoxAdapter(
                      child: ActivityChartCard(
                        dailyStats: _stats!.dailyStats,
                      ),
                    ),
                    // Languages
                    if (_stats!.languages.isNotEmpty)
                      SliverToBoxAdapter(
                        child: LanguageBreakdownCard(
                          languages: _stats!.languages,
                        ),
                      ),
                    // Projects
                    if (_stats!.projects.isNotEmpty)
                      SliverToBoxAdapter(
                        child: ProjectsCard(
                          projects: _stats!.projects,
                        ),
                      ),
                    // Editors
                    if (_stats!.editors.isNotEmpty)
                      SliverToBoxAdapter(
                        child: EditorsCard(
                          editors: _stats!.editors,
                        ),
                      ),
                    // Bottom padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ] else
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hourglass_empty_rounded,
                              color: AppTheme.textTertiary,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No coding activity yet',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start coding to see your stats!',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _RangeSelector extends StatelessWidget {
  final List<String> ranges;
  final String selected;
  final ValueChanged<String> onSelect;

  const _RangeSelector({
    required this.ranges,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: ranges.map((range) {
              final isSelected = range == selected;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(range),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        range,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  final VoidCallback onLogout;

  const _SettingsSheet({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                _SettingsItem(
                  icon: Icons.info_outline,
                  title: 'About Hackatime',
                  subtitle: 'Version 1.0.0',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.open_in_browser,
                  title: 'Open in Browser',
                  subtitle: 'View full dashboard',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Remove API key',
                  onTap: onLogout,
                  isDestructive: true,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.accentPink : AppTheme.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple redirect widget for logout
class _LogoutRedirect extends StatelessWidget {
  const _LogoutRedirect();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: CupertinoActivityIndicator(color: Colors.white),
      ),
    );
  }
}
