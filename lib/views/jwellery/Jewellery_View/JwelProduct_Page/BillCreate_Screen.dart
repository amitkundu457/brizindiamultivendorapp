import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/Jewellery_Provider/BillGetProvider.dart';
import '../../../../models/Jewellery_Model/BillingModel.dart';
import '../../../../models/Jewellery_Model/LocalDataModel.dart';
import '../HomePage/Home_Screen.dart';
import 'ProductView_Screen.dart';

class BillCreate_Screen extends StatefulWidget {
  final Product product;
  const BillCreate_Screen({Key? key, required this.product}) : super(key: key);

  @override
  State<BillCreate_Screen> createState() => _BillCreate_ScreenState();
}

class _BillCreate_ScreenState extends State<BillCreate_Screen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Controllers (form)
  final _grossWgtController = TextEditingController();
  final _netWgtController = TextEditingController();
  final _depositMaterialController = TextEditingController();
  final _rateController = TextEditingController();
  final _fixedController = TextEditingController();
  final _pcsController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  final _makingPercentController = TextEditingController();
  final _makingGmController = TextEditingController();
  final _makingInRsController = TextEditingController();
  final _discPercentController = TextEditingController();
  final _discRsController = TextEditingController();
  final _gstMakingController = TextEditingController();
  final _diaCaratController = TextEditingController();
  final _diaWgtController = TextEditingController();
  final _diamondValueController = TextEditingController();
  final _stoneWgtController = TextEditingController();
  final _stoneValueController = TextEditingController();
  final _huidController = TextEditingController();
  final _hallmarkController = TextEditingController();
  final _purityController = TextEditingController();
  final _hallmarkChargeController = TextEditingController();
  final _wastageChargeController = TextEditingController();
  final _otherChargeController = TextEditingController();

  // Totals
  double _goldValue = 0.0;
  double _makingCharges = 0.0;
  double _grossTotal = 0.0;
  double _discount = 0.0;
  double _totalTax = 0.0;
  double _netTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _rateController.text = widget.product.rate.toString();
    _fixedController.text = widget.product.mrp.toString();
  }

  // Helpers
  double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;

  // Pick image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? f = await _picker.pickImage(source: source);
    if (f != null) setState(() => _image = File(f.path));
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // === CALCULATION (matches your screenshot style) ===
  void updateCalculation() {
    final depositGrm = _d(_depositMaterialController);
    final rate = _d(_rateController);
    final fixed = _d(_fixedController); // <-- user entered fixed amount
    final pcs = int.tryParse(_pcsController.text.trim()) ?? 1;

    final makingPerGram = _d(_makingGmController);
    final makingPct = _d(_makingPercentController);
    final makingInRs = _d(_makingInRsController);
    final discPct = _d(_discPercentController);
    final discRs = _d(_discRsController);
    final diamondValue = _d(_diamondValueController);
    final stoneValue = _d(_stoneValueController);
    final gstOnMakingPct = _d(_gstMakingController);
    final hallmarkCharge = _d(_hallmarkChargeController);
    final wastageCharge = _d(_wastageChargeController);
    final otherCharge = _d(_otherChargeController);

    // 👉 If product has fixed amount (MRP)
    if (widget.product.mrp != null &&
        widget.product.mrp!.isNotEmpty &&
        double.tryParse(widget.product.mrp!) != null) {
      double mrpVal = double.parse(widget.product.mrp!);
      _grossTotal = mrpVal * pcs;   // ✅ total = MRP × pcs
      _goldValue = 0.0;
      _makingCharges = 0.0;
      _discount = 0.0;
      _totalTax = 0.0;
      _netTotal = _grossTotal;      // only fixed amount considered
    } else {
      // 👉 Otherwise do your normal calculation
      _goldValue = depositGrm * rate;

      if (makingInRs > 0) {
        _makingCharges = makingInRs;
      } else if (makingPerGram > 0) {
        _makingCharges = depositGrm * makingPerGram;
      } else {
        _makingCharges = (_goldValue * makingPct) / 100.0;
      }

      _discount = (_goldValue * discPct) / 100.0 + discRs;

      _grossTotal = _goldValue +
          _makingCharges +
          fixed +
          diamondValue +
          stoneValue +
          hallmarkCharge +
          wastageCharge +
          otherCharge;

      _totalTax = (_makingCharges * gstOnMakingPct) / 100.0;

      _netTotal = _grossTotal + _totalTax - _discount;
    }

    setState(() {});
  }


  // Save Bill
  void saveBillAndNavigate() {
    final bill = Bill(
      grossWgt: _d(_grossWgtController),
      netWgt: _d(_netWgtController),
      pcs: int.tryParse(_pcsController.text.trim()) ?? 1,
      rate: _d(_rateController),
      makingGm: _d(_makingGmController),
      makingPercent: _d(_makingPercentController),
      makingInRs: _d(_makingInRsController),
      discPercent: _d(_discPercentController),
      discRs: _d(_discRsController),
      diaWgt: _d(_diaWgtController),
      diamondValue: _d(_diamondValueController),
      stoneWgt: _d(_stoneWgtController),
      stoneValue: _d(_stoneValueController),
      huid: _huidController.text,
      hallmark: _hallmarkController.text,
      purity: _purityController.text,
      finalAmount: _netTotal, // ✅ store Net Total
      jewelryName: widget.product.name,
      code: 'PRODUCT123',
      grm: '1200',
    );

    Provider.of<BillProvider>(context, listen: false).addBill(bill);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => JwelHome_Screen()));
  }

  // Reusable input
  Widget buildTextField(
      String label, {
        required TextEditingController controller,
        bool isHighlighted = false,
        bool isNumber = true,
      }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        TextStyle(color: isHighlighted ? Colors.green : Colors.black),
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => updateCalculation(),
    );
  }

  /// ✅ Reusable Row widget
  Widget _row(
      String title,
      double value,
      String currency, {
        bool bold = false,
        bool red = false,
        bool highlight = false,
        bool big = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: big ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "$currency${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: big ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: red
                  ? Colors.red
                  : highlight
                  ? Colors.green
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = '₹';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => JewProductViewScreen()),
              );
            }
          },
        ),
      ),


      // ===== FORM PART =====
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              buildTextField('Gross Wgt (grm)', controller: _grossWgtController),
              buildTextField('Net Wgt (grm)', controller: _netWgtController),
              buildTextField('Deposit Material (grm)',
                  controller: _depositMaterialController),
              buildTextField('Rate', controller: _rateController),
              buildTextField('Fixed', controller: _fixedController),
              buildTextField('Pcs', controller: _pcsController),
              buildTextField('Description',
                  controller: _descriptionController, isNumber: false),
              buildTextField('Making in (%)',
                  controller: _makingPercentController),
              buildTextField('Making in (Rs) per grm',
                  controller: _makingGmController),
              buildTextField('Making in Rs', controller: _makingInRsController),
              buildTextField('Disc %', controller: _discPercentController),
              buildTextField('Disc Rs', controller: _discRsController),
              buildTextField('GST% On Making', controller: _gstMakingController),
              buildTextField('Diamond (Carats)', controller: _diaCaratController),
              buildTextField('Diamond Wgt', controller: _diaWgtController),
              buildTextField('Diamond Value',
                  controller: _diamondValueController),
              buildTextField('Stone Wgt', controller: _stoneWgtController),
              buildTextField('Stone Value', controller: _stoneValueController),
              buildTextField('HUID',
                  controller: _huidController,
                  isHighlighted: true,
                  isNumber: false),
              buildTextField('Hallmark',
                  controller: _hallmarkController, isNumber: false),
              buildTextField('Purity',
                  controller: _purityController, isNumber: false),
              buildTextField('Hallmark charge',
                  controller: _hallmarkChargeController),
              buildTextField('Wastage charge',
                  controller: _wastageChargeController),
              buildTextField('Other Charge',
                  controller: _otherChargeController),
            ],
          ),
          const SizedBox(height: 150), // 👈 space for bottom card
        ],
      ),

      // ===== FIXED SUMMARY BUTTON =====
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                isScrollControlled: true,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text("Bill Summary",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800)),
                        const Divider(),

                        _row("Gold Value", _goldValue, "₹"),
                        _row("Making Charges", _makingCharges, "₹"),
                        _row("Diamond Value", _d(_diamondValueController), "₹"),
                        _row("Stone Value", _d(_stoneValueController), "₹"),
                        _row("Hallmark Charge", _d(_hallmarkChargeController), "₹"),
                        _row("Wastage Charge", _d(_wastageChargeController), "₹"),
                        _row("Other Charges", _d(_otherChargeController), "₹"),

                        const Divider(),
                        _row("Gross Total", _grossTotal, "₹", bold: true),
                        _row("Total Tax", _totalTax, "₹"),
                        _row("Discount", _discount, "₹", red: true),

                        const Divider(thickness: 1.5),
                        _row("Net Total", _netTotal, "₹",
                            bold: true, highlight: true, big: true),

                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.pop(context); // close modal
                            saveBillAndNavigate();
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("Save Bill"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text("Show Bill Summary"),
          ),
        ),
      ),

    );
  }
}
