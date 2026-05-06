enum PickupStatus {
  PENDING,
  CONFIRMED,
  COLLECTOR_ASSIGNED,
  EN_ROUTE,
  ARRIVED,
  IN_PROGRESS,
  COMPLETED,
  CANCELLED,
}

enum WasteType {
  ORGANIC,
  RECYCLABLE,
  EWASTE,
  GENERAL,
  HAZARDOUS,
}

enum TimeSlot {
  MORNING_8_10,
  MORNING_10_12,
  AFTERNOON_12_2,
  AFTERNOON_2_4,
  AFTERNOON_4_6,
}

class PickupModel {
  final String id;
  final String reference;
  final WasteType wasteType;
  final DateTime scheduledDate;
  final TimeSlot timeSlot;
  final PickupStatus status;
  final String address;
  final double? latitude;
  final double? longitude;
  final int? estimatedPoints;
  final String? cancellationReason;
  final CollectorModel? collector;
  Map<String, dynamic>? eta;
  final Map<String, dynamic>? payment;
  final DateTime createdAt;

  PickupModel({
    required this.id,
    required this.reference,
    required this.wasteType,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    required this.address,
    this.latitude,
    this.longitude,
    this.estimatedPoints,
    this.cancellationReason,
    this.collector,
    this.eta,
    this.payment,
    required this.createdAt,
  });

  factory PickupModel.fromJson(Map<String, dynamic> json) {
    return PickupModel(
      id: json['id'] ?? '',
      reference: json['reference'] ?? '',
      wasteType: WasteType.values.firstWhere(
        (e) => e.name == json['wasteType'],
        orElse: () => WasteType.GENERAL,
      ),
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? DateTime.now().toIso8601String()),
      timeSlot: TimeSlot.values.firstWhere(
        (e) => e.name == json['timeSlot'],
        orElse: () => TimeSlot.MORNING_8_10,
      ),
      status: PickupStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PickupStatus.PENDING,
      ),
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      estimatedPoints: json['estimatedPoints'],
      cancellationReason: json['cancellationReason'],
      collector: json['collector'] != null ? CollectorModel.fromJson(json['collector']) : null,
      eta: json['eta'],
      payment: json['payment'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class CollectorModel {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final String vehiclePlate;
  final double rating;
  double? latitude;
  double? longitude;

  CollectorModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.vehiclePlate,
    required this.rating,
    this.latitude,
    this.longitude,
  });

  factory CollectorModel.fromJson(Map<String, dynamic> json) {
    return CollectorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'],
      vehiclePlate: json['vehiclePlate'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}
