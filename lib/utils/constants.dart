class AppConstants {
  // App Info
  static const String appName = 'Lost & Back';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String lostItemsCollection = 'lostItems';
  static const String foundItemsCollection = 'foundItems';
  static const String chatsCollection = 'chats';
  static const String notificationsCollection = 'notifications';

  // Item Categories
  static const List<String> itemCategories = [
    'Electronics',
    'Documents',
    'Bags',
    'Keys',
    'Wallets',
    'Jewelry',
    'Clothing',
    'Books',
    'Sports Equipment',
    'Others',
  ];

  // Search Radius (in kilometers)
  static const double defaultSearchRadius = 2.0;
  static const double maxSearchRadius = 10.0;

  // Image Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImagesPerItem = 3;

  // Pagination
  static const int itemsPerPage = 20;
}