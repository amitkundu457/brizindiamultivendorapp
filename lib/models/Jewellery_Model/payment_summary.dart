class PaymentSummary {
  final int cash;
  final int card;
  final int upi;
  final int advance;
  final int others;

  PaymentSummary({
    required this.cash,
    required this.card,
    required this.upi,
    required this.advance,
    required this.others,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      cash: json['cash'] ?? 0,
      card: json['card'] ?? 0,
      upi: json['upi'] ?? 0,
      advance: json['advance'] ?? 0,
      others: json['others'] ?? 0,
    );
  }
}
