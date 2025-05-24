class StatsModel {
  final double budget;
  final int recentPurchases;
  final int activeDeals;

  StatsModel({
    required this.budget,
    required this.recentPurchases,
    required this.activeDeals,
  });

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      budget: (map['budget'] ?? 0.0).toDouble(),
      recentPurchases: map['recent_purchases'] ?? 0,
      activeDeals: map['active_deals'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'budget': budget,
      'recent_purchases': recentPurchases,
      'active_deals': activeDeals,
    };
  }
}
