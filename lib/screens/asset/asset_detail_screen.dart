import 'package:digitaltwinpoc/models/notification.dart';
import 'package:digitaltwinpoc/utils/helpers.dart';
import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../utils/theme.dart';

class AssetDetailScreen extends StatefulWidget {
  final Asset asset;
  final List<AppNotification> notifications;

  const AssetDetailScreen({
    super.key,
    required this.asset,
    required this.notifications,
  });

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.asset.name)),
      body: Column(
        children: [
          _buildVisualizationCard(),
          _buildAssetAlertBar(),
          _buildAssetHeader(),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [Tab(text: 'Overview'), Tab(text: 'Documents')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildOverviewTab(), _buildDocumentsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetAlertBar() {
    return Container(
      child: Column(
        children: [
          ...widget.notifications.map(
            (notification) => _buildNotification(notification),
          ),
        ],
      ),
    );
  }

  Widget _buildNotification(AppNotification notification) {
    return ListTile(
      leading: Icon(
        notification.type == NotificationType.systemMessage
            ? Icons.info_outline
            : Icons.error_outline,
        color: notification.type == NotificationType.systemMessage
            ? AppColors.warning
            : AppColors.error,
      ),
      title: Text(notification.message),
      tileColor: notification.type == NotificationType.systemMessage
          ? AppColors.warning.withValues(alpha: 0.1)
          : AppColors.error.withValues(alpha: .1),
    );
  }

  Widget _buildAssetHeader() {
    final status = widget.asset.status['health'] as String;
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssetImage(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.asset.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.asset.type,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      widget.asset.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
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

  Widget _buildAssetImage() {
    return Hero(
      tag: 'asset-${widget.asset.id}',
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Center(
              child: Icon(
                Helpers.getIconForAssetType(widget.asset.type),
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Real-time Metrics'),
          const SizedBox(height: 8),
          _buildMetricsGrid(),
          const SizedBox(height: 24),
          _buildSectionTitle('Asset Visualization'),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Activity'),
          const SizedBox(height: 8),
          _buildActivityTimeline(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final dummyDocs = [
      {
        'name': 'User Manual',
        'type': 'PDF',
        'size': '3.5 MB',
        'date': '2025-01-15',
      },
      {
        'name': 'Technical Specifications',
        'type': 'PDF',
        'size': '2.1 MB',
        'date': '2024-12-10',
      },
      {
        'name': 'Maintenance Log',
        'type': 'XLSX',
        'size': '1.8 MB',
        'date': '2025-03-10',
      },
      {
        'name': 'Installation Guide',
        'type': 'PDF',
        'size': '5.7 MB',
        'date': '2024-08-22',
      },
      {
        'name': 'Wiring Diagram',
        'type': 'DWG',
        'size': '4.2 MB',
        'date': '2024-11-05',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [...dummyDocs.map((doc) => _buildDocumentItem(doc))],
    );
  }

  Widget _buildDocumentItem(Map<String, String> doc) {
    IconData iconData;
    Color iconColor;

    switch (doc['type']) {
      case 'PDF':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'XLSX':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'DWG':
        iconData = Icons.architecture;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(doc['name']!),
        subtitle: Text('${doc['size']} • Last updated: ${doc['date']}'),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            Helpers.showSnackbar(context, 'Downloading ${doc['name']}');
          },
        ),
        onTap: () {
          Helpers.showSnackbar(context, 'Opening ${doc['name']}');
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children:
          widget.asset.status.entries
              .where((entry) => entry.key != 'health')
              .map((entry) => _buildMetricCard(entry.key, entry.value))
              .toList(),
    );
  }

  Widget _buildMetricCard(String key, dynamic value) {
    String displayKey = key.replaceFirst(key[0], key[0].toUpperCase());
    String unit = '';

    // Define units based on the key
    switch (key) {
      case 'temperature':
        unit = '°C';
        break;
      case 'pressure':
        unit = 'bar';
        break;
      case 'power':
        unit = 'MW';
        break;
      case 'rotationSpeed':
        unit = 'rpm';
        break;
      case 'output':
        unit = 'kW';
        break;
      case 'flowRate':
        unit = 'L/min';
        break;
      case 'fuelLevel':
        unit = '%';
        break;
    }

    // Format the display key for better readability
    if (displayKey == 'RotationSpeed') {
      displayKey = 'Rotation Speed';
    } else if (displayKey == 'FlowRate') {
      displayKey = 'Flow Rate';
    } else if (displayKey == 'FuelLevel') {
      displayKey = 'Fuel Level';
    }

    IconData iconData;
    switch (key) {
      case 'temperature':
        iconData = Icons.thermostat;
        break;
      case 'pressure':
        iconData = Icons.speed;
        break;
      case 'power':
        iconData = Icons.power;
        break;
      case 'rotationSpeed':
        iconData = Icons.autorenew;
        break;
      case 'flowRate':
        iconData = Icons.water;
        break;
      case 'fuelLevel':
        iconData = Icons.local_gas_station;
        break;
      case 'output':
        iconData = Icons.bolt;
        break;
      default:
        iconData = Icons.assessment;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  displayKey,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationCard() {
    return Card(
      child: InkWell(
        
        onTap: () {},
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: Icon(
                    Icons.view_in_ar_outlined,
                    size: 80,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
           ],
        ),
      ),
    );
  }

  Widget _buildActivityTimeline() {
    final activities = [
      {
        'title': 'Lubrication Completed',
        'description': 'Scheduled maintenance performed',
        'time': '2 hours ago',
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
      {
        'title': 'Temperature Alert',
        'description': 'Temperature exceeded normal range',
        'time': 'Yesterday',
        'icon': Icons.warning_amber,
        'color': AppColors.warning,
      },
      {
        'title': 'Inspection Performed',
        'description': 'Quarterly inspection completed',
        'time': '3 days ago',
        'icon': Icons.search,
        'color': AppColors.primary,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children:
              activities
                  .map((activity) => _buildActivityItem(activity))
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(activity['icon'], color: activity['color'], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'],
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
