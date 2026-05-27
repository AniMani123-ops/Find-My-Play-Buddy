import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../data/constants.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, String> profile;
  final VoidCallback onEditProfile;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  // Aggregates player data; handles large volumes efficiently
  Map<String, int> get _sportCounts {
    final counts = <String, int>{};
    for (final p in AppConstants.dummyPlayers) {
      final sport = p['sport'] as String;
      counts[sport] = (counts[sport] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final name = profile['name'] ?? 'You';
    final area = profile['area'] ?? '';
    final sport = profile['sport'] ?? '';
    final skill = profile['skill'] ?? '';
    final availability = profile['availability'] ?? '';
    
    final initials = name.trim().split(' ').length >= 2
        ? '${name.split(' ')[0][0]}${name.split(' ')[1][0]}'.toUpperCase()
        : name.isNotEmpty ? name[0].toUpperCase() : '?';

    final counts = _sportCounts;
    final sports = counts.keys.toList();
    final maxCount = counts.values.fold(0, (a, b) => a > b ? a : b).toDouble();

    // DYNAMIC WIDTH: Provides 55px per sport category to prevent bar crowding
    final double chartWidth = sports.length * 55.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(context, initials, name, area),
            
            // Stats Row
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  _statCell('3', 'Connects sent'),
                  _divider(),
                  _statCell('1', 'Accepted'),
                  _divider(),
                  _statCell('5', 'Games played'),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E5EA)),

            // ── SCROLLABLE CHART SECTION ─────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                    'PLAYERS NEARBY BY SPORT',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Scrollbar and Horizontal Scroll for large dataset entries
                  Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        // Ensures chart is at least screen width, otherwise scales to content
                        width: chartWidth < MediaQuery.of(context).size.width 
                            ? MediaQuery.of(context).size.width - 64 
                            : chartWidth,
                        height: 220,
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxCount + (maxCount * 0.1),
                            barTouchData: _buildTouchData(sports),
                            titlesData: _buildTitlesData(sports),
                            gridData: FlGridData(
                              show: true,
                              // Intelligent intervals to prevent grid line clutter
                              horizontalInterval: (maxCount / 5).clamp(1, double.infinity),
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: const Color(0xFFF0F0F5),
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: _buildBarGroups(sports, counts),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLegend(sports, counts),
                ],
              ),
            ),

            SectionCard(title: 'My sports', child: _chip(sport)),
            SectionCard(title: 'Skill level', child: _chip(skill)),
            SectionCard(title: 'Availability', child: _chip(availability)),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onEditProfile,
                  child: const Text('Edit Profile'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIX: Applied getTooltipColor for fl_chart 0.68.0+ compatibility
  BarTouchData _buildTouchData(List<String> sports) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.9),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            '${sports[groupIndex]}\n',
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: '${rod.toY.toInt()} Players',
                style: const TextStyle(
                  color: Colors.orangeAccent, 
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(List<String> sports) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index < 0 || index >= sports.length) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                sports[index].length > 4 
                    ? '${sports[index].substring(0, 3)}..' 
                    : sports[index],
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            );
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<String> sports, Map<String, int> counts) {
    return List.generate(sports.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: counts[sports[i]]?.toDouble() ?? 0,
            color: AppColors.primary,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 0,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLegend(List<String> sports, Map<String, int> counts) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: sports.map((s) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10, 
            height: 10, 
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$s (${counts[s]})', 
            style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      )).toList(),
    );
  }

  Widget _buildHero(BuildContext context, String initials, String name, String area) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
        ),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withOpacity(0.25),
            child: Text(initials, style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          Text('📍 $area · Bangalore', style: GoogleFonts.outfit(fontSize: 13, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _chip(String label) => Wrap(spacing: 8, children: [SelectableChip(label: label, selected: true, onTap: () {})]);

  Widget _statCell(String num, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(num, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text(label, style: GoogleFonts.outfit(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(width: 0.5, height: 40, color: const Color(0xFFE5E5EA));
}