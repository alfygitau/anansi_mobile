class Collateral {
  final String name;
  final String category;
  final String value;
  final List<String> images;
  final List<String> documents;
  final String status; // Added for the badge logic

  Collateral({
    required this.name,
    required this.category,
    required this.value,
    this.images = const [],
    this.documents = const [],
    this.status = "Pending",
  });
}