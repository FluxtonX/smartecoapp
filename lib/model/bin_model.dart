enum BinWasteType {
  ORGANIC,
  RECYCLABLE,
  EWASTE,
  GENERAL,
  HAZARDOUS,
}

class BinModel {
  final String id;
  final String userId;
  final BinWasteType wasteType;
  final String qrCode;
  final double fillLevel;
  final DateTime? lastEmptiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  BinModel({
    required this.id,
    required this.userId,
    required this.wasteType,
    required this.qrCode,
    required this.fillLevel,
    this.lastEmptiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BinModel.fromJson(Map<String, dynamic> json) {
    return BinModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      wasteType: BinWasteType.values.firstWhere(
        (e) => e.name == json['wasteType'],
        orElse: () => BinWasteType.GENERAL,
      ),
      qrCode: json['qrCode'] ?? '',
      fillLevel: (json['fillLevel'] ?? 0.0).toDouble(),
      lastEmptiedAt: json['lastEmptiedAt'] != null 
          ? DateTime.parse(json['lastEmptiedAt']) 
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'wasteType': wasteType.name,
      'qrCode': qrCode,
      'fillLevel': fillLevel,
      'lastEmptiedAt': lastEmptiedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
