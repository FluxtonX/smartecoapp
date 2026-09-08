import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('About SmartEco AI', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / brand header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(Icons.eco, color: AppColors.primary, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SmartEco AI',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Intelligent Waste Management for Rwanda',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),

            _buildSection(
              title: 'The Challenge',
              body: "Rwanda's cities are drowning in waste. Overflowing landfills, harmful methane emissions, and mounting public health risks threaten our nation's progress and our people's wellbeing.",
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: 'Our Solution',
              body: 'The SmartEco AI platform features an AI-powered waste sorting tool and a mobile app that streamlines waste management, making recycling easy, collection efficient, and environmental impact measurable.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: 'How It Works',
              body: "We've built intelligence into every touchpoint:",
            ),
            const SizedBox(height: 12),
            _buildBullet(
              title: 'Smart Recognition',
              body: 'Our AI instantly identifies waste types through a camera',
            ),
            const SizedBox(height: 10),
            _buildBullet(
              title: 'Accessible Everywhere',
              body: 'Leveraging mobile applications, USSD, and WhatsApp, our technology streamlines waste management by facilitating easy recycling, efficient collection, and ensuring services are accessible to users wherever they are.',
            ),
            const SizedBox(height: 10),
            _buildBullet(
              title: 'Connected Infrastructure',
              body: 'IoT-enabled smart bins that optimize collection routes and reduce operational costs',
            ),
            const SizedBox(height: 10),
            _buildBullet(
              title: 'Real Impact',
              body: 'Diverting waste from landfills, cutting emissions, and creating a circular economy',
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: 'Why Now',
              body: "ConsultantTech has developed a platform that's ready to deploy, culturally adapted for Rwanda, and built to scale across East Africa.",
            ),
            const SizedBox(height: 20),

            _buildSection(
              title: 'The Opportunity',
              body: "Join us in turning Rwanda's waste challenge into an environmental and economic success story.",
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // Tagline
            Center(
              child: Text(
                'SmartEco AI: Smarter waste. Cleaner future.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'v1.0.0 • Built by ConsultantTech',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String body}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 1.6),
        children: [
          TextSpan(
            text: '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }

  Widget _buildBullet({required String title, required String body}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6, left: 8, right: 10),
          child: Icon(Icons.circle, size: 6, color: AppColors.textPrimary),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 1.6),
              children: [
                TextSpan(
                  text: '$title ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '– '),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}
