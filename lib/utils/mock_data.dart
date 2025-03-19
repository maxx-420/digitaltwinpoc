import '../models/asset.dart';
import '../models/notification.dart';

/// Static class providing mock data for the application
class MockData {
  /// Get list of mock assets
  static List<Asset> getAssets() {
    return [
      Asset(
        id: 'asset-001',
        name: 'Motor A37',
        type: 'Motor',
        imageUrl: 'assets/images/turbine.png',
        status: {
          'power': 2.7,
          'temperature': 42.3,
          'rotationSpeed': 16.5,
          'health': 'Good',
        },
        location: 'North Field',
      ),
      Asset(
        id: 'asset-002',
        name: 'Motor B12',
        type: 'Motor',
        imageUrl: 'assets/images/pump.png',
        status: {
          'power': 2.7,
          'temperature': 42.3,
          'rotationSpeed': 16.5,
          'health': 'Warning',
        },
        location: 'East Plant',
      ),
      Asset(
        id: 'asset-003',
        name: 'Generator C45',
        type: 'Power Generator',
        imageUrl: 'assets/images/generator.png',
        status: {
          'output': 1250,
          'fuelLevel': 68.3,
          'temperature': 85.7,
          'health': 'Critical',
        },
        location: 'South Station',
      ),
      Asset(
        id: 'asset-004',
        name: 'Pump D22',
        type: 'Pump',
        imageUrl: 'assets/images/hvac.png',
        status: {'flowRate': 10, 'filterStatus': 87.2, 'health': 'Good'},
        location: 'Main Building',
      ),
      Asset(
        id: 'asset-005',
        name: 'Pump E08',
        type: 'Pump',
        imageUrl: 'assets/images/solar.png',
        status: {'flowRate': 10, 'efficiency': 92.1, 'health': 'Good'},
        location: 'West Field',
      ),
    ];
  }

  /// Get list of mock notifications
  static List<AppNotification> getNotifications() {
    return [
      AppNotification(
        id: 'notif-003',
        title: 'Critical Alert',
        message: 'Motor B12 temperature exceeding threshold',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.assetAlert,
        relatedItemId: 'asset-002',
      ),
      AppNotification(
        id: 'notif-001',
        title: 'Maintenance Due',
        message: 'Motor A37 maintenance overdue',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.systemMessage,
        relatedItemId: 'asset-001',
      ),
      AppNotification(
        id: 'notif-002',
        title: 'Critical Alert',
        message: 'Generator C45 temperature exceeding threshold',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: NotificationType.assetAlert,
        relatedItemId: 'asset-003',
      ),
      AppNotification(
        id: 'notif-004',
        title: 'Maintenance Due',
        message: 'Pump D22 maintenance scheduled for tomorrow',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        type: NotificationType.systemMessage,
        relatedItemId: 'asset-004',
      ),
    ];
  }
}
