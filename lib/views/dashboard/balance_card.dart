import 'package:flutter/material.dart';
import '../../models/coin_model.dart';
import '../../services/coin_service.dart';
import '../widgets/gridbox.dart';
import '../widgets/shadowbox.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  CoinData? _coinData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCoinData();
  }

  Future<void> loadCoinData() async {
    try {
      final coins = await CoinService.fetchCoins();
      setState(() {
        _coinData = coins;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading coin data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Balance Title Row
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.green, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Balance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _coinData?.totalCoins ?? '0',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// Grid Row
                Row(
                  children: [
                    Expanded(
                      child: GridBox(
                        title: 'Total Invoice',
                        value: '0',
                        color: Colors.purple,
                        bgColor: Colors.purple.shade50,
                        width: width,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GridBox(
                        title: 'This Month',
                        value: '0',
                        color: Colors.blue,
                        bgColor: Colors.blue.shade50,
                        width: width,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Last Recharge Date
                ShadowBox(
                  title: 'Last Recharge Date',
                  value: _coinData?.lastRechargeDate ?? 'N/A',
                  color: Colors.teal,
                  width: width,
                ),
              ],
            ),
    );
  }
}
