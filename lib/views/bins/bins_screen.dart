import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import 'package:provider/provider.dart';
import '../../controller/bin_controller.dart';
import '../../model/bin_model.dart';
import 'bin_scanner_screen.dart';
import '../../l10n/app_localizations.dart';

class BinsScreen extends StatelessWidget {
  const BinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<BinController>(
        builder: (context, controller, _) {
          return Column(
            children: [
          // Custom App Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.smartBins,
                  style: const TextStyle(
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
            child: controller.isLoading && controller.bins.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Top Card - Total Fill Rate
                        _buildTopCard(context, controller.bins),
                        const SizedBox(height: 16),

                        if (controller.bins.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.0),
                              child: Text(
                                'No bin present for this user',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          ...controller.bins.map((bin) {
                            String title;
                            String subtitle;
                            Color color;
                            String svgPath;
                            
                            switch (bin.wasteType) {
                              case BinWasteType.ORGANIC:
                                title = AppLocalizations.of(context)!.compostBin;
                                subtitle = AppLocalizations.of(context)!.organicWaste;
                                color = AppColors.compost;
                                svgPath = AppSvgs.leafImage;
                                break;
                              case BinWasteType.RECYCLABLE:
                                title = AppLocalizations.of(context)!.recyclingBin;
                                subtitle = AppLocalizations.of(context)!.recyclableMaterials;
                                color = AppColors.recyclable;
                                svgPath = AppSvgs.recyclableImage;
                                break;
                              case BinWasteType.EWASTE:
                                title = AppLocalizations.of(context)!.eWasteBin;
                                subtitle = AppLocalizations.of(context)!.electronicsBatteries;
                                color = AppColors.eWaste;
                                svgPath = AppSvgs.eWasteImage;
                                break;
                              case BinWasteType.GENERAL:
                              case BinWasteType.LANDFILL:
                                title = AppLocalizations.of(context)!.landfillBin;
                                subtitle = AppLocalizations.of(context)!.generalWasteCollection;
                                color = AppColors.landfill;
                                svgPath = AppSvgs.landfillImage;
                                break;
                              case BinWasteType.GLASS:
                                title = 'Glass Bin';
                                subtitle = 'Glass Bottles & Containers';
                                color = AppColors.glass;
                                svgPath = AppSvgs.recyclableImage;
                                break;
                              case BinWasteType.HAZARDOUS:
                                title = AppLocalizations.of(context)!.hazardousBin;
                                subtitle = AppLocalizations.of(context)!.hazardousMaterials;
                                color = AppColors.hazardous;
                                svgPath = AppSvgs.hazardousImage;
                                break;
                              default:
                                title = AppLocalizations.of(context)!.landfillBin;
                                subtitle = AppLocalizations.of(context)!.generalWasteCollection;
                                color = AppColors.general;
                                svgPath = AppSvgs.landfillImage;
                                break;
                            }

                            final isAlert = bin.fillLevel >= 80;
                            final status = bin.fillLevel >= 100 
                                ? AppLocalizations.of(context)!.statusFull 
                                : bin.fillLevel >= 80 
                                    ? AppLocalizations.of(context)!.statusNearlyFull 
                                    : AppLocalizations.of(context)!.statusOk;

                            final lastEmptiedStr = bin.lastEmptiedAt != null 
                              ? AppLocalizations.of(context)!.daysAgo(DateTime.now().difference(bin.lastEmptiedAt!).inDays.toString())
                              : 'Never';

                            return _buildBinCard(
                              context,
                              title: title,
                              subtitle: subtitle,
                              appSvg: svgPath,
                              color: color,
                              fillLevel: bin.fillLevel.toInt(),
                              status: status,
                              lastEmptied: lastEmptiedStr,
                              isAlert: isAlert,
                            );
                          }),

                        const SizedBox(height: 16),

                        // Smart Tip
                        _buildSmartTip(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      );
      },
      ),
    );
  }

  Widget _buildTopCard(BuildContext context, List<BinModel> bins) {
    double totalFillLevel = 0;
    if (bins.isNotEmpty) {
      for (var bin in bins) {
        totalFillLevel += bin.fillLevel;
      }
      totalFillLevel /= bins.length;
    }

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
            children: [
              Text(
                AppLocalizations.of(context)!.totalFillRate,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '${totalFillLevel.toInt()}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BinScannerScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(AppLocalizations.of(context)!.scanBin, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartTip(BuildContext context) {
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
          children: [
            Text(
              AppLocalizations.of(context)!.smartTip,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.landfillFullTip,
              style: const TextStyle(
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

  Widget _buildBinCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String appSvg,
    required Color color,
    required int fillLevel,
    required String status,
    required String lastEmptied,
    bool isAlert = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    Color statusColor;
    if (status == l10n.statusOk) {
      statusColor = Colors.green;
    } else if (status == l10n.statusNearlyFull) {
      statusColor = Colors.orange;
    } else if (status == l10n.statusFull) {
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
            child: SvgPicture.asset(
              appSvg, 
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn), 
              width: 32, 
              height: 32,
            ),
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
                    Text(
                      l10n.fillLevel,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
                      l10n.lastEmptied(lastEmptied),
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
