import 'package:digitaltwinpoc/models/asset.dart';
import 'package:digitaltwinpoc/utils/helpers.dart';
import 'package:digitaltwinpoc/utils/theme.dart';
import 'package:flutter/material.dart';

class AssetTileWidget extends StatelessWidget {
  final Asset asset;
  final VoidCallback onTap;
  final bool showNotificationIndicator;

  const AssetTileWidget({
    super.key,
    required this.asset,
    required this.showNotificationIndicator,
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
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: AppColors.textSecondary),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: statusColor, width: 4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Center(
                        child: Icon(
                          Helpers.getIconForAssetType(asset.type),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              asset.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
                                  // color: Colors.grey[500],
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    asset.location,
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(asset.type, style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildKeyMetrics(asset)),
                      Expanded(
                        child:
                            showNotificationIndicator
                                ? _buildNotificationIndicator(asset)
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIndicator(Asset asset) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
      ),
      child: Icon(
        Icons.notifications_active,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }

  Widget _buildKeyMetrics(Asset asset) {
    // Display top two key metrics based on asset type
    List<Map<String, dynamic>> metrics = [];

    // Define priority order for metrics
    final priorityKeys = [
      'power',
      'flowRate',
      'output',
      'temperature',
      'pressure',
      'efficiency',
    ];

    // Map of metrics with their labels and units
    final metricDefinitions = {
      'power': {'label': 'Power', 'unit': 'MW'},
      'flowRate': {'label': 'Flow', 'unit': 'L/min'},
      'output': {'label': 'Output', 'unit': 'kW'},
      'temperature': {'label': 'Temp', 'unit': '°C'},
      'pressure': {'label': 'Pressure', 'unit': 'kPa'},
      'efficiency': {'label': 'Eff', 'unit': '%'},
    };

    // Find available metrics in priority order
    for (var key in priorityKeys) {
      if (asset.status.containsKey(key)) {
        metrics.add({
          'label': metricDefinitions[key]!['label'],
          'value': asset.status[key].toString(),
          'unit': metricDefinitions[key]!['unit'],
        });

        // Break after finding two metrics
        if (metrics.length == 2) break;
      }
    }

    // If no metrics found
    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          metrics.map((metric) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Text(
                    '${metric['label']}:',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${metric['value']} ${metric['unit']}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
