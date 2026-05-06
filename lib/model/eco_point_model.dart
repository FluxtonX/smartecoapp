class EcoPointsBalance {
  final int totalPoints;
  final String tier;
  final double multiplier;
  final String? nextTier;
  final int pointsToNextTier;
  final double progressPercent;
  final int totalPickups;
  final double totalWeightKg;

  EcoPointsBalance({
    required this.totalPoints,
    required this.tier,
    required this.multiplier,
    this.nextTier,
    required this.pointsToNextTier,
    required this.progressPercent,
    required this.totalPickups,
    required this.totalWeightKg,
  });

  factory EcoPointsBalance.fromJson(Map<String, dynamic> json) {
    return EcoPointsBalance(
      totalPoints: json['totalPoints'] ?? 0,
      tier: json['tier'] ?? 'ECO_STARTER',
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      nextTier: json['nextTier'],
      pointsToNextTier: json['pointsToNextTier'] ?? 0,
      progressPercent: (json['progressPercent'] ?? 0.0).toDouble(),
      totalPickups: json['totalPickups'] ?? 0,
      totalWeightKg: (json['totalWeightKg'] ?? 0.0).toDouble(),
    );
  }
}

class EcoPointTransaction {
  final String id;
  final int points;
  final String action;
  final String? description;
  final DateTime createdAt;

  EcoPointTransaction({
    required this.id,
    required this.points,
    required this.action,
    this.description,
    required this.createdAt,
  });

  factory EcoPointTransaction.fromJson(Map<String, dynamic> json) {
    return EcoPointTransaction(
      id: json['id'] ?? '',
      points: json['points'] ?? 0,
      action: json['action'] ?? '',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
