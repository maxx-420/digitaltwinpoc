import 'package:digitaltwinpoc/screens/asset/asset_list_screen.dart';
import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../models/notification.dart';
import '../../utils/mock_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Asset> assets;
  late List<AppNotification> notifications;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    assets = MockData.getAssets();
    notifications = MockData.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 0
        ? _buildDashboardContent()
        : const Text("Settings");
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          assets = MockData.getAssets();
          notifications = MockData.getNotifications();
        });
      },
      child: AssetListScreen(assets: assets, notifications: notifications),
    );
  }
}
