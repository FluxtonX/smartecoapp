import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../controller/auth_controller.dart';
import '../../services/api_service.dart';
import 'package:provider/provider.dart';
import '../../core/utils/navigation_utils.dart';

class CollectorDetailsScreen extends StatefulWidget {
  const CollectorDetailsScreen({super.key});

  @override
  State<CollectorDetailsScreen> createState() => _CollectorDetailsScreenState();
}

class _CollectorDetailsScreenState extends State<CollectorDetailsScreen> {
  final _vehiclePlateController = TextEditingController();
  final _zoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final vehiclePlate = _vehiclePlateController.text.trim();
    final zone = _zoneController.text.trim();

    if (vehiclePlate.isEmpty || zone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.post('/collectors/register-me', {
        'vehiclePlate': vehiclePlate,
        'zone': zone,
      });

      if (response['success'] == true) {
        final authController = Provider.of<AuthController>(context, listen: false);
        await authController.tryAutoLogin(); // refresh profile

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => getLayoutForUser(authController.user)),
            (route) => false,
          );
        }
      } else {
        throw Exception('Failed to register as collector');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collector Details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join as Collector',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Enter your vehicle details and operating zone.'),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _vehiclePlateController,
                labelText: 'Vehicle Plate',
                hintText: 'e.g. RAD 123A',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _zoneController,
                labelText: 'Operating Zone',
                hintText: 'e.g. Kigali-Central',
              ),
              const Spacer(),
              CustomButton(
                onPressed: _submit,
                text: 'Register',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
