import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/biometric_service.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isBiometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final enabled = await _biometricService.isBiometricsEnabled();
    if (mounted) {
      setState(() {
        _isBiometricsEnabled = enabled;
      });
    }
  }

  Future<void> _toggleBiometrics(bool? value) async {
    if (value == null) return;

    if (value) {
      if (_isBiometricsEnabled) return; // Already enabled

      // Directly check and authenticate
      final isAvailable = await _biometricService.isBiometricAvailable();
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fingerprint hardware not found on this device.')),
          );
        }
        return;
      }

      final authenticated = await _biometricService.authenticate(
        reason: 'Please authenticate to enable fingerprint login',
      );

      if (authenticated) {
        await _biometricService.setBiometricsEnabled(true);
        await _loadStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint login enabled successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } else {
        // Auth failed or cancelled
        await _loadStatus();
      }
    } else {
      if (!_isBiometricsEnabled) return; // Already disabled
      
      // Trying to disable
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Disable Fingerprint?'),
          content: const Text('Are you sure you want to disable fingerprint login? You will need to use OTP next time.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Disable', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _biometricService.clearBiometricData();
        await _loadStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fingerprint login disabled')),
          );
        }
      } else {
        await _loadStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy and Security'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biometric Authentication',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use your biometrics for faster and secure access to your account.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  RadioListTile<bool>(
                    value: true,
                    groupValue: _isBiometricsEnabled,
                    onChanged: (val) => _toggleBiometrics(true),
                    title: const Text(
                      'Enabled',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text('Fingerprint login is active'),
                    activeColor: AppColors.primary,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  Divider(height: 1, indent: 24, endIndent: 24, color: Colors.grey.shade100),
                  RadioListTile<bool>(
                    value: false,
                    groupValue: _isBiometricsEnabled,
                    onChanged: (val) => _toggleBiometrics(false),
                    title: const Text(
                      'Disabled',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text('Use OTP to login every time'),
                    activeColor: AppColors.primary,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Security Tips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipItem(Icons.lock_outline, 'Never share your OTP with anyone.'),
            _buildTipItem(Icons.verified_user_outlined, 'Ensure your device has a strong screen lock.'),
            _buildTipItem(Icons.history, 'Review your login history regularly.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
