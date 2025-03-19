import 'package:flutter/material.dart';

/// Helper functions for the Digital Twin Workflow app
class Helpers {
  /// Format a date to a readable string
  static String formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  /// Format a date and time to a readable string
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  /// Format a date relative to now (e.g., "2 days ago")
  static String getRelativeTimeString(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get icon for asset type
  static IconData getIconForAssetType(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'pump':
        return Icons.water_drop;
      case 'power generator':
        return Icons.power;
      case 'motor':
        return Icons.settings;
      default:
        return Icons.devices_other;
    }
  }


  /// Two digits helper for date formatting
  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  /// Show a simple snackbar message
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),   behavior: SnackBarBehavior.floating),  
    );
  }
}