import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'pickup_success_screen.dart';

class PickupSchedulingScreen extends StatefulWidget {
  const PickupSchedulingScreen({super.key});

  @override
  State<PickupSchedulingScreen> createState() => _PickupSchedulingScreenState();
}

class _PickupSchedulingScreenState extends State<PickupSchedulingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form State
  List<String> _selectedWasteTypes = [];
  String? _selectedDate;
  String? _selectedTime;
  String _selectedAddress = "Home"; // Default
  String? _selectedPaymentMethod;

  void _nextStep() {
    // Validation
    if (_currentStep == 0 && _selectedWasteTypes.isEmpty) {
      _showToast('Please select at least one waste type', isError: true);
      return;
    }
    if (_currentStep == 1 && _selectedDate == null) {
      _showToast('Please select a date', isError: true);
      return;
    }
    if (_currentStep == 2 && _selectedTime == null) {
      _showToast('Please select a time slot', isError: true);
      return;
    }
    if (_currentStep == 4) {
      if (_selectedPaymentMethod == null) {
        _showToast('Please select a payment method', isError: true);
        return;
      }
      // Submit and go to success
      _showToast('Pickup scheduled successfully!', isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PickupSuccessScreen(
            date: _selectedDate!,
            time: _selectedTime!,
            reference: 'ECO-ULK6WS',
          ),
        ),
      );
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
                  color: index <= _currentStep ? AppColors.primary : Colors.grey.shade300,
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
      {'id': 'Organic', 'title': 'Organic', 'desc': 'Food waste, garden waste', 'icon': Icons.eco_outlined, 'color': AppColors.compost},
      {'id': 'Recyclable', 'title': 'Recyclable', 'desc': 'Paper, plastic, metal', 'icon': Icons.recycling_outlined, 'color': AppColors.recyclable},
      {'id': 'General', 'title': 'General', 'desc': 'Non-recyclable waste', 'icon': Icons.delete_outline, 'color': AppColors.general},
      {'id': 'EWaste', 'title': 'E-Waste', 'desc': 'Electronics, batteries', 'icon': Icons.computer_outlined, 'color': AppColors.eWaste},
      {'id': 'Glass', 'title': 'Glass', 'desc': 'Bottles, glassware', 'icon': Icons.wine_bar_outlined, 'color': AppColors.glass},
    ];

    return _buildStepLayout(
      title: 'Select Waste Type',
      subtitle: 'Choose one or more waste categories',
      child: ListView.separated(
        itemCount: wasteCategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = wasteCategories[index];
          final isSelected = _selectedWasteTypes.contains(cat['id']);
          return _buildSelectableCard(
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedWasteTypes.remove(cat['id']);
                } else {
                  _selectedWasteTypes.add(cat['id'] as String);
                }
              });
            },
            child: Row(
              children: [
                Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cat['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      Text(cat['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_box, color: AppColors.primary)
                else
                  Icon(Icons.check_box_outline_blank, color: Colors.grey.shade300),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============== STEP 2: DATE SELECTION ==============
  Widget _buildDateSelection() {
    final dates = [
      {'id': 'Saturday\nFeb 21', 'day': 'Saturday', 'date': 'Feb 21'},
      {'id': 'Sunday\nFeb 22', 'day': 'Sunday', 'date': 'Feb 22'},
      {'id': 'Monday\nFeb 23', 'day': 'Monday', 'date': 'Feb 23'},
      {'id': 'Tuesday\nFeb 24', 'day': 'Tuesday', 'date': 'Feb 24'},
      {'id': 'Wednesday\nFeb 25', 'day': 'Wednesday', 'date': 'Feb 25'},
      {'id': 'Thursday\nFeb 26', 'day': 'Thursday', 'date': 'Feb 26'},
      {'id': 'Friday\nFeb 27', 'day': 'Friday', 'date': 'Feb 27'},
    ];

    return _buildStepLayout(
      title: 'Select Date',
      subtitle: 'Pickups must be scheduled 24 hours in advance',
      child: ListView.separated(
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final d = dates[index];
          final isSelected = _selectedDate == d['id'];
          return _buildSelectableCard(
            isSelected: isSelected,
            onTap: () => setState(() => _selectedDate = d['id']),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(d['date']!.split(' ')[0], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text(d['date']!.split(' ')[1], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['day']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      Text(d['date']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
    final times = [
      '8:00 AM - 10:00 AM',
      '10:00 AM - 12:00 PM',
      '12:00 PM - 2:00 PM',
      '2:00 PM - 4:00 PM',
      '4:00 PM - 6:00 PM'
    ];

    return _buildStepLayout(
      title: 'Select Time',
      subtitle: 'Pickups must be scheduled 24 hours in advance',
      child: ListView.separated(
        itemCount: times.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final t = times[index];
          final isSelected = _selectedTime == t;
          return _buildSelectableCard(
            isSelected: isSelected,
            onTap: () => setState(() => _selectedTime = t),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.textSecondary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      const Text('Available', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
      title: 'Confirm Address',
      subtitle: 'Verify your pickup location',
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
              child: Stack(
                children: [
                  // Subtle grid lines to simulate map
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: _MapGridPainter(),
                  ),
                  const Center(
                    child: Icon(Icons.location_on, size: 48, color: AppColors.primary),
                  ),
                ],
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
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.home_outlined, color: AppColors.primary, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text('Kg 123 St, Kigali, Gasabo District, Rwanda', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit', style: TextStyle(color: AppColors.primary)),
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
      title: 'Payment Method',
      subtitle: 'Choose how you want to pay',
      child: Column(
        children: [
          ...payments.map((p) {
            final isSelected = _selectedPaymentMethod == p['id'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSelectableCard(
                isSelected: isSelected,
                onTap: () => setState(() => _selectedPaymentMethod = p['id'] as String),
                child: Row(
                  children: [
                    Icon(p['icon'] as IconData, color: AppColors.textSecondary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(p['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                _buildSummaryRow('Service Fee', '1,500 RWF'),
                const SizedBox(height: 8),
                _buildSummaryRow('EcoPoints Discount', '-300 RWF', valueColor: AppColors.primary),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _buildSummaryRow('Total', '1,200 RWF', isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color valueColor = AppColors.textPrimary, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isBold ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 14)),
        Text(value, style: TextStyle(color: valueColor, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 14)),
      ],
    );
  }

  // ============== HELPER WIDGETS ==============
  Widget _buildStepLayout({required String title, required String subtitle, required Widget child}) {
    bool canContinue = true;
    if (_currentStep == 0 && _selectedWasteTypes.isEmpty) canContinue = false;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Expanded(child: child),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: canContinue ? AppColors.primary : Colors.white,
              foregroundColor: canContinue ? Colors.white : AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: canContinue ? Colors.transparent : AppColors.primary),
              ),
              elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard({required bool isSelected, required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: isSelected ? 2 : 1),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
          ],
        ),
        child: child,
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

