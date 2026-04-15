import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/theme/app_colors.dart';

// Simple model for a saved address
class SavedAddress {
  final String label; // e.g. Home, Work, Other
  final String address;
  final double latitude;
  final double longitude;

  SavedAddress({
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  // Placeholder list – in a real app these would come from your API/controller
  final List<SavedAddress> _addresses = [
    SavedAddress(label: 'Home', address: 'KG 11 Ave, Kigali, Rwanda', latitude: -1.9441, longitude: 30.0619),
    SavedAddress(label: 'Work', address: 'KN 5 Rd, Kigali, Rwanda', latitude: -1.9536, longitude: 30.0606),
  ];

  void _openAddAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAddressSheet(
        onAdded: (addr) {
          setState(() => _addresses.add(addr));
        },
      ),
    );
  }

  void _deleteAddress(int index) {
    setState(() => _addresses.removeAt(index));
  }

  IconData _labelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home': return Icons.home_outlined;
      case 'work': return Icons.work_outline;
      default: return Icons.location_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Addresses', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('No addresses saved yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _openAddAddressSheet,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final addr = _addresses[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_labelIcon(addr.label), color: AppColors.primary, size: 22),
                    ),
                    title: Text(addr.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(addr.address, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteConfirm(index),
                    ),
                    onTap: () => _showAddressOnMap(addr),
                  ),
                );
              },
            ),
      floatingActionButton: _addresses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _openAddAddressSheet,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Address', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Address'),
        content: const Text('Are you sure you want to remove this address?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); _deleteAddress(index); },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddressOnMap(SavedAddress addr) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _MapViewScreen(address: addr),
    ));
  }
}

// ─── Bottom Sheet: Add Address ───────────────────────────────────────────────

class _AddAddressSheet extends StatefulWidget {
  final void Function(SavedAddress) onAdded;
  const _AddAddressSheet({required this.onAdded});

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  int _mode = 0; // 0 = text, 1 = map
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _selectedLabel = 'Home';
  bool _isLoading = false;

  // Map picker state
  LatLng? _pickedLocation;
  String _resolvedAddress = '';
  GoogleMapController? _mapController;

  final List<String> _labels = ['Home', 'Work', 'Other'];

  @override
  void dispose() {
    _addressController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _geocodeText() async {
    final text = _addressController.text.trim();
    if (text.isEmpty) return;
    try {
      final locations = await locationFromAddress(text);
      if (locations.isNotEmpty) {
        setState(() {
          _pickedLocation = LatLng(locations.first.latitude, locations.first.longitude);
        });
      }
    } catch (_) {}
  }

  Future<void> _onMapTap(LatLng pos) async {
    setState(() { _pickedLocation = pos; _isLoading = true; });
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _resolvedAddress = [p.street, p.locality, p.country]
              .where((s) => s != null && s.isNotEmpty)
              .join(', ');
          _addressController.text = _resolvedAddress;
        });
      }
    } catch (_) {} finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) { setState(() => _isLoading = false); return; }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) { setState(() => _isLoading = false); return; }
      final pos = await Geolocator.getCurrentPosition();
      final ll = LatLng(pos.latitude, pos.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(ll, 15));
      await _onMapTap(ll);
    } catch (_) { setState(() => _isLoading = false); }
  }

  void _submit() {
    if (_mode == 0) {
      if (!_formKey.currentState!.validate()) return;
      // Use dummy coords if geocoding didn't resolve
      final lat = _pickedLocation?.latitude ?? 0.0;
      final lng = _pickedLocation?.longitude ?? 0.0;
      widget.onAdded(SavedAddress(
        label: _selectedLabel,
        address: _addressController.text.trim(),
        latitude: lat,
        longitude: lng,
      ));
      Navigator.pop(context);
    } else {
      if (_pickedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a location on the map')),
        );
        return;
      }
      widget.onAdded(SavedAddress(
        label: _selectedLabel,
        address: _resolvedAddress.isNotEmpty ? _resolvedAddress : 'Pinned Location',
        latitude: _pickedLocation!.latitude,
        longitude: _pickedLocation!.longitude,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      margin: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text('Add Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          // Mode toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _modeChip(0, Icons.edit_outlined, 'Type Address'),
                const SizedBox(width: 10),
                _modeChip(1, Icons.map_outlined, 'Pick on Map'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _mode == 0 ? _buildTextForm() : _buildMapPicker(),
          ),
          // Submit button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Save Address', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeChip(int mode, IconData icon, String label) {
    final selected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Label', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Row(
              children: _labels.map((l) {
                final sel = _selectedLabel == l;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(l),
                    selected: sel,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textPrimary),
                    onSelected: (_) => setState(() => _selectedLabel = l),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Address', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. KG 11 Ave, Kigali',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: AppColors.primary),
                  onPressed: _geocodeText,
                  tooltip: 'Search on map',
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter an address' : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _useCurrentLocation,
              icon: const Icon(Icons.my_location, color: AppColors.primary),
              label: const Text('Use My Current Location', style: TextStyle(color: AppColors.primary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPicker() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (c) => _mapController = c,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-1.9441, 30.0619), // Kigali default
                  zoom: 13,
                ),
                onTap: _onMapTap,
                markers: _pickedLocation == null
                    ? {}
                    : {
                        Marker(
                          markerId: const MarkerId('picked'),
                          position: _pickedLocation!,
                          infoWindow: InfoWindow(title: _resolvedAddress.isNotEmpty ? _resolvedAddress : 'Selected'),
                        ),
                      },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
              // Hint overlay
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.touch_app, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _resolvedAddress.isNotEmpty ? _resolvedAddress : 'Tap the map to pin your location',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Current location button
              Positioned(
                bottom: 12,
                right: 12,
                child: FloatingActionButton.small(
                  heroTag: 'loc_btn',
                  backgroundColor: Colors.white,
                  onPressed: _useCurrentLocation,
                  child: const Icon(Icons.my_location, color: AppColors.primary),
                ),
              ),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        // Label selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              const Text('Label: ', style: TextStyle(fontWeight: FontWeight.w600)),
              ..._labels.map((l) {
                final sel = _selectedLabel == l;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l),
                    selected: sel,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textPrimary),
                    onSelected: (_) => setState(() => _selectedLabel = l),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Map View Screen (tap saved address to view) ─────────────────────────────

class _MapViewScreen extends StatelessWidget {
  final SavedAddress address;
  const _MapViewScreen({required this.address});

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(address.latitude, address.longitude);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(address.label),
        centerTitle: true,
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: pos, zoom: 15),
        markers: {
          Marker(
            markerId: const MarkerId('saved'),
            position: pos,
            infoWindow: InfoWindow(title: address.label, snippet: address.address),
          ),
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
