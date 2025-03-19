import 'package:digitaltwinpoc/utils/theme.dart';
import 'package:flutter/material.dart';
import '../../models/asset.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback onTap;

  const AssetCard({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = asset.status['health'] as String;
    final Color statusColor;

    switch (status.toLowerCase()) {
      case 'good':
        statusColor = AppColors.success;
        break;
      case 'warning':
        statusColor = AppColors.warning;
        break;
      case 'critical':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForAssetType(asset.type),
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                asset.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                asset.type,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      asset.location,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForAssetType(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'wind turbine':
        return Icons.air;
      case 'water pump':
        return Icons.water_drop;
      case 'power generator':
        return Icons.power;
      case 'hvac unit':
        return Icons.ac_unit;
      case 'solar panel':
        return Icons.sunny;
      case 'motor':
        return Icons.settings;
      default:
        return Icons.devices_other;
    }
  }
}