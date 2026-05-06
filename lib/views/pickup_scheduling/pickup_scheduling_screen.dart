import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../../controller/pickup_controller.dart';
import '../../core/widgets/custom_loader.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'pickup_success_screen.dart';

class PickupSchedulingScreen extends StatefulWidget {
  final String? initialWasteType;
  const PickupSchedulingScreen({super.key, this.initialWasteType});

  @override
  State<PickupSchedulingScreen> createState() => _PickupSchedulingScreenState();
}

class _PickupSchedulingScreenState extends State<PickupSchedulingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form State
  // Form State
  String? _selectedWasteType;
  Map<String, String>? _selectedDateObj;
  String? _selectedDate;
  String? _selectedTime;
  String? _selectedTimeSlot;
  // String _selectedAddress = "Home"; // Default
  String? _selectedPaymentMethod;
  LatLng? _selectedLocation;
  String _addressText = ''; // Removed hardcoded Rwanda address
  final TextEditingController _addressController = TextEditingController();
  GoogleMapController? _mapController;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _selectedWasteType = widget.initialWasteType;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      if (await Geolocator.isLocationServiceEnabled() == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services on your device.')),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }
    } catch (e) {
      debugPrint("Location services check failed: $e");
      // Fallback or just continue to permission check
    }

    // First request permission explicitly using permission_handler
    final status = await Permission.location.request();
    if (status.isDenied) {
      debugPrint("Location permission denied by user via permission_handler.");
      setState(() => _isLoadingLocation = false);
      return;
    }

    if (status.isPermanentlyDenied) {
      // Don't force open settings. Let the user enter address manually instead.
      debugPrint("Location permission permanently denied.");
      setState(() => _isLoadingLocation = false);
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoadingLocation = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = latLng;
        _isLoadingLocation = false;
      });
      
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      _getAddressFromLatLng(latLng);
    } catch (e) {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final address = "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.country}";
        setState(() {
          _addressText = address;
          _addressController.text = address;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final latLng = LatLng(loc.latitude, loc.longitude);
        setState(() {
          _selectedLocation = latLng;
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        _getAddressFromLatLng(latLng);
      }
    } catch (e) {
      _showToast("Address not found. Please try again.", isError: true);
    }
  }

  void _showAddressEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24, // 🔥 KEY FIX
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Address',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your address or a nearby landmark to update your pickup location.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _addressController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search for address...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (val) {
                        _searchAddress(val);
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _searchAddress(_addressController.text);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Confirm New Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  void _nextStep() {
    // Validation
    if (_currentStep == 0 && _selectedWasteType == null) {
      _showToast(AppLocalizations.of(context)!.errSelectWaste, isError: true);
      return;
    }
    if (_currentStep == 1 && _selectedDate == null) {
      _showToast(AppLocalizations.of(context)!.errSelectDate, isError: true);
      return;
    }
    if (_currentStep == 2 && _selectedTime == null) {
      _showToast(AppLocalizations.of(context)!.errSelectTime, isError: true);
      return;
    }
    if (_currentStep == 3 && (_selectedLocation == null || _addressText.isEmpty)) {
      _showToast("Please confirm your pickup location", isError: true);
      return;
    }
    if (_currentStep == 4) {
      if (_selectedPaymentMethod == null) {
        _showToast(AppLocalizations.of(context)!.errSelectPayment, isError: true);
        return;
      }
      _onConfirmPayment();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentStep++;
    });
  }

  Future<void> _onConfirmPayment() async {
    final pickupController = Provider.of<PickupController>(context, listen: false);

    // 1. Create Pickup
    final success = await pickupController.scheduleNewPickup({
      'wasteType': _selectedWasteType,
      'scheduledDate': _selectedDateObj?['fullDate'],
      'timeSlot': _selectedTimeSlot,
      'address': _addressText,
      'latitude': _selectedLocation?.latitude ?? 33.6844,
      'longitude': _selectedLocation?.longitude ?? 73.0479,
      'paymentMethod': _selectedPaymentMethod == 'momo' ? 'MTN_MOMO' : 'AIRTEL_MONEY',
    });

    if (!success) {
      if (mounted) {
        _showToast(pickupController.error ?? 'Failed to schedule pickup', isError: true);
      }
      return;
    }

    final newPickup = pickupController.activePickup;
    if (newPickup == null || newPickup.payment == null) {
      // Fallback if no payment object found
      _goToSuccessScreen();
      return;
    }

    // 2. Show Payment Processing Dialog
    _showPaymentProcessingDialog(newPickup.payment!['id'].toString());
  }

  void _showPaymentProcessingDialog(String paymentId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Processing Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please check your phone for the mobile money PIN prompt. We are waiting for your approval...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );

    // 3. Start Polling
    _pollPaymentStatus(paymentId);
  }

  Future<void> _pollPaymentStatus(String paymentId) async {
    final pickupController = Provider.of<PickupController>(context, listen: false);
    int attempts = 0;
    const maxAttempts = 15; // 30 seconds total

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      attempts++;
      final statusData = await pickupController.getPaymentStatus(paymentId);
      final status = statusData['status'];
      final reason = statusData['reason'];
      
      if (status == 'COMPLETED') {
        timer.cancel();
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
          _goToSuccessScreen();
        }
      } else if (status == 'FAILED') {
        timer.cancel();
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
          _showPaymentFailedDialog(reason);
        }
      } else if (attempts >= maxAttempts) {
        timer.cancel();
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
          // If timeout, we still show success screen but maybe it stays PENDING in backend
          _goToSuccessScreen();
        }
      }
    });
  }

  void _showPaymentFailedDialog(String? reason) {
    String message = 'We could not process your payment. This could be due to a wrong PIN, insufficient balance, or a network issue.';
    
    // Friendly error mappings from documentation
    if (reason != null) {
      if (reason.contains('NOT_ENOUGH_FUNDS')) {
        message = 'You do not have enough funds in your wallet. Please top up and try again.';
      } else if (reason.contains('PAYER_NOT_FOUND')) {
        message = 'Mobile money wallet not found for this phone number. Please check your number.';
      } else if (reason.contains('PAYER_LIMIT_REACHED')) {
        message = 'Your wallet has reached its daily or monthly transaction limit.';
      } else if (reason.contains('COULD_NOT_PERFORM_TRANSACTION')) {
        message = 'The transaction timed out. Please check your phone and try again.';
      } else if (reason.contains('PAYEE_NOT_ALLOWED_TO_RECEIVE')) {
        message = 'Our system is currently unable to receive payments. Please try again later.';
      } else if (reason.contains('VALIDATION_ERROR')) {
        message = 'There was a validation error with the payment request. Please contact support.';
      }
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Payment Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close error dialog
              _onConfirmPayment(); // Retry
            },
            child: const Text('Retry Payment', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back from scheduling
            },
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _goToSuccessScreen() {
    final pickupController = Provider.of<PickupController>(context, listen: false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PickupSuccessScreen(
          date: _selectedDate!,
          time: _selectedTime!,
          reference: pickupController.activePickup?.reference ?? 'ECO-XXXXXX',
        ),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showToast(String message, {bool isError = true}) {
    final bgColor = isError ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5);
    final fgColor = isError ? Colors.red : AppColors.primary;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: fgColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: fgColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _previousStep,
        ),
        title: Row(
          children: List.generate(_totalSteps, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                decoration: BoxDecoration(
                  color: index <= _currentStep
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildWasteSelection(),
          _buildDateSelection(),
          _buildTimeSelection(),
          _buildAddressSelection(),
          _buildPaymentSelection(),
        ],
      ),
    );
  }

  // ============== STEP 1: WASTE SELECTION ==============
  Widget _buildWasteSelection() {
    final wasteCategories = [
      {
        'id': 'ORGANIC',
        'title': AppLocalizations.of(context)!.organicWasteTitle,
        'desc': AppLocalizations.of(context)!.organicWasteDesc,
        'svg': AppSvgs.leafImage,
        'color': AppColors.compost,
      },
      {
        'id': 'RECYCLABLE',
        'title': AppLocalizations.of(context)!.recyclableWasteTitle,
        'desc': AppLocalizations.of(context)!.recyclableWasteDesc,
        'svg': AppSvgs.recyclableImage,
        'color': AppColors.recyclable,
      },
      {
        'id': 'GENERAL',
        'title': AppLocalizations.of(context)!.generalWasteTitle,
        'desc': AppLocalizations.of(context)!.generalWasteDesc,
        'svg': AppSvgs.binImage,
        'color': AppColors.general,
      },
      {
        'id': 'EWASTE',
        'title': AppLocalizations.of(context)!.eWasteTitle,
        'desc': AppLocalizations.of(context)!.eWasteDesc,
        'svg': AppSvgs.eWasteImage,
        'color': AppColors.eWaste,
      },
      {
        'id': 'GLASS',
        'title': AppLocalizations.of(context)!.glassWasteTitle,
        'desc': AppLocalizations.of(context)!.glassWasteDesc,
        'svg': AppSvgs.hazardousImage,
        'color': AppColors.hazardous,
      },
    ];

    return _buildStepLayout(
      title: AppLocalizations.of(context)!.selectWasteType,
      subtitle: AppLocalizations.of(context)!.chooseWasteCategories,
      child: ListView.separated(
        itemCount: wasteCategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = wasteCategories[index];
          final isSelected = _selectedWasteType == cat['id'];
          return _buildSelectableCard(
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedWasteType = cat['id'] as String;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    cat['svg'] as String,
                    colorFilter: ColorFilter.mode(
                      cat['color'] as Color,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        cat['desc'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_box, color: AppColors.primary),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============== STEP 2: DATE SELECTION ==============
  List<Map<String, String>> _generateDates() {
    final List<Map<String, String>> dates = [];
    final now = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      dates.add({
        'id': DateFormat('EEEE\nMMM d').format(date),
        'day': DateFormat('EEEE').format(date),
        'date': DateFormat('MMM d').format(date),
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
      });
    }
    return dates;
  }

  Widget _buildDateSelection() {
    final dates = _generateDates();

    return _buildStepLayout(
      title: AppLocalizations.of(context)!.selectDate,
      subtitle: AppLocalizations.of(context)!.advanceNotice,
      child: ListView.separated(
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final d = dates[index];
          final isSelected = _selectedDate == d['id'];
          return _buildSelectableCard(
            isSelected: isSelected,
            onTap: () => setState(() {
              _selectedDate = d['id'];
              _selectedDateObj = d;
            }),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        d['date']!.split(' ')[0],
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        d['date']!.split(' ')[1],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d['day']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        d['date']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_box, color: AppColors.primary)
                else
                  const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============== STEP 3: TIME SELECTION ==============
  Widget _buildTimeSelection() {
    final now = DateTime.now();
    final isTomorrow = _selectedDate == _generateDates().first['id'];

    final allTimes = [
      {'label': '8:00 AM - 10:00 AM', 'hour': 8, 'slot': 'MORNING_8_10'},
      {'label': '10:00 AM - 12:00 PM', 'hour': 10, 'slot': 'MORNING_10_12'},
      {'label': '2:00 PM - 4:00 PM', 'hour': 14, 'slot': 'AFTERNOON_2_4'},
      {'label': '4:00 PM - 6:00 PM', 'hour': 16, 'slot': 'AFTERNOON_4_6'},
    ];

    List<Map<String, dynamic>> availableTimes = allTimes;

    if (isTomorrow) {
      availableTimes = allTimes.where((t) {
        final slotStartTomorrow = DateTime(now.year, now.month, now.day + 1, t['hour'] as int);
        return slotStartTomorrow.difference(now).inHours >= 24;
      }).toList();
    }

    return _buildStepLayout(
      title: AppLocalizations.of(context)!.selectTime,
      subtitle: AppLocalizations.of(context)!.advanceNotice,
      child: availableTimes.isEmpty 
        ? Center(child: Text(AppLocalizations.of(context)!.noSlotsAvailableTomorrow))
        : ListView.separated(
        itemCount: availableTimes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final t = availableTimes[index]['label'] as String;
          final slot = availableTimes[index]['slot'] as String;
          final isSelected = _selectedTime == t;
          return _buildSelectableCard(
            isSelected: isSelected,
            onTap: () => setState(() {
              _selectedTime = t;
              _selectedTimeSlot = slot;
            }),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.textSecondary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.available,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_box, color: AppColors.primary)
                else
                  const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============== STEP 4: ADDRESS SELECTION ==============
  Widget _buildAddressSelection() {
    return _buildStepLayout(
      title: AppLocalizations.of(context)!.confirmAddress,
      subtitle: AppLocalizations.of(context)!.verifyLocation,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isLoadingLocation 
                  ? const Center(child: CustomLoader())
                  : GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? const LatLng(33.6844, 73.0479), // Islamabad
                    zoom: 14.0,
                  ),
                  onCameraMove: (position) {
                    _selectedLocation = position.target;
                  },
                  onCameraIdle: () {
                    if (_selectedLocation != null) {
                      _getAddressFromLatLng(_selectedLocation!);
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.home_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeLocation,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _addressText.isEmpty 
                          ? (_isLoadingLocation ? 'Locating...' : 'Tap Edit to enter address') 
                          : _addressText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _showAddressEditSheet,
                  child: Text(
                    AppLocalizations.of(context)!.edit,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============== STEP 5: PAYMENT SELECTION ==============
  Widget _buildPaymentSelection() {
    final payments = [
      {'id': 'momo', 'title': 'MTN MoMo', 'icon': Icons.phone_android},
      {'id': 'airtel', 'title': 'Airtel Money', 'icon': Icons.phone_android},
    ];

    return _buildStepLayout(
      title: AppLocalizations.of(context)!.paymentMethod,
      subtitle: AppLocalizations.of(context)!.choosePayment,
      child: Column(
        children: [
          ...payments.map((p) {
            final isSelected = _selectedPaymentMethod == p['id'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSelectableCard(
                isSelected: isSelected,
                onTap: () =>
                    setState(() => _selectedPaymentMethod = p['id'] as String),
                child: Row(
                  children: [
                    Icon(p['icon'] as IconData, color: AppColors.textSecondary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        p['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_box, color: AppColors.primary)
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // No borders in mockup, just clean text
            ),
            child: Column(
              children: [
                _buildSummaryRow(AppLocalizations.of(context)!.serviceFee, '1,500 RWF'),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  AppLocalizations.of(context)!.ecoPointsDiscount,
                  '-300 RWF',
                  valueColor: AppColors.primary,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _buildSummaryRow(AppLocalizations.of(context)!.total, '1,200 RWF', isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color valueColor = AppColors.textPrimary,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  // ============== HELPER WIDGETS ==============
  Widget _buildStepLayout({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final pickupController = Provider.of<PickupController>(context);
    bool canContinue = true;
    if (_currentStep == 0 && _selectedWasteType == null) canContinue = false;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(child: child),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: pickupController.isLoading || !canContinue ? null : _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: canContinue ? AppColors.primary : Colors.white,
              foregroundColor: canContinue ? Colors.white : AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
                side: BorderSide(
                  color: canContinue ? Colors.transparent : AppColors.primary,
                ),
              ),
              elevation: 0,
            ),
            child: pickupController.isLoading 
              ? const SizedBox(height: 20, width: 20, child: CustomLoader(size: 20))
              : Text(
              _currentStep == _totalSteps - 1 
                ? AppLocalizations.of(context)!.confirmPayment
                : AppLocalizations.of(context)!.continueBtn,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8,)
        ],
      ),
    );
  }

  Widget _buildSelectableCard({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: child,
      ),
    );
  }
}
