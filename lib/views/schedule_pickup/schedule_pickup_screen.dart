import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../controller/pickup_controller.dart';
import '../../model/pickup_model.dart';

class SchedulePickupScreen extends StatefulWidget {
  const SchedulePickupScreen({super.key});

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PickupController>(context, listen: false).startTracking();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    // Stop tracking when the user leaves this screen
    Future.microtask(() {
      if (mounted) {
        Provider.of<PickupController>(context, listen: false).stopTracking();
      }
    });
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickupController>(
      builder: (context, controller, child) {
        final pickup = controller.activePickup;

        if (pickup == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tracking')),
            body: const Center(child: Text('No active pickup to track')),
          );
        }

        final collector = pickup.collector;
        final hasCollector = collector != null;

        // Animate camera to show both markers if both exist
        if (_mapController != null && collector?.latitude != null && pickup.latitude != null) {
          final bounds = LatLngBounds(
            southwest: LatLng(
              pickup.latitude! < collector!.latitude! ? pickup.latitude! : collector.latitude!,
              pickup.longitude! < collector.longitude! ? pickup.longitude! : collector.longitude!,
            ),
            northeast: LatLng(
              pickup.latitude! > collector.latitude! ? pickup.latitude! : collector.latitude!,
              pickup.longitude! > collector.longitude! ? pickup.longitude! : collector.longitude!,
            ),
          );
          _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Google Map
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pickup.latitude ?? 33.6844, pickup.longitude ?? 73.0479),
                    zoom: 14.0,
                  ),
                  markers: {
                    if (pickup.latitude != null && pickup.longitude != null)
                      Marker(
                        markerId: const MarkerId('pickup'),
                        position: LatLng(pickup.latitude!, pickup.longitude!),
                        infoWindow: const InfoWindow(title: 'Pickup Location'),
                      ),
                    if (collector?.latitude != null && collector?.longitude != null)
                      Marker(
                        markerId: const MarkerId('collector'),
                        position: LatLng(collector!.latitude!, collector!.longitude!),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                        infoWindow: const InfoWindow(title: 'Collector Location'),
                      ),
                  },
                  polylines: {
                    if (collector?.latitude != null && pickup.latitude != null)
                      Polyline(
                        polylineId: const PolylineId('route'),
                        color: AppColors.primary,
                        width: 5,
                        points: [
                          LatLng(collector!.latitude!, collector!.longitude!),
                          LatLng(pickup.latitude!, pickup.longitude!),
                        ],
                        patterns: [PatternItem.dash(10), PatternItem.gap(5)],
                      ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
              
              // Back Button and Time Label
              Positioned(
                top: 60,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    if (pickup.eta != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.blue, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.minTime(pickup.eta!['minutes'].toString()),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom Content
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          hasCollector 
                            ? AppLocalizations.of(context)!.collectorEnRoute
                            : AppLocalizations.of(context)!.waitingCollector,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasCollector
                            ? AppLocalizations.of(context)!.wasteCollectedShortly
                            : 'We are assigning a collector to your request.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (pickup.eta != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStat(pickup.eta!['minutes'].toString(), AppLocalizations.of(context)!.minutes),
                              _buildStat(pickup.eta!['distanceKm']?.toString() ?? '2.4', AppLocalizations.of(context)!.kmAway),
                              _buildStat('3/5', AppLocalizations.of(context)!.stops),
                            ],
                          ),
                        if (hasCollector) ...[
                          const SizedBox(height: 24),
                          // Collector Card
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    collector.name.isNotEmpty ? collector.name.substring(0, 1) : 'C',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      collector.name.isNotEmpty ? collector.name : 'Unknown Collector',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.orange, size: 16),
                                        Text(' ${collector.rating} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const Text('• ', style: TextStyle(color: AppColors.textSecondary)),
                                        Text(AppLocalizations.of(context)!.pickupsCount('12'), style: const TextStyle(color: AppColors.textSecondary)),
                                      ],
                                    ),
                                    Text(collector.vehiclePlate, style: const TextStyle(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone_outlined, color: Colors.white),
                            label: Text(AppLocalizations.of(context)!.callCollector, style: const TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.statusUpdates,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        _buildStatusTimeline(context, pickup, hasCollector),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, PickupModel pickup, bool hasCollector) {
    return Column(
      children: [
        if (pickup.status == PickupStatus.COLLECTOR_ASSIGNED || pickup.status == PickupStatus.EN_ROUTE)
          _buildTimelineItem(
            title: AppLocalizations.of(context)!.enRouteLocation,
            subtitle: AppLocalizations.of(context)!.minutesAway,
            isActive: true,
            isLast: false,
          ),
        _buildTimelineItem(
          title: AppLocalizations.of(context)!.pickupStarted,
          subtitle: AppLocalizations.of(context)!.collectionInitiated,
          isActive: pickup.status != PickupStatus.PENDING,
          isLast: false,
        ),
        _buildTimelineItem(
          title: AppLocalizations.of(context)!.pickupScheduled,
          subtitle: hasCollector ? 'Collector Assigned' : AppLocalizations.of(context)!.waitingCollector,
          isActive: true,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({required String title, required String subtitle, required bool isActive, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? AppColors.primary : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.textPrimary : Colors.grey,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
