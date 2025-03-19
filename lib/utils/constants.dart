/// App-wide constants for the Digital Twin Workflow app
class Constants {
  /// App information
  static const String appName = 'Digital Twin Workflow';
  static const String appVersion = '1.0.0';
  static const String appDescription = 
      'Streamlined management of digital twin assets and workflows';

  /// Default values
  static const int defaultAnimationDuration = 300; // milliseconds
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;
  
  /// Assets directories
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  
  /// Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  
  /// Preference keys
  static const String prefUserName = 'user_name';
  static const String prefUserId = 'user_id';
  static const String prefThemeMode = 'theme_mode';
  
  /// Navigation routes
  static const String routeHome = '/';
  static const String routeAssetDetail = '/asset';
  static const String routeWorkflowList = '/workflows';
  static const String routeWorkflowDetail = '/workflow';
  static const String routeWorkflowCreate = '/workflow/create';
  static const String routeSettings = '/settings';
  static const String routeNotifications = '/notifications';
}