import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../services/api_service.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  bool _isChanging = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthController>(context).user;
    final currentPhone = user?.phone ?? '—';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current phone card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Registered Number', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(currentPhone, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                    child: const Text('Verified', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Changing your number will require OTP verification on the new number.',
                      style: TextStyle(color: Colors.orange.shade800, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _isChanging = !_isChanging),
                icon: Icon(_isChanging ? Icons.close : Icons.edit_outlined, color: Colors.white),
                label: Text(
                  _isChanging ? 'Cancel' : 'Change Phone Number',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isChanging ? Colors.grey : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (_isChanging) ...[
              const SizedBox(height: 24),
              _ChangePhoneFlow(currentPhone: currentPhone),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Change Phone Flow ────────────────────────────────────────────────────────

class _ChangePhoneFlow extends StatefulWidget {
  final String currentPhone;
  const _ChangePhoneFlow({required this.currentPhone});

  @override
  State<_ChangePhoneFlow> createState() => _ChangePhoneFlowState();
}

class _ChangePhoneFlowState extends State<_ChangePhoneFlow> {
  // Reuse same country list restriction as login screen
  late final List<Country> _customCountries = countries.map((c) {
    if (['PK', 'RW', 'FR', 'US'].contains(c.code)) return c;
    return Country(
      name: '🔒 ${c.name} (Unavailable)',
      nameTranslations: const {},
      flag: c.flag,
      code: c.code,
      dialCode: c.dialCode,
      minLength: c.minLength,
      maxLength: c.maxLength,
    );
  }).toList();

  final _phoneTextCtrl = TextEditingController();
  final _otpCtrl       = TextEditingController();
  Key _phoneFieldKey   = UniqueKey();

  String _fullPhone       = '';
  String _countryCode     = 'RW';
  bool   _otpSent         = false;
  bool   _isLoading       = false;
  String? _error;

  final ApiService _api = ApiService();

  @override
  void dispose() {
    _phoneTextCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_fullPhone.isEmpty) {
      setState(() => _error = 'Enter a valid phone number');
      return;
    }
    if (_fullPhone == widget.currentPhone) {
      setState(() => _error = 'Please enter a different number');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      final response = await _api.post('/auth/send-otp', {
        'phone': _fullPhone,
        'isLogin': false,
      });
      if (response['success'] == true) {
        setState(() => _otpSent = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP sent to $_fullPhone'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } else {
        setState(() => _error = 'Failed to send OTP. Try again.');
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyAndChange() async {
    if (_otpCtrl.text.trim().length < 4) {
      setState(() => _error = 'Enter the OTP');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      final response = await _api.post('/auth/verify-otp', {
        'phone': _fullPhone,
        'otp': _otpCtrl.text.trim(),
      });
      if (response['success'] == true) {
        await _api.patch('/users/me', {'phone': _fullPhone});
        if (mounted) {
          await Provider.of<AuthController>(context, listen: false).refreshProfile();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Phone number updated successfully!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        setState(() => _error = 'Invalid OTP. Please try again.');
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _otpSent ? 'Enter Verification Code' : 'Enter New Phone Number',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),

          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13))),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (!_otpSent) ...[
            // ── Same IntlPhoneField as login screen ──
            IntlPhoneField(
              key: _phoneFieldKey,
              controller: _phoneTextCtrl,
              countries: _customCountries,
              dropdownTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              dropdownIconPosition: IconPosition.trailing,
              dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
              flagsButtonMargin: const EdgeInsets.only(left: 8),
              decoration: InputDecoration(
                labelText: 'New phone number',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.2))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.05),
              ),
              initialCountryCode: _countryCode,
              onChanged: (phone) => _fullPhone = phone.completeNumber,
              onCountryChanged: (country) {
                if (!['PK', 'RW', 'FR', 'US'].contains(country.code)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Service unavailable in ${country.name}.'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  setState(() => _phoneFieldKey = UniqueKey());
                  return;
                }
                setState(() => _countryCode = country.code);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Send OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ] else ...[
            // ── OTP Entry ──
            Text('Code sent to $_fullPhone', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: '6-digit code',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => setState(() { _otpSent = false; _otpCtrl.clear(); _error = null; }),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Resend', style: TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyAndChange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Verify & Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
