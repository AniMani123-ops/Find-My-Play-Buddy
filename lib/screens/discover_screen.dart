import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/player.dart';
import '../data/constants.dart';
import '../widgets/common_widgets.dart';

class DiscoverScreen extends StatefulWidget {
  final Map<String, String> userProfile;

  const DiscoverScreen({super.key, required this.userProfile});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late String _activeSport;
  late String _activeArea;
  late String _activeTime;
  final Set<String> _sentRequests = {};

  @override
  void initState() {
    super.initState();
    _activeSport = widget.userProfile['sport'] ?? 'All';
    _activeArea  = widget.userProfile['area']  ?? 'All';
    final avail  = widget.userProfile['availability'] ?? 'All';
    _activeTime  = avail == 'Both' ? 'All' : avail;
  }

  List<Player> get _allPlayers => AppConstants.dummyPlayers
      .map((m) => Player(
            id: m['id'],
            name: m['name'],
            area: m['area'],
            sport: m['sport'],
            skill: m['skill'],
            availability: m['availability'],
            distanceKm: m['distanceKm'],
          ))
      .toList();

  List<Player> get _filtered => _allPlayers.where((p) {
        final areaOk  = _activeArea  == 'All' || p.area == _activeArea;
        final sportOk = _activeSport == 'All' || p.sport == _activeSport;
        final timeOk  = _activeTime  == 'All' ||
            p.availability == _activeTime ||
            p.availability == 'Both';
        return areaOk && sportOk && timeOk;
      }).toList();

  void _openConnectSheet(Player player) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ConnectSheet(
        player: player,
        onSend: (msg) {
          setState(() => _sentRequests.add(player.id));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Request sent to ${player.name.split(' ')[0]}!'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Players'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_activeArea == 'All' ? 'All areas' : _activeArea} · ${_activeSport == 'All' ? 'All sports' : _activeSport}',
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Area filter row ──────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
                  child: Text('Area', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: Row(
                    children: [
                      _filterChip('All', _activeArea == 'All',
                          () => setState(() => _activeArea = 'All')),
                      const SizedBox(width: 8),
                      ...AppConstants.areas.map((a) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _filterChip(a, _activeArea == a,
                                () => setState(() => _activeArea = a)),
                          )),
                    ],
                  ),
                ),
                // ── Sport filter row ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 0, 4),
                  child: Text('Sport', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: Row(
                    children: [
                      _filterChip('All', _activeSport == 'All',
                          () => setState(() => _activeSport = 'All')),
                      const SizedBox(width: 8),
                      ...AppConstants.sports.map((s) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _filterChip(
                              '${s['emoji']} ${s['label']}',
                              _activeSport == s['label'],
                              () => setState(() => _activeSport = s['label']!),
                            ),
                          )),
                    ],
                  ),
                ),
                // ── Time filter row ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 0, 4),
                  child: Text('Availability', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      _filterChip('All', _activeTime == 'All',
                          () => setState(() => _activeTime = 'All')),
                      const SizedBox(width: 8),
                      ...AppConstants.availabilities.map((a) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _filterChip(a, _activeTime == a,
                                () => setState(() => _activeTime = a)),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F5)),

          // ── Results count ────────────────────────────────────────
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${players.length} player${players.length == 1 ? '' : 's'} found',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // ── Players list ─────────────────────────────────────────
          Expanded(
            child: players.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'No players found\nTry different filters',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(fontSize: 16, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: players.length,
                    itemBuilder: (_, i) => _PlayerCard(
                      player: players[i],
                      requestSent: _sentRequests.contains(players[i].id),
                      onConnect: () => _openConnectSheet(players[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFF0F0F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

// ── Player card ──────────────────────────────────────────────────────────
class _PlayerCard extends StatelessWidget {
  final Player player;
  final bool requestSent;
  final VoidCallback onConnect;

  const _PlayerCard({required this.player, required this.requestSent, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Row(
        children: [
          PlayerAvatar(initials: player.initials),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name,
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  '📍 ${player.area}${player.distanceKm != null ? ' · ${player.distanceKm} km' : ''}',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: [
                    SportTag(label: player.sport),
                    SportTag(label: player.skill, bg: AppColors.tagBlue, fg: AppColors.tagBlueTxt),
                    SportTag(label: player.availability, bg: AppColors.tagGreen, fg: AppColors.tagGreenTxt),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: requestSent ? null : onConnect,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: requestSent ? AppColors.tagGreen : AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                requestSent ? 'Sent ✓' : 'Connect',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: requestSent ? AppColors.tagGreenTxt : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Connect bottom sheet ─────────────────────────────────────────────────
class _ConnectSheet extends StatelessWidget {
  final Player player;
  final Function(String) onSend;

  const _ConnectSheet({required this.player, required this.onSend});

  static const _messages = [
    '👋 Hey! Want to play this weekend?',
    '🏸 Looking for a partner — interested?',
    '📍 Let\'s meet at Play Arena, Koramangala?',
    '🕐 I\'m free Saturday morning. Shall we play?',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: const Color(0xFFE5E5EA), borderRadius: BorderRadius.circular(2)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Connect with ${player.name.split(' ')[0]}',
              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Send a quick intro message',
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 16),
          ..._messages.map((msg) => GestureDetector(
                onTap: () => onSend(msg),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                  child: Text(msg, style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textPrimary)),
                ),
              )),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Color(0xFFE5E5EA)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Cancel', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}