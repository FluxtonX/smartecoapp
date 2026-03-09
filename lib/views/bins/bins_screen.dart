import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BinsScreen extends StatelessWidget {
  const BinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Custom App Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Text(
                  'Smart Bins',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top Card - Total Fill Rate
                  _buildTopCard(),
                  const SizedBox(height: 16),

                  // Bin Cards
                  _buildBinCard(
                    title: 'Compost Bin',
                    subtitle: 'Organic Waste',
                    icon: Icons.eco_outlined,
                    color: AppColors.compost,
                    fillLevel: 45,
                    status: 'OK',
                    lastEmptied: '3 days ago',
                  ),
                  _buildBinCard(
                    title: 'Recycling Bin',
                    subtitle: 'Recyclable Materials',
                    icon: Icons.recycling_outlined,
                    color: AppColors.recyclable,
                    fillLevel: 78,
                    status: 'Nearly Full',
                    lastEmptied: '5 days ago',
                    isAlert: true,
                  ),
                  _buildBinCard(
                    title: 'E-Waste Bin',
                    subtitle: 'Electronics & Batteries',
                    icon: Icons.memory,
                    color: AppColors.eWaste,
                    fillLevel: 20,
                    status: 'OK',
                    lastEmptied: '10 days ago',
                  ),
                  _buildBinCard(
                    title: 'Landfill Bin',
                    subtitle: 'General Waste',
                    icon: Icons.delete_outline,
                    color: AppColors.landfill,
                    fillLevel: 92,
                    status: 'Full',
                    lastEmptied: '6 days ago',
                    isAlert: true,
                  ),
                  _buildBinCard(
                    title: 'Hazardous Bin',
                    subtitle: 'Hazardous Materials',
                    icon: Icons.wine_bar_outlined,
                    color: AppColors.hazardous,
                    fillLevel: 15,
                    status: 'OK',
                    lastEmptied: '15 days ago',
                  ),

                  const SizedBox(height: 16),

                  // Smart Tip
                  _buildSmartTip(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Total Fill Rate',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                '50%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 18),
                  SizedBox(width: 6),
                  Text('Scan Bin', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartTip() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.blue, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Smart Tip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Your Landfill Bin is full. Schedule a pickup to earn EcoPoints and keep your bins clean!',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int fillLevel,
    required String status,
    required String lastEmptied,
    bool isAlert = false,
  }) {
    Color statusColor;
    if (status == 'OK') {
      statusColor = Colors.green;
    } else if (status == 'Nearly Full') {
      statusColor = Colors.orange;
    } else if (status == 'Full') {
      statusColor = AppColors.error;
    } else {
      statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isAlert)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                      ),
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fill Level',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    Text(
                      '$fillLevel%',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fillLevel / 100,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Last: $lastEmptied',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
