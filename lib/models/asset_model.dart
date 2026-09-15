class AssetModel {
  final String id;
  final String location;
  final double latitude;
  final double longitude;
  final String status;

  const AssetModel({
    required this.id,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory AssetModel.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return AssetModel(
      id: data['id'] ?? documentId,
      location: data['location'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }
}
