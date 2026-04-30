import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../controller/auth_controller.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';
import 'package:provider/provider.dart';
import '../../core/utils/navigation_utils.dart';
import 'location_selection_screen.dart';

class CollectorDetailsScreen extends StatefulWidget {
  const CollectorDetailsScreen({super.key});

  @override
  State<CollectorDetailsScreen> createState() => _CollectorDetailsScreenState();
}

class _CollectorDetailsScreenState extends State<CollectorDetailsScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _zoneController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  
  bool _isLoading = false;
  bool _isGettingLocation = false;
  Position? _currentPosition;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _prefillFromProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _vehiclePlateController.dispose();
    _zoneController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _prefillFromProfile() {
    final auth = Provider.of<AuthController>(context, listen: false);
    final user = auth.user;
    if (user == null) return;
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';
  }

  Future<void> _fetchLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      final position = await LocationService().getCurrentLocation();
      if (position != null) {
        setState(() => _currentPosition = position);
        _latitudeController.text = position.latitude.toStringAsFixed(6);
        _longitudeController.text = position.longitude.toStringAsFixed(6);
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            setState(() {
              _currentAddress = "${place.street ?? ''} ${place.locality ?? ''}, ${place.country ?? ''}".trim();
              if (_currentAddress!.startsWith(',')) _currentAddress = _currentAddress!.substring(1).trim();
            });
          }
        } catch (e) {
          debugPrint('Reverse geocoding error: $e');
        }
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _openMap() async {
    final initial = _currentPosition != null 
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : const LatLng(-1.9441, 30.0619); // Default to Kigali

    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationSelectionScreen(initialLocation: initial),
      ),
    );

    if (result != null) {
      setState(() {
        _currentPosition = Position(
          latitude: result.latitude,
          longitude: result.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });
      _latitudeController.text = result.latitude.toStringAsFixed(6);
      _longitudeController.text = result.longitude.toStringAsFixed(6);
      
      // Update address
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _currentAddress = "${place.street ?? ''} ${place.locality ?? ''}, ${place.country ?? ''}".trim();
            if (_currentAddress!.startsWith(',')) _currentAddress = _currentAddress!.substring(1).trim();
          });
        }
      } catch (e) {
        debugPrint('Reverse geocoding error: $e');
      }
    }
  }

  double? _tryParseCoord(String raw) {
    final v = double.tryParse(raw.trim());
    if (v == null) return null;
    if (v.isNaN || v.isInfinite) return null;
    return v;
  }

  void _applyManualCoordinates() {
    final lat = _tryParseCoord(_latitudeController.text);
    final lng = _tryParseCoord(_longitudeController.text);

    if (lat == null || lng == null || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid latitude (-90..90) and longitude (-180..180)')),
      );
      return;
    }

    setState(() {
      _currentPosition = Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
      _currentAddress = null; // unknown when manually typed
    });
  }

  Future<void> _submit() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final vehiclePlate = _vehiclePlateController.text.trim();
    final zone = _zoneController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first name, last name, and email')),
      );
      return;
    }

    if (name.isEmpty || vehiclePlate.isEmpty || zone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // If manual coordinates were provided, apply them before submit
    if (_latitudeController.text.trim().isNotEmpty || _longitudeController.text.trim().isNotEmpty) {
      final lat = _tryParseCoord(_latitudeController.text);
      final lng = _tryParseCoord(_longitudeController.text);
      if (lat == null || lng == null || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid latitude (-90..90) and longitude (-180..180)')),
        );
        return;
      }
      _applyManualCoordinates();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();

      // Save collector personal info into User table
      final authController = Provider.of<AuthController>(context, listen: false);
      final profileUpdated = await authController.completeProfileV2(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      if (!profileUpdated) {
        throw Exception(authController.error ?? 'Failed to save profile');
      }

      final response = await apiService.post('/collectors/register-me', {
        'collectorName': name,
        'vehiclePlate': vehiclePlate,
        'zone': zone,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
      });

      if (response['success'] == true) {
        await authController.refreshProfile(); // refresh profile to get collectorProfile info

        if (mounted) {
          // getLayoutForUser will now return CollectorPendingScreen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => getLayoutForUser(authController.user)),
            (route) => false,
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to register as collector');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collector Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join as Collector',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Enter your details to start collecting waste.'),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                hintText: 'e.g. Jean',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                hintText: 'e.g. Baptiste',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'example@mail.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                labelText: 'Collector/Business Name',
                hintText: 'e.g. Kigali Waste Services',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _vehiclePlateController,
                labelText: 'Vehicle Plate',
                hintText: 'e.g. RAD 123A',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zoneController,
                labelText: 'Operating Zone',
                hintText: 'e.g. Kigali-Central',
              ),
              const SizedBox(height: 24),
              const Text(
                'Operating Location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isGettingLocation)
                            const Text('Detecting location...')
                          else if (_currentPosition != null) ...[
                            Text(
                              _currentAddress ?? 'Location captured',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ] else
                            const Text(
                              'Location not captured',
                              style: TextStyle(color: AppColors.error),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _isGettingLocation ? null : _fetchLocation,
                      icon: const Icon(Icons.my_location, color: AppColors.primary),
                      tooltip: 'Refresh Location',
                    ),
                    IconButton(
                      onPressed: _isGettingLocation ? null : _openMap,
                      icon: const Icon(Icons.edit_location_alt_rounded, color: AppColors.primary),
                      tooltip: 'Select on Map',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _latitudeController,
                      labelText: 'Latitude',
                      hintText: '-1.944100',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      prefixIcon: Icons.my_location,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _longitudeController,
                      labelText: 'Longitude',
                      hintText: '30.061900',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      prefixIcon: Icons.my_location,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _applyManualCoordinates,
                  child: const Text('Apply Manual Coordinates'),
                ),
              ),
              const SizedBox(height: 48),
              CustomButton(
                onPressed: _submit,
                text: 'Submit Registration',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
