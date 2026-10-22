

class Place {
  final int id;
  final String name;
  final String category;
  final String subtitle;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  /// False when a trustworthy point coordinate has not yet been confirmed.
  final bool coordinatesVerified;
  final String? workingHours;
  final String? phone;
  final String? website;
  final String? status;
  final String emoji;
  final String? imageUrl;
  final List<String> tags;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.emoji,
    this.coordinatesVerified = true,
    this.workingHours,
    this.phone,
    this.website,
    this.status,
    this.imageUrl,
    this.tags = const [],
  });
}

class CityRoute {
  final String number;
  final String kind;
  final String origin;
  final String destination;
  final String note;
  final String timetableUrl;
  final String mapUrl;
  /// False for routes where an individual, reliable interactive line page is not available.
  final bool hasInteractiveMap;

  const CityRoute({
    required this.number,
    required this.kind,
    required this.origin,
    required this.destination,
    required this.note,
    required this.timetableUrl,
    required this.mapUrl,
    this.hasInteractiveMap = true,
  });
}
