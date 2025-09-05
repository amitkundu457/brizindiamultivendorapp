class CoinData {
  final String totalCoins;
  final String lastRechargeDate;

  CoinData({required this.totalCoins, required this.lastRechargeDate});

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
      totalCoins: json['total_coins'] ?? '0',
      lastRechargeDate: json['last_recharge_date'] ?? '',
    );
  }
}
