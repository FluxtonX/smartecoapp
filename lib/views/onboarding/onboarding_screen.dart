import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/dot_indicator.dart';
import '../auth/create_account_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Smart Waste Management',
      'description': 'Schedule pickups, track collectors, and manage waste efficiently with our innovative platform.',
      'icon': Icons.eco_outlined,
      'color': const Color(0xFFE8F5E9),
      'iconColor': AppColors.primary,
    },
    {
      'title': 'Real-Time Tracking',
      'description': 'Monitor your waste collector in real-time with live GPS tracking and accurate ETAs.',
      'icon': Icons.location_on_outlined,
      'color': const Color(0xFFE3F2FD),
      'iconColor': Colors.blue,
    },
    {
      'title': 'Earn EcoPoints',
      'description': 'Get rewarded for proper waste management. Redeem points for exciting rewards and benefits.',
      'icon': Icons.card_giftcard,
      'color': const Color(0xFFFFF3E0),
      'iconColor': Colors.orange,
    },
  ];

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: data['color'] as Color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            data['icon'] as IconData,
                            size: 64,
                            color: data['iconColor'] as Color,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          data['title'] as String,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['description'] as String,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  DotIndicator(
                    totalDots: _onboardingData.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    onPressed: _onNext,
                    text: _currentPage == _onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next >',
                  ),
                  if (_currentPage != _onboardingData.length - 1) ...[
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: _goToAuth,
                      text: 'Skip',
                      isOutlined: true,
                    ),
                  ] else ...[
                    // Just a filler so height remains almost consistent or not needed
                    const SizedBox(height: 16),
                    const SizedBox(height: 50),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
