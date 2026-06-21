import 'package:flutter/material.dart';
import '../main.dart';
import '/app_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isDriverOnline = false;

  bool get isPassenger => AppState.isPassenger;

  // ── Ride options data ──
  static const _rides = [
    {'type': 'Economy',  'price': '\$8.50',  'time': '5 min',  'km': '5.2 km', 'icon': Icons.directions_car},
    {'type': 'Comfort',  'price': '\$12.00', 'time': '7 min',  'km': '5.2 km', 'icon': Icons.airline_seat_recline_extra},
    {'type': 'UberX',    'price': '\$15.50', 'time': '4 min',  'km': '5.2 km', 'icon': Icons.local_taxi},
    {'type': 'Luxury',   'price': '\$28.00', 'time': '10 min', 'km': '5.2 km', 'icon': Icons.star},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(),
            _buildMapTab(),
            _buildChatTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: isPassenger && _selectedIndex == 0
          ? _buildFAB()
          : null,
    );
  }

  // ─────────────────────────────────────────────
  // HOME TAB
  // ─────────────────────────────────────────────

  Widget _buildHomeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildUserTypeToggle(),
        const SizedBox(height: 20),
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${AppState.userName} 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              const Text(
                'Where are you heading?',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Search destination...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary),
            suffixIcon: Icon(Icons.mic_none_rounded, color: AppColors.textSecondary),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // USER TYPE TOGGLE
  // ─────────────────────────────────────────────

  Widget _buildUserTypeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _toggleOption(
              label: 'Passenger',
              icon: Icons.person_outline,
              selected: isPassenger,
              onTap: () => setState(() => AppState.setUserType('Passenger')),
            ),
            _toggleOption(
              label: 'Driver',
              icon: Icons.drive_eta_outlined,
              selected: !isPassenger,
              onTap: () => setState(() => AppState.setUserType('Driver')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleOption({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.background : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.background : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MAIN CONTENT ROUTER
  // ─────────────────────────────────────────────

  Widget _buildMainContent() {
    return isPassenger ? _buildPassengerContent() : _buildDriverContent();
  }

  // ─────────────────────────────────────────────
  // PASSENGER CONTENT
  // ─────────────────────────────────────────────

  Widget _buildPassengerContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        SectionHeader(
          title: 'Available Rides',
          action: 'See all',
          onAction: () {},
        ),
        const SizedBox(height: 14),
        ..._rides.map((ride) => _buildRideCard(ride)),
      ],
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/map',
        arguments: {
          'type':  ride['type'],
          'price': ride['price'],
          'time':  ride['time'],
        },
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentDim,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                ride['icon'] as IconData,
                color: AppColors.accent,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride['type'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ride['km']}  ·  ${ride['time']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ride['price'] as String,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textMuted,
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DRIVER CONTENT
  // ─────────────────────────────────────────────

  Widget _buildDriverContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Status card
        _buildDriverStatusCard(),
        const SizedBox(height: 20),
        // Earnings summary
        _buildEarningsSummary(),
        const SizedBox(height: 20),
        // Empty rides state
        _buildDriverEmptyState(),
      ],
    );
  }

  Widget _buildDriverStatusCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDriverOnline
            ? AppColors.accent.withOpacity(0.12)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDriverOnline ? AppColors.accent : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isDriverOnline
                  ? AppColors.accentDim
                  : AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isDriverOnline
                  ? Icons.wifi_tethering_rounded
                  : Icons.wifi_tethering_off_rounded,
              color: _isDriverOnline
                  ? AppColors.accent
                  : AppColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isDriverOnline ? 'You are Online' : 'You are Offline',
                  style: TextStyle(
                    color: _isDriverOnline
                        ? AppColors.accent
                        : AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _isDriverOnline
                      ? '3 ride requests nearby'
                      : 'Go online to start earning',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isDriverOnline = !_isDriverOnline),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: _isDriverOnline ? AppColors.accent : AppColors.border,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _isDriverOnline
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummary() {
    return Row(
      children: [
        _earningsTile('Today', '\$0.00', Icons.today_outlined),
        const SizedBox(width: 12),
        _earningsTile('This Week', '\$0.00', Icons.date_range_outlined),
        const SizedBox(width: 12),
        _earningsTile('Trips', '0', Icons.route_outlined),
      ],
    );
  }

  Widget _earningsTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.route_outlined,
            size: 52,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 14),
          const Text(
            'No rides yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Go online to receive ride requests',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // OTHER TABS
  // ─────────────────────────────────────────────

  Widget _buildMapTab() => const Center(
    child: Text('Map Screen',
        style: TextStyle(color: AppColors.textSecondary)),
  );

  Widget _buildChatTab() => const Center(
    child: Text('Chat Screen',
        style: TextStyle(color: AppColors.textSecondary)),
  );

  Widget _buildProfileTab() => const Center(
    child: Text('Profile Screen',
        style: TextStyle(color: AppColors.textSecondary)),
  );

  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FAB
  // ─────────────────────────────────────────────

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/booking'),
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.background,
      elevation: 0,
      icon: const Icon(Icons.bolt_rounded),
      label: const Text(
        'Book Now',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
