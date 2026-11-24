import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../models/stats_model.dart';
import 'glass_card.dart';

class TotalTimeCard extends StatelessWidget {
  final String totalTime;
  final String dailyAverage;
  final int totalSeconds;

  const TotalTimeCard({
    super.key,
    required this.totalTime,
    required this.dailyAverage,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return GradientGlassCard(
      padding: const EdgeInsets.all(18), // Reduced from 24 for SE
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Reduced from 10 for SE
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: 20, // Reduced from 24 for SE
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Total Coding Time',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Reduced from 20 for SE
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                totalTime,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 36, // Optimized for SE
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              );
            },
          ),
          const SizedBox(height: 6), // Reduced from 8 for SE
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: AppTheme.accentGreen,
                size: 16, // Reduced from 18 for SE
              ),
              const SizedBox(width: 6),
              Text(
                '$dailyAverage daily average',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LanguageBreakdownCard extends StatelessWidget {
  final List<LanguageStat> languages;

  const LanguageBreakdownCard({
    super.key,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    final displayLanguages = languages.take(6).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Languages',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${languages.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.accentBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...displayLanguages.asMap().entries.map((entry) {
            final index = entry.key;
            final lang = entry.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(20 * (1 - value), 0),
                    child: _LanguageBar(language: lang),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _LanguageBar extends StatelessWidget {
  final LanguageStat language;

  const _LanguageBar({required this.language});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getLanguageColor(language.name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    language.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Text(
                language.formattedTime,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: language.percent / 100),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ActivityChartCard extends StatelessWidget {
  final List<DailyStat> dailyStats;

  const ActivityChartCard({
    super.key,
    required this.dailyStats,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyStats.isEmpty) {
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'No activity data',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    final maxSeconds = dailyStats.map((e) => e.seconds).reduce((a, b) => a > b ? a : b);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16), // Optimized for SE
          SizedBox(
            height: 140, // Optimized for SE
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxSeconds.toDouble() * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppTheme.cardColor,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final stat = dailyStats[group.x.toInt()];
                      return BarTooltipItem(
                        stat.formattedTime,
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= dailyStats.length) return const SizedBox();
                        final date = dailyStats[value.toInt()].date;
                        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[date.weekday - 1],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: dailyStats.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stat = entry.value;
                  final isToday = index == dailyStats.length - 1;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: stat.seconds.toDouble(),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isToday
                              ? [AppTheme.accentBlue, AppTheme.accentCyan]
                              : [
                                  AppTheme.accentPurple.withOpacity(0.6),
                                  AppTheme.accentPurple,
                                ],
                        ),
                        width: 24,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectsCard extends StatelessWidget {
  final List<ProjectStat> projects;

  const ProjectsCard({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    final displayProjects = projects.take(5).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projects',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Icon(
                Icons.folder_outlined,
                color: AppTheme.textSecondary,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (displayProjects.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No projects yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            ...displayProjects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (index * 80)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: _ProjectItem(
                      project: project,
                      rank: index + 1,
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  final ProjectStat project;
  final int rank;

  const _ProjectItem({
    required this.project,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentPurple,
      AppTheme.accentPink,
      AppTheme.accentOrange,
      AppTheme.accentGreen,
    ];
    final color = colors[(rank - 1) % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${project.percent.toStringAsFixed(1)}% of total',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            project.formattedTime,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class EditorsCard extends StatelessWidget {
  final List<EditorStat> editors;

  const EditorsCard({
    super.key,
    required this.editors,
  });

  @override
  Widget build(BuildContext context) {
    if (editors.isEmpty) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Editors',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Icon(
                Icons.code,
                color: AppTheme.textSecondary,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: editors.take(4).map((editor) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.accentBlue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getEditorIcon(editor.name),
                      color: AppTheme.accentBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      editor.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      editor.formattedTime,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentCyan,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getEditorIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('vscode') || lower.contains('visual studio code')) {
      return Icons.code;
    } else if (lower.contains('vim') || lower.contains('neovim')) {
      return Icons.terminal;
    } else if (lower.contains('intellij') || lower.contains('jetbrains')) {
      return Icons.developer_mode;
    } else if (lower.contains('xcode')) {
      return Icons.apple;
    }
    return Icons.edit;
  }
}
