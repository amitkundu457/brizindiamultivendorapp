// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Controller/Jewellery_Provider/BillingPrintProvider.dart';
//
// class BillingPrint_Screen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final billingProvider = Provider.of<BillingPrintProvider>(context);
//     // Fetch data when the widget builds
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       billingProvider.fetchData();
//     });
//
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Jewellery Billing",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
//         backgroundColor: Colors.green,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(17.0),
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(right: 40),
//                     width: size.width * 0.4, // Increased width to 50% of screen width
//                     height: size.height * 0.2, // Increased height to 20% of screen height
//                     child: Image.network(
//                       "https://api.equi.co.in/storage/logos/677d52fbdd098.png",
//                       fit: BoxFit.cover, // Adjust how the image fills the container
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:  [
//                       Text(
//                         billingProvider.firstName,
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.redAccent),
//                       ),
//                       Text(
//                           billingProvider.roleName,
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.redAccent),
//                       ),
//                       SizedBox(height: 4),
//                       Text("Address: KOLKATA", style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 100.0,),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: const [
//                         Text("GSTIN:", style: TextStyle(fontSize: 12)),
//                         Text("Mobile:", style: TextStyle(fontSize: 12)),
//                         Text("Email:", style: TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Invoice Details Section
//               Container(
//                 width: size.width,
//                // color: Colors.orange,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const [
//                         Text("Invoice No: ", style: TextStyle(fontSize: 14)),
//                         Text("Invoice Date: ", style: TextStyle(fontSize: 14)),
//                         Text("BIS No: ", style: TextStyle(fontSize: 14)),
//                         Text("Gold Rate: ", style: TextStyle(fontSize: 14)),
//                       ],
//                      ),
//                       Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const [
//                         Text("BN173723", style: TextStyle(fontSize: 14)),
//                         Text("2025-01-20", style: TextStyle(fontSize: 14)),
//                         Text("HM/C-51234", style: TextStyle(fontSize: 14)),
//                         Text("₹80.00", style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//
//               // Bill No.
//               // Container(
//               //   child: Row(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       Center(child: Text("BILL TO!")),
//               //       Column(
//               //         crossAxisAlignment: CrossAxisAlignment.start,
//               //         children: const [
//               //           Text("Name:  "),
//               //           Text("Address: "),
//               //           Text("Phone:"),
//               //           Text("GSTIN:"),
//               //         ],
//               //       ),
//               //       Column(
//               //         crossAxisAlignment: CrossAxisAlignment.start,
//               //         children: const [
//               //           Text("surojit sinha"),
//               //           Text("ecee"),
//               //           Text("123456789"),
//               //           Text("N/A"),
//               //         ],
//               //       ),
//               //       //Ship To
//               //       Column(
//               //         crossAxisAlignment: CrossAxisAlignment.start,
//               //         children: const [
//               //           Center(child: Text("SHIP TO:", style: TextStyle(fontWeight: FontWeight.bold))),
//               //           Row(
//               //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //             children: [
//               //               Column(
//               //                 crossAxisAlignment: CrossAxisAlignment.start,
//               //                 children: [
//               //                   Text("Address: "),
//               //                   Text("Pincode: "),
//               //                   Text("State:   "),
//               //                   Text("Country: "),
//               //                 ],
//               //               ),
//               //               Column(
//               //                 crossAxisAlignment: CrossAxisAlignment.start,
//               //                 children: [
//               //                   Text("ecee"),
//               //                   Text("700098"),
//               //                   Text("west bengal"),
//               //                   Text("India"),
//               //                 ],
//               //               ),
//               //             ],
//               //           )
//               //
//               //         ],
//               //       ),
//               //     ],
//               //   ),
//               // ),
//                       // Billing and Shipping Section
//                       Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: const [
//                                   Text("BILL TO:", style: TextStyle(fontWeight: FontWeight.bold)),
//                                   Text("Name: surojit sinha"),
//                                   Text("Address: ecee"),
//                                   Text("Phone: 123456789"),
//                                   Text("GSTIN: N/A"),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 40.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                   children: const [
//                                     Text("SHIP TO:", style: TextStyle(fontWeight: FontWeight.bold)),
//                                     Text("Address: ecee"),
//                                     Text("Pincode: 700098"),
//                                     Text("State: west bengal"),
//                                     Text("Country: India"),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//
//               const Divider(),
//
//               // Table Header
//               Container(
//                // color: Colors.redAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text("SL No. :", style: TextStyle(color: Colors.black,)),
//                         Text("Description :", style: TextStyle(color: Colors.black,)),
//                         Text("HSN :", style: TextStyle(color: Colors.black,)),
//                         Text("Net Wt. (Gm) :", style: TextStyle(color: Colors.black,)),
//                         Text("Gross Wt. (Gm) :", style: TextStyle(color: Colors.black,)),
//                         Text("Metal Value (2) :", style: TextStyle(color: Colors.black,)),
//                         Text("Making Chg (2) :", style: TextStyle(color: Colors.black,)),
//                         Text("Other Chg :", style: TextStyle(color: Colors.black,)),
//                         Text("Taxable Amount (₹) :", style: TextStyle(color: Colors.black,)),
//                       ],
//                     ),
//                     const Divider(height: 0),
//
//                     // Table Row
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text("1"),
//                         Text("Gold Chain"),
//                         Text("Null"),
//                         Text("10.00"),
//                         Text("12.00"),
//                         Text("80000.00"),
//                         Text("2000.00"),
//                         Text("00.00"),
//                         Text("82000.00"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Gross Total:", style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text("CGST:", style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text("SGST:", style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text("Total Amount (in words): ",style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("₹82000.00"),
//                       Text("₹25.00"),
//                       Text("₹25.00"),
//                       Text("₹82050.00"),
//                       Text("Eighty-Two\n Thousand \nFifty Only"),
//
//                     ],
//                   ),
//                 ],
//               ),
//               const Divider(),
//               //Payment Daitals
//               Container(
//                // color: Colors.green,
//                 padding: EdgeInsets.only(left: 4,right: 4),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Center(child: Text("Payment Details!", style: TextStyle(fontWeight: FontWeight.bold))),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("PAID BY CASH ="),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(" ₹82050.00"),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(),
//               SizedBox(height: 7,),
//               Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Center(child: Text("Terms and Conditions!", style: TextStyle(fontWeight: FontWeight.bold))),
//                     Text("1. The price is inclusive of all other charges."),
//                     Text("2. Any jewelry items are breakable; please handle with care."),
//                     Text("3. GST is applicable."),
//                   ],
//                 ),
//               ),
//               Divider(),
//               const SizedBox(height: 20),
//
//               // Signature Section
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: const [
//                     Text("Authorised Signature"),
//                     Text("FOR RETAILJI JEWELLERY"),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/Jewellery_Provider/BillingPrintProvider.dart';
// import '../../../controllers/Jewellery_Provider/BillingPrintProvider.dart';

class BillingPrint_Screen extends StatelessWidget {
  const BillingPrint_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billingProvider = Provider.of<BillingPrintProvider>(context);

    // Fetch data when the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      billingProvider.fetchBillData();
    });

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jewellery Billing",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,

        actions: [
          // Printer icon in the app bar
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Thermal Print') {
                _printThermal(context, billingProvider); // Thermal print function
              } else if (value == 'A4 Print') {
                _printA4(context, billingProvider); // A4 print function
              }
            },
            icon: Icon(Icons.print), // Printer icon
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Thermal Print',
                child: Text('Thermal Print'),
              ),
              PopupMenuItem(
                value: 'A4 Print',
                child: Text('A4 Print'),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  child: Image.network(
                    "https://api.equi.co.in/storage/logos/677d52fbdd098.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      billingProvider.firstName.isNotEmpty
                          ? billingProvider.firstName
                          : "N/A",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                    Text(
                      billingProvider.roleName.isNotEmpty
                          ? billingProvider.roleName
                          : "N/A",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                    const SizedBox(height: 4),
                    const Text("Address: KOLKATA", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("GSTIN:", style: TextStyle(fontSize: 12)),
                      Text("Mobile:", style: TextStyle(fontSize: 12)),
                      Text("Email:", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            // Invoice Details Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Invoice No:"),
                    Text("Invoice Date:"),
                    Text("BIS No:"),
                    Text("Gold Rate:"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      billingProvider.billNo.isNotEmpty
                          ? billingProvider.billNo
                          : "N/A",
                    ),
                    Text(
                      billingProvider.invoiceDate.isNotEmpty
                          ? billingProvider.invoiceDate
                          : "N/A",
                    ),
                    const Text("HM/C-51234"),
                    const Text("₹80.00"),
                  ],
                ),
              ],
            ),
            const Divider(),

            // Billing and Shipping Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("BILL TO:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        billingProvider.customerName.isNotEmpty
                            ? billingProvider.customerName
                            : "N/A",
                      ),
                      Text(
                        billingProvider.customerAddress.isNotEmpty
                            ? billingProvider.customerAddress
                            : "N/A",
                      ),
                      Text(
                        billingProvider.customerPhone.isNotEmpty
                            ? billingProvider.customerPhone
                            : "N/A",
                      ),
                      const Text("GSTIN: N/A"),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SHIP TO:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          billingProvider.customerAddress.isNotEmpty
                              ? billingProvider.customerAddress
                              : "N/A",
                        ),
                        Text(
                          billingProvider.customerPincode.isNotEmpty
                              ? billingProvider.customerPincode
                              : "N/A",
                        ),
                        Text(
                          billingProvider.customerState.isNotEmpty
                              ? billingProvider.customerState
                              : "N/A",
                        ),
                        Text(
                          billingProvider.customerCountry.isNotEmpty
                              ? billingProvider.customerCountry
                              : "N/A",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("SL No.:", style: TextStyle(color: Colors.black)),
                      Text("Description:", style: TextStyle(color: Colors.black)),
                      Text("Net Wt. (Gm):", style: TextStyle(color: Colors.black)),
                      Text("Gross Wt. (Gm):", style: TextStyle(color: Colors.black)),
                      Text("Metal Value (₹):", style: TextStyle(color: Colors.black)),
                      Text("Making Chg (₹):", style: TextStyle(color: Colors.black)),
                      Text("Taxable Amount (₹):", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: billingProvider.productDetails.isNotEmpty
                        ? billingProvider.productDetails.map((product) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1"),
                          Text(product["productName"] ?? "N/A"),
                          Text(product["netWeight"] ?? "N/A"),
                          Text(product["grossWeight"] ?? "N/A"),
                          const Text("N/A"),
                          Text(product["making"] ?? "N/A"),
                          const Text("N/A"),
                        ],
                      );
                    }).toList()
                        : [
                      for (int i = 0; i < 7; i++)
                        const Text(
                          "N/A",
                        )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            // Total Amount Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Gross Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("CGST:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("SGST:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Total (with Tax):", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      billingProvider.grossTotal.isNotEmpty
                          ? "₹${billingProvider.grossTotal}"
                          : "N/A",
                    ),
                    Text(
                      billingProvider.cgst.isNotEmpty
                          ? "${billingProvider.cgst}%"
                          : "N/A",
                    ),
                    Text(
                      billingProvider.sgst.isNotEmpty
                          ? "${billingProvider.sgst}%"
                          : "N/A",
                    ),
                    Text(
                      billingProvider.totalWithTax.isNotEmpty
                          ? "₹${billingProvider.totalWithTax}"
                          : "N/A",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),

            // Footer Section
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("Authorised Signature"),
                  Text("FOR RETAILJI JEWELLERY"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
// Function to print a thermal bill
  void _printThermal(BuildContext context, BillingPrintProvider billingProvider) async {
    final image = await networkImage('https://api.equi.co.in/storage/logos/677d52fbdd098.png');
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Jewellery Bill", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(image, width: 120, height: 80),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(billingProvider.firstName.isNotEmpty ? billingProvider.firstName : "N/A",
                          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                      pw.Text(billingProvider.roleName.isNotEmpty ? billingProvider.roleName : "N/A",
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                      pw.Text("Address: Kolkata", style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              // Invoice Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Invoice No: ${billingProvider.billNo.isNotEmpty ? billingProvider.billNo : 'N/A'}"),
                      pw.Text("Invoice Date: ${billingProvider.invoiceDate.isNotEmpty ? billingProvider.invoiceDate : 'N/A'}"),
                      pw.Text("BIS No: HM/C-51234"),
                      pw.Text("Gold Rate: ₹80.00"),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              // Customer Details
              pw.Row(
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Customer Name: ${billingProvider.customerName}"),
                      pw.Text("Address: ${billingProvider.customerAddress}"),
                      pw.Text("Phone: ${billingProvider.customerPhone}"),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              // Product Table
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['SL No.', 'Description', 'Net Wt (g)', 'Gross Wt (g)', 'Metal Value(₹)', 'Making Charge (₹)', 'Taxable Amount(₹)'],
                  ...billingProvider.productDetails.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    var product = entry.value;
                    return [
                      index.toString(),
                      product["productName"] ?? "N/A",
                      product["netWeight"] ?? "N/A",
                      product["grossWeight"] ?? "N/A",
                      "N/A",
                      product["making"] ?? "N/A",
                      "N/A",
                    ];
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 8),

              // Tax & Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Gross Total:"),
                  pw.Text("₹${billingProvider.grossTotal}"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("CGST (${billingProvider.cgst}%):"),
                  pw.Text("₹${_calculateTax(billingProvider.grossTotal, billingProvider.cgst)}"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("SGST (${billingProvider.sgst}%):"),
                  pw.Text("₹${_calculateTax(billingProvider.grossTotal, billingProvider.sgst)}"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total (with Tax):"),
                  pw.Text("₹${billingProvider.totalWithTax}"),
                ],
              ),

              pw.SizedBox(height: 12),

              // Signature
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Authorised Signature", style: pw.TextStyle(color: PdfColors.deepPurple)),
                    pw.Text("FOR RETAILJI JEWELLERY", style: pw.TextStyle(color: PdfColors.green)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  // Function to print an A4 bill
  void _printA4(BuildContext context, BillingPrintProvider billingProvider) async {
    final image = await networkImage('https://api.equi.co.in/storage/logos/677d52fbdd098.png');
    final pdf = pw.Document();

    // Add PDF generation logic for A4 printing here
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Jewellery Bill", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // Bill and Customer Details
              // pw.Text("${billingProvider.firstName}"),
              // pw.Text("Bill No: ${billingProvider.roleName}"),
              // pw.Text("Address: Bihar"),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Center(child: pw.Image(image, width: 200, height: 140)),
                  pw.Divider(thickness: 2),
                  // pw.Container(
                  //   width: 200,
                  //   height: 100,
                  //   child: pw.Image.network(
                  //     "https://api.equi.co.in/storage/logos/677d52fbdd098.png",
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        billingProvider.firstName.isNotEmpty
                            ? billingProvider.firstName
                            : "N/A",
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.redAccent,
                        ),
                      ),
                      pw.Text(
                        billingProvider.roleName.isNotEmpty
                            ? billingProvider.roleName
                            : "N/A",
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.redAccent,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text("Address: KOLKATA", style: pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 100.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("GSTIN:", style: pw.TextStyle(fontSize: 12)),
                        pw.Text("Mobile:", style: pw.TextStyle(fontSize: 12)),
                        pw.Text("Email:", style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Invoice No:"),
                      pw.Text("Invoice Date:"),
                      pw.Text("BIS No:"),
                      pw.Text("Gold Rate:"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        billingProvider.billNo.isNotEmpty
                            ? billingProvider.billNo
                            : "N/A",
                      ),
                      pw.Text(
                        billingProvider.invoiceDate.isNotEmpty
                            ? billingProvider.invoiceDate
                            : "N/A",
                      ),
                      pw.Text("HM/C-51234"),
                      pw.Text("₹80.00"),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [

                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Bill No: "),
                        pw.Text("Date: "),
                        pw.Text("Customer Name: "),
                        pw.Text("Customer Address: "),
                        pw.Text("Customer Phone: "),
                      ]
                  ),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("${billingProvider.billNo}"),
                        pw.Text("${billingProvider.invoiceDate}"),
                        pw.Text("${billingProvider.customerName}"),
                        pw.Text("${billingProvider.customerAddress}"),
                        pw.Text("${billingProvider.customerPhone}"),
                      ]
                  )
                ],
              ),
              pw.SizedBox(height: 10),

              // Table with Product Details
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['SL No.', 'Description', 'Net Wt (g)', 'Gross Wt (g)','Metal Value(₹)', 'Making Charge (₹)','Taxable Amount(₹)'],
                  ...billingProvider.productDetails.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    var product = entry.value;
                    return [
                      index.toString(),
                      product["productName"] ?? "N/A",
                      product["netWeight"] ?? "N/A",
                      product["grossWeight"] ?? "N/A",
                      const Text("N/A"),
                      product["making"] ?? "N/A",
                      const Text("N/A"),
                    ];
                  }).toList(),
                ],
              ),

              pw.Spacer(),

              // Total and Tax Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Gross Total:"),
                  pw.Text("₹${billingProvider.grossTotal}"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("CGST (${billingProvider.cgst}%):"),
                  pw.Text("₹${_calculateTax(billingProvider.grossTotal, billingProvider.cgst)}"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("SGST (${billingProvider.sgst}%):"),
                  pw.Text("₹${_calculateTax(billingProvider.grossTotal, billingProvider.sgst)}"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total (with Tax):"),
                  pw.Text("₹${billingProvider.totalWithTax}"),
                ],
              ),
              pw.Padding(
                padding: pw.EdgeInsets.only(top: 12,left: 27), // Specify padding using pw.EdgeInsets
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Authorised Signature",
                      style: pw.TextStyle(color: PdfColors.deepPurple), // Use PdfColors here
                    ),
                    pw.Text(
                      "FOR RETAILJI JEWELLERY",
                      style: pw.TextStyle(color: PdfColors.green), // Use PdfColors here
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  double _calculateTax(String grossTotal, String taxPercentage) {
    try {
      double total = double.parse(grossTotal);
      double tax = double.parse(taxPercentage);
      return total * (tax / 100);
    } catch (e) {
      print("Invalid number format: $e");
      return 0.0; // Ya koi error dikhane ka system bana sakte ho
    }
  }

}

