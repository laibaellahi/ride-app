import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../main.dart';
import '../app_widget.dart';

class MapScreen extends StatefulWidget {
  final String rideType;
  final String price;
  final String duration;

  const MapScreen({
    super.key,
    this.rideType = 'Economy',
    this.price    = '\$8.50',
    this.duration = '5 min',
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapCompleter = Completer();
  GoogleMapController? _mapController;

  static const _pickup  = LatLng(12.9716, 77.5946);
  static const _dropoff = LatLng(12.9800, 77.6100);

  static const _initialCamera = CameraPosition(
    target: LatLng(12.9758, 77.6023),
    zoom: 13.5,
  );

  Set<Marker> _markers  = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setupRoute();
  }

  void _setupRoute() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickup,
          infoWindow: const InfoWindow(title: 'Pickup'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId('dropoff'),
          position: _dropoff,
          infoWindow: const InfoWindow(title: 'Dropoff'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
        ),
      };
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: const [_pickup, _dropoff],
          color: AppColors.accent,
          width: 5,
          patterns: [],
        ),
      };
    });
  }

  void _fitRoute() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: const LatLng(12.9716, 77.5946),
          northeast: const LatLng(12.9800, 77.6100),
        ),
        80,
      ),
    );
  }

  void _onConfirm() {
    _fitRoute();
    Navigator.pushNamed(
      context,
      '/booking',
      arguments: {
        'type':    widget.rideType,
        'price':   widget.price,
        'time':    widget.duration,
        'pickup':  'Satellite Town',
        'dropoff': 'Superior University Sargodha',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map ──
          GoogleMap(
            initialCameraPosition: _initialCamera,
            onMapCreated: (c) {
              _mapCompleter.complete(c);
              _mapController = c;
            },
            markers:           _markers,
            polylines:         _polylines,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Top bar ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Ride info chip
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_taxi_rounded,
                            color: AppColors.accent, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${widget.rideType} Ride',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        StatusBadge(
                            label: widget.price,
                            color: AppColors.accent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom panel ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                    top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Route summary
                  _buildRouteRow(),
                  const SizedBox(height: 20),
                  // Trip info row
                  Row(
                    children: [
                      _infoChip(Icons.access_time_rounded,
                          widget.duration),
                      const SizedBox(width: 10),
                      _infoChip(Icons.route_rounded, '5.2 km'),
                      const SizedBox(width: 10),
                      _infoChip(Icons.people_outline_rounded, '1-4'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Confirm button
                  AccentButton(
                    label: 'Confirm ${widget.rideType}',
                    icon: Icons.bolt_rounded,
                    onPressed: _onConfirm,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteRow() {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 30,
              color: AppColors.border,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Satellite Town,Sargodha',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              const SizedBox(height: 18),
              Text(
                ' Superior University, Sargodha',
                style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}