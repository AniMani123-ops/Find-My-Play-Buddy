import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/constants.dart';
import '../widgets/common_widgets.dart';

class SetupScreen extends StatefulWidget {
  final Function(Map<String, String>) onComplete;

  const SetupScreen({super.key, required this.onComplete});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _nameCtrl = TextEditingController(text: 'Mani');
  String _area = 'Koramangala';
  String _sport = 'Badminton';
  String _skill = 'Intermediate';
  String _availability = 'Weekends';

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    widget.onComplete({
      'name': _nameCtrl.text.trim(),
      'area': _area,
      'sport': _sport,
      'skill': _skill,
      'availability': _availability,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Hero header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42), Color(0xFFFFA552)],
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              left: 28,
              right: 28,
              bottom: 32,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🏸', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  'Find Your\nPlay Buddy',
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with players in your area',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _formCard(
                    label: 'Your name',
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        hintText: 'Enter your name',
                      ),
                      style: GoogleFonts.outfit(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _formCard(
                    label: 'Your area in Bangalore',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.areas
                          .map((a) => SelectableChip(
                                label: a,
                                selected: _area == a,
                                onTap: () => setState(() => _area = a),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _formCard(
                    label: 'I want to play',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.sports
                          .map((s) => SelectableChip(
                                label: '${s['emoji']} ${s['label']}',
                                selected: _sport == s['label'],
                                onTap: () =>
                                    setState(() => _sport = s['label']!),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _formCard(
                    label: 'My skill level',
                    child: Wrap(
                      spacing: 8,
                      children: AppConstants.skillLevels
                          .map((s) => SelectableChip(
                                label: s,
                                selected: _skill == s,
                                onTap: () => setState(() => _skill = s),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _formCard(
                    label: 'Available on',
                    child: Wrap(
                      spacing: 8,
                      children: AppConstants.availabilities
                          .map((a) => SelectableChip(
                                label: a,
                                selected: _availability == a,
                                onTap: () =>
                                    setState(() => _availability = a),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Find Players →'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formCard({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
