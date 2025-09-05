class Bill {
  double grossWgt;
  double netWgt;
  int pcs;
  double rate;
  double makingGm;
  double makingPercent;
  double makingInRs;
  double discPercent;
  double discRs;
  double diaWgt;
  double diamondValue;
  double stoneWgt;
  double stoneValue;
  String huid;
  String hallmark;
  String purity;
  double finalAmount;
  String jewelryName; // Add this field
  String code;
  String grm;

  Bill({
    required this.grossWgt,
    required this.netWgt,
    required this.pcs,
    required this.rate,
    required this.makingGm,
    required this.makingPercent,
    required this.makingInRs,
    required this.discPercent,
    required this.discRs,
    required this.diaWgt,
    required this.diamondValue,
    required this.stoneWgt,
    required this.stoneValue,
    required this.huid,
    required this.hallmark,
    required this.purity,
    required this.finalAmount,
    required this.jewelryName, // Initialize this field
    required this.code,
    required this.grm,
  });

  @override
  String toString() {
    return 'Bill(grossWgt: $grossWgt, netWgt: $netWgt, pcs: $pcs, rate: $rate, '
        'makingGm: $makingGm, makingPercent: $makingPercent, makingInRs: $makingInRs, '
        'discPercent: $discPercent, discRs: $discRs, diaWgt: $diaWgt, diamondValue: $diamondValue, '
        'stoneWgt: $stoneWgt, stoneValue: $stoneValue, huid: $huid, hallmark: $hallmark, '
        'purity: $purity, finalAmount: $finalAmount, jewelryName: $jewelryName,code:$code,grm:$grm)';
  }
}
