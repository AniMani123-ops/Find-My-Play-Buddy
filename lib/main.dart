import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'screens/setup_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/venues_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const FindMyPlayBuddyApp());
}

class FindMyPlayBuddyApp extends StatelessWidget {
  const FindMyPlayBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find My Play Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  // null = show setup/onboarding screen
  Map<String, String>? _profile;
  int _selectedTab = 0;

  void _onProfileComplete(Map<String, String> profile) {
    setState(() {
      _profile = profile;
      _selectedTab = 0; // go to Discover after setup
    });
  }

  void _editProfile() {
    setState(() => _profile = null);
  }

  @override
  Widget build(BuildContext context) {
    // Show onboarding until profile is saved
    if (_profile == null) {
      return SetupScreen(onComplete: _onProfileComplete);
    }

    // Use UniqueKey so DiscoverScreen rebuilds fresh when profile changes
    final tabs = [
      DiscoverScreen(key: ValueKey(_profile.hashCode), userProfile: _profile!),
      const VenuesScreen(),
      ProfileScreen(profile: _profile!, onEditProfile: _editProfile),
    ];

    return Scaffold(
      body: tabs[_selectedTab],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E5EA), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (i) {
            if (i == 3) {
              // Home — go back to setup screen
              setState(() => _profile = null);
            } else {
              setState(() => _selectedTab = i);
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: GoogleFonts.outfit(
              fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.outfit(
              fontSize: 10, fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place_rounded),
              label: 'Venues',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
          ],
        ),
      ),
    );
  }
}