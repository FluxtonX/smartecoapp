import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_images.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/dot_indicator.dart';
import '../auth/create_account_screen.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> _getOnboardingData(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'title': l10n.onboarding1Title,
        'description': l10n.onboarding1Desc,
        'image': AppSvgs.leafImage,
        'color': const Color(0xFFE8F5E9),
      },
      {
        'title': l10n.onboarding2Title,
        'description': l10n.onboarding2Desc,
        'image': AppSvgs.mapImage,
        'color': const Color(0xFFE3F2FD),
      },
      {
        'title': l10n.onboarding3Title,
        'description': l10n.onboarding3Desc,
        'image': AppSvgs.giftImage,
        'color': const Color(0xFFFFF3E0),
      },
    ];
  }

  void _onNext(int dataLength) {
    if (_currentPage < dataLength - 1) {
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
    final onboardingData = _getOnboardingData(context);
    final l10n = AppLocalizations.of(context)!;

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
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
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
                          child: SvgPicture.asset(
                            data['image'] as String,
                            width: 140,
                            height: 140,
                            fit: BoxFit.contain,
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
                        const SizedBox(height: 32),
                        DotIndicator(
                          totalDots: onboardingData.length,
                          currentIndex: _currentPage,
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
                  CustomButton(
                    onPressed: () => _onNext(onboardingData.length),
                    text: _currentPage == onboardingData.length - 1
                        ? l10n.getStarted
                        : l10n.next,
                  ),
                  if (_currentPage != onboardingData.length - 1) ...[
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: _goToAuth,
                      text: l10n.skip,
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
