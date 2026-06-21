import 'dart:async';
import 'package:flutter/material.dart';

import '../main.dart';
import '../app_widget.dart';

enum BookingStatus { searching, driverFound, arriving, completed }

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  Timer? _simulationTimer;
  Timer? _etaTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  double _progress = 0.0;
  BookingStatus _status = BookingStatus.searching;

  int _etaSeconds = 270;
  bool _argsParsed = false;

  // Ride data
  String _rideType = 'Economy';
  String _price = '\$8.50';
  String _pickup = 'Current Location';
  String _dropoff = 'Destination';

  // Driver info
  final _driverName = 'John Driver';
  final _driverRating = 4.8;
  final _carModel = 'Toyota Camry';
  final _carPlate = 'KA 05 AB 1234';
  final _driverTrips = 1284;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(
      begin: 0.93,
      end: 1.07,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _startSimulation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argsParsed) return;

    _argsParsed = true;

    final route = ModalRoute.of(context);

    if (route == null) return;

    final arguments = route.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      setState(() {
        _rideType = arguments['type'] ?? _rideType;
        _price = arguments['price'] ?? _price;
        _pickup = arguments['pickup'] ?? _pickup;
        _dropoff = arguments['dropoff'] ?? _dropoff;
      });
    }
  }

  void _startSimulation() {
    _simulationTimer =
        Timer.periodic(const Duration(milliseconds: 700), (_) {
          if (!mounted) return;

          setState(() {
            if (_progress < 0.45) {
              _progress += 0.04;
              _status = BookingStatus.searching;
            } else if (_progress < 1.0) {
              _progress += 0.035;

              if (_status == BookingStatus.searching) {
                _status = BookingStatus.driverFound;
                _startEtaCountdown();
              }
            } else {
              _progress = 1.0;
              _status = BookingStatus.arriving;
              _simulationTimer?.cancel();
            }
          });
        });
  }

  void _startEtaCountdown() {
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        if (_etaSeconds > 0) {
          _etaSeconds--;
        }
      });
    });
  }

  String get _etaLabel {
    if (_etaSeconds <= 0) {
      return 'Arriving now';
    }

    final m = _etaSeconds ~/ 60;
    final s = _etaSeconds % 60;

    if (m > 0) {
      return '$m min ${s.toString().padLeft(2, '0')} sec';
    }

    return '$s sec away';
  }

  String get _statusTitle {
    switch (_status) {
      case BookingStatus.searching:
        return 'Finding Your Driver';
      case BookingStatus.driverFound:
        return 'Driver Matched!';
      case BookingStatus.arriving:
        return 'Driver On the Way';
      case BookingStatus.completed:
        return 'Ride Completed';
    }
  }

  String get _statusSubtitle {
    switch (_status) {
      case BookingStatus.searching:
        return 'Looking for drivers nearby...';
      case BookingStatus.driverFound:
        return '$_driverName accepted · $_etaLabel';
      case BookingStatus.arriving:
        return 'Almost there · $_etaLabel';
      case BookingStatus.completed:
        return 'Thank you for riding with RideX';
    }
  }

  Color get _statusColor {
    switch (_status) {
      case BookingStatus.searching:
        return AppColors.warning;
      case BookingStatus.driverFound:
        return AppColors.info;
      case BookingStatus.arriving:
        return AppColors.accent;
      case BookingStatus.completed:
        return AppColors.accent;
    }
  }

  IconData get _statusIcon {
    switch (_status) {
      case BookingStatus.searching:
        return Icons.search_rounded;
      case BookingStatus.driverFound:
        return Icons.person_pin_circle_rounded;
      case BookingStatus.arriving:
        return Icons.local_taxi_rounded;
      case BookingStatus.completed:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _confirmCancel();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('$_rideType Booking'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: _confirmCancel,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusCard(),
              const SizedBox(height: 16),
              if (_status != BookingStatus.searching) ...[
                _buildDriverCard(),
                const SizedBox(height: 16),
              ],
              _buildRideSummaryCard(),
              const SizedBox(height: 16),
              _buildLocationsCard(),
              const SizedBox(height: 24),
              _buildActionButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return AppCard(
      borderColor: _statusColor.withOpacity(0.3),
      child: Column(
        children: [
          ScaleTransition(
            scale: _status == BookingStatus.searching
                ? _pulseAnim
                : const AlwaysStoppedAnimation(1.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 6,
                    backgroundColor: AppColors.border,
                    valueColor:
                    AlwaysStoppedAnimation(_statusColor),
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _statusIcon,
                    color: _statusColor,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _statusTitle,
            style: TextStyle(
              color: _statusColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _statusSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _driverName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warning,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_driverRating  ·  $_driverTrips trips',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '$_carModel  ·  $_carPlate',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              CircleIconButton(
                icon: Icons.phone_rounded,
                color: AppColors.accent,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              CircleIconButton(
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.info,
                onTap: () =>
                    Navigator.pushNamed(context, '/chat'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRideSummaryCard() {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.accentDim,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_taxi_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _rideType,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
          ),
          StatusBadge(
            label: _price,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationsCard() {
    return AppCard(
      child: Column(
        children: [
          _locationRow(
            icon: Icons.my_location_rounded,
            label: 'Pickup',
            location: _pickup,
            color: AppColors.accent,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Container(
              height: 22,
              width: 1.5,
              color: AppColors.border,
            ),
          ),
          _locationRow(
            icon: Icons.location_on_rounded,
            label: 'Dropoff',
            location: _dropoff,
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _locationRow({
    required IconData icon,
    required String label,
    required String location,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              location,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Cancel Ride?'),
        content: const Text('Are you sure you want to cancel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Ride'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildActionButton() {
    if (_status == BookingStatus.completed) {
      return AccentButton(
        label: 'Done',
        icon: Icons.check_circle_outline_rounded,
        onPressed: () => Navigator.pop(context),
      );
    }

    return AccentButton(
      label: 'Cancel Ride',
      icon: Icons.cancel_outlined,
      isDestructive: true,
      onPressed: _confirmCancel,
    );
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _etaTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
}
