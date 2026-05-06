class CollectorProfileModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final String vehiclePlate;
  final String zone;
  final String? photoUrl;
  final double rating;
  final int totalPickups;
  final bool isAvailable;
  final bool isApproved;
  final DateTime? approvedAt;
  final int todayPickups;
  final int todayCompleted;
  final double totalWeightKg;
  final DateTime createdAt;

  CollectorProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    required this.vehiclePlate,
    required this.zone,
    this.photoUrl,
    required this.rating,
    required this.totalPickups,
    required this.isAvailable,
    required this.isApproved,
    this.approvedAt,
    required this.todayPickups,
    required this.todayCompleted,
    required this.totalWeightKg,
    required this.createdAt,
  });

  factory CollectorProfileModel.fromJson(Map<String, dynamic> json) {
    return CollectorProfileModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      vehiclePlate: json['vehiclePlate'] ?? '',
      zone: json['zone'] ?? '',
      photoUrl: json['photoUrl'],
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalPickups: json['totalPickups'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      isApproved: json['isApproved'] ?? false,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      todayPickups: json['todayPickups'] ?? 0,
      todayCompleted: json['todayCompleted'] ?? 0,
      totalWeightKg: (json['totalWeightKg'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class CollectorStatsModel {
  final StatPeriod today;
  final StatPeriod thisWeek;
  final StatPeriod thisMonth;
  final StatPeriod allTime;
  final List<WasteTypeStat> byWasteType;
  final double rating;

  CollectorStatsModel({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.allTime,
    required this.byWasteType,
    required this.rating,
  });

  factory CollectorStatsModel.fromJson(Map<String, dynamic> json) {
    return CollectorStatsModel(
      today: StatPeriod.fromJson(json['today'] ?? {}),
      thisWeek: StatPeriod.fromJson(json['thisWeek'] ?? {}),
      thisMonth: StatPeriod.fromJson(json['thisMonth'] ?? {}),
      allTime: StatPeriod.fromJson(json['allTime'] ?? {}),
      byWasteType: (json['byWasteType'] as List? ?? [])
          .map((e) => WasteTypeStat.fromJson(e))
          .toList(),
      rating: (json['rating'] ?? 5.0).toDouble(),
    );
  }
}

class StatPeriod {
  final int completed;
  final double weightKg;
  final int? pending;

  StatPeriod({
    required this.completed,
    required this.weightKg,
    this.pending,
  });

  factory StatPeriod.fromJson(Map<String, dynamic> json) {
    return StatPeriod(
      completed: json['completed'] ?? 0,
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      pending: json['pending'],
    );
  }
}

class WasteTypeStat {
  final String wasteType;
  final int count;
  final double weightKg;

  WasteTypeStat({
    required this.wasteType,
    required this.count,
    required this.weightKg,
  });

  factory WasteTypeStat.fromJson(Map<String, dynamic> json) {
    return WasteTypeStat(
      wasteType: json['wasteType'] ?? '',
      count: json['count'] ?? 0,
      weightKg: (json['weightKg'] ?? 0).toDouble(),
    );
  }
}

/// Pickup model used in the collector's pickup list/detail views
class CollectorPickupModel {
  final String id;
  final String reference;
  final String wasteType;
  final String timeSlot;
  final String status;
  final String address;
  final double latitude;
  final double longitude;
  final String? notes;
  final double? weightKg;
  final DateTime? scheduledDate;
  final DateTime? completedAt;
  final CustomerInfo user;
  final Map<String, dynamic>? bin;
  final Map<String, dynamic>? payment;

  CollectorPickupModel({
    required this.id,
    required this.reference,
    required this.wasteType,
    required this.timeSlot,
    required this.status,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.weightKg,
    this.scheduledDate,
    this.completedAt,
    required this.user,
    this.bin,
    this.payment,
  });

  factory CollectorPickupModel.fromJson(Map<String, dynamic> json) {
    return CollectorPickupModel(
      id: json['id'] ?? '',
      reference: json['reference'] ?? '',
      wasteType: json['wasteType'] ?? 'GENERAL',
      timeSlot: json['timeSlot'] ?? '',
      status: json['status'] ?? 'PENDING',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      notes: json['notes'],
      weightKg: json['weightKg']?.toDouble(),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      user: CustomerInfo.fromJson(json['user'] ?? {}),
      bin: json['bin'],
      payment: json['payment'],
    );
  }

  /// Human-readable time slot label
  String get timeSlotLabel {
    switch (timeSlot) {
      case 'MORNING_8_10':
        return '08:00 – 10:00';
      case 'MORNING_10_12':
        return '10:00 – 12:00';
      case 'AFTERNOON_12_2':
        return '12:00 – 14:00';
      case 'AFTERNOON_2_4':
        return '14:00 – 16:00';
      case 'AFTERNOON_4_6':
      case 'EVENING_4_6':
        return '16:00 – 18:00';
      default:
        return timeSlot;
    }
  }

  /// Human-readable waste type label
  String get wasteTypeLabel {
    switch (wasteType) {
      case 'ORGANIC':
        return 'Organic';
      case 'RECYCLABLE':
        return 'Recyclable';
      case 'EWASTE':
        return 'E-Waste';
      case 'GENERAL':
        return 'General';
      case 'GLASS':
        return 'Glass';
      case 'HAZARDOUS':
        return 'Hazardous';
      default:
        return wasteType;
    }
  }
}

class CustomerInfo {
  final String name;
  final String phone;
  final String? avatarUrl;

  CustomerInfo({
    required this.name,
    required this.phone,
    this.avatarUrl,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      name: json['name'] ?? 'Unknown',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }
}
