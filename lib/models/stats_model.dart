class HackatimeStats {
  final String totalTime;
  final int totalSeconds;
  final String dailyAverage;
  final List<LanguageStat> languages;
  final List<ProjectStat> projects;
  final List<EditorStat> editors;
  final List<DailyStat> dailyStats;
  final DateTime startDate;
  final DateTime endDate;

  HackatimeStats({
    required this.totalTime,
    required this.totalSeconds,
    required this.dailyAverage,
    required this.languages,
    required this.projects,
    required this.editors,
    required this.dailyStats,
    required this.startDate,
    required this.endDate,
  });

  factory HackatimeStats.fromJson(Map<String, dynamic> json, {DateTime? start, DateTime? end}) {
    final data = json['data'] ?? json;
    
    // Parse languages
    final languagesRaw = data['languages'] as List? ?? [];
    final languages = languagesRaw.map((l) => LanguageStat.fromJson(l)).toList();
    
    // Parse projects
    final projectsRaw = data['projects'] as List? ?? [];
    final projects = projectsRaw.map((p) => ProjectStat.fromJson(p)).toList();
    
    // Parse editors
    final editorsRaw = data['editors'] as List? ?? [];
    final editors = editorsRaw.map((e) => EditorStat.fromJson(e)).toList();

    // Calculate total time
    int totalSecs = 0;
    if (data['grand_total'] != null) {
      totalSecs = (data['grand_total']['total_seconds'] ?? 0).toInt();
    } else if (data['total_seconds'] != null) {
      totalSecs = data['total_seconds'].toInt();
    }

    return HackatimeStats(
      totalTime: _formatDuration(totalSecs),
      totalSeconds: totalSecs,
      dailyAverage: data['human_readable_daily_average'] ?? _formatDuration(totalSecs ~/ 7),
      languages: languages,
      projects: projects,
      editors: editors,
      dailyStats: [],
      startDate: start ?? DateTime.now().subtract(const Duration(days: 7)),
      endDate: end ?? DateTime.now(),
    );
  }

  factory HackatimeStats.fromSummaries(List<dynamic> summaries) {
    int totalSecs = 0;
    Map<String, int> langMap = {};
    Map<String, int> projMap = {};
    Map<String, int> editorMap = {};
    List<DailyStat> daily = [];

    for (var day in summaries) {
      final grandTotal = day['grand_total'];
      final daySecs = (grandTotal?['total_seconds'] ?? 0).toInt();
      totalSecs = (totalSecs + daySecs).toInt();

      // Parse date
      final dateStr = day['range']?['date'] ?? '';
      DateTime? date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {}

      if (date != null) {
        daily.add(DailyStat(date: date, seconds: daySecs));
      }

      // Aggregate languages
      for (var lang in (day['languages'] ?? [])) {
        final name = lang['name'] ?? 'Other';
        final secs = (lang['total_seconds'] ?? 0).toInt();
        langMap[name] = ((langMap[name] ?? 0) + secs).toInt();
      }

      // Aggregate projects
      for (var proj in (day['projects'] ?? [])) {
        final name = proj['name'] ?? 'Unknown';
        final secs = (proj['total_seconds'] ?? 0).toInt();
        projMap[name] = ((projMap[name] ?? 0) + secs).toInt();
      }

      // Aggregate editors
      for (var editor in (day['editors'] ?? [])) {
        final name = editor['name'] ?? 'Unknown';
        final secs = (editor['total_seconds'] ?? 0).toInt();
        editorMap[name] = ((editorMap[name] ?? 0) + secs).toInt();
      }
    }

    // Convert maps to sorted lists
    final languages = langMap.entries
        .map((e) => LanguageStat(
              name: e.key,
              totalSeconds: e.value,
              percent: totalSecs > 0 ? (e.value / totalSecs * 100) : 0,
            ))
        .toList()
      ..sort((a, b) => b.totalSeconds.compareTo(a.totalSeconds));

    final projects = projMap.entries
        .map((e) => ProjectStat(
              name: e.key,
              totalSeconds: e.value,
              percent: totalSecs > 0 ? (e.value / totalSecs * 100) : 0,
            ))
        .toList()
      ..sort((a, b) => b.totalSeconds.compareTo(a.totalSeconds));

    final editors = editorMap.entries
        .map((e) => EditorStat(
              name: e.key,
              totalSeconds: e.value,
              percent: totalSecs > 0 ? (e.value / totalSecs * 100) : 0,
            ))
        .toList()
      ..sort((a, b) => b.totalSeconds.compareTo(a.totalSeconds));

    daily.sort((a, b) => a.date.compareTo(b.date));

    return HackatimeStats(
      totalTime: _formatDuration(totalSecs),
      totalSeconds: totalSecs,
      dailyAverage: _formatDuration(daily.isNotEmpty ? totalSecs ~/ daily.length : 0),
      languages: languages,
      projects: projects,
      editors: editors,
      dailyStats: daily,
      startDate: daily.isNotEmpty ? daily.first.date : DateTime.now().subtract(const Duration(days: 7)),
      endDate: daily.isNotEmpty ? daily.last.date : DateTime.now(),
    );
  }

  static String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class LanguageStat {
  final String name;
  final int totalSeconds;
  final double percent;

  LanguageStat({
    required this.name,
    required this.totalSeconds,
    required this.percent,
  });

  factory LanguageStat.fromJson(Map<String, dynamic> json) {
    return LanguageStat(
      name: json['name'] ?? 'Unknown',
      totalSeconds: (json['total_seconds'] ?? 0).toInt(),
      percent: (json['percent'] ?? 0).toDouble(),
    );
  }

  String get formattedTime {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class ProjectStat {
  final String name;
  final int totalSeconds;
  final double percent;

  ProjectStat({
    required this.name,
    required this.totalSeconds,
    required this.percent,
  });

  factory ProjectStat.fromJson(Map<String, dynamic> json) {
    return ProjectStat(
      name: json['name'] ?? 'Unknown',
      totalSeconds: (json['total_seconds'] ?? 0).toInt(),
      percent: (json['percent'] ?? 0).toDouble(),
    );
  }

  String get formattedTime {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class EditorStat {
  final String name;
  final int totalSeconds;
  final double percent;

  EditorStat({
    required this.name,
    required this.totalSeconds,
    required this.percent,
  });

  factory EditorStat.fromJson(Map<String, dynamic> json) {
    return EditorStat(
      name: json['name'] ?? 'Unknown',
      totalSeconds: (json['total_seconds'] ?? 0).toInt(),
      percent: (json['percent'] ?? 0).toDouble(),
    );
  }

  String get formattedTime {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class DailyStat {
  final DateTime date;
  final int seconds;

  DailyStat({
    required this.date,
    required this.seconds,
  });

  String get formattedTime {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
