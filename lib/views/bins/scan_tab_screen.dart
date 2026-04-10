import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../core/widgets/custom_button.dart';
import '../../l10n/app_localizations.dart';
import 'bin_scanner_screen.dart';

class ScanTabScreen extends StatefulWidget {
  const ScanTabScreen({super.key});

  @override
  State<ScanTabScreen> createState() => _ScanTabScreenState();
}

class _ScanTabScreenState extends State<ScanTabScreen> {
  bool _isScanning = false;

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
  }

  void _stopScan() {
    setState(() {
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isScanning) {
      return BinScannerScreen(
        onClose: _stopScan,
        isEmbedded: true,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppSvgs.qrCodeImage,
                  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.scanBin,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scan the QR code on any SmartEco bin to view its status and earn points.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              CustomButton(
                onPressed: _startScan,
                text: AppLocalizations.of(context)!.scanBin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
