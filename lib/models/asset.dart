class Asset {
  final String id;
  final String name;
  final String type;
  final String imageUrl;
  final Map<String, dynamic> status;
  final String location;

  Asset({
    required this.id,
    required this.name,
    required this.type,
    this.imageUrl = '',
    required this.status,
    this.location = '',
  });
}