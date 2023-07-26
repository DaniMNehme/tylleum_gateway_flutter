library tylleum_gateway_flutter;

/// A Calculator.
// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tylleum_gateway_flutter/request.dart';

class tylleum_gateway_flutter extends StatefulWidget {
  late final String coin;
  late final num fiat;
  late final num amount;
  late final String receiver;
  late final String TxType;
  late final String merchantType;
  late final String BusinessName;
  late final String paymentID;

  tylleum_gateway_flutter({
    required this.coin,
    required this.fiat,
    required this.amount,
    required this.receiver,
    required this.TxType,
    required this.merchantType,
    required this.BusinessName,
    required this.paymentID,
  });

  @override
  _tylleum_gateway_flutterState createState() =>
      _tylleum_gateway_flutterState();
}

class _tylleum_gateway_flutterState extends State<tylleum_gateway_flutter> {
  Timer? _timer;
  int _start = 10;
  bool _isConfirmed = false;

  void startPeriodicTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      var status = await gatewayrequest("40");
      if (status["status"] == "CONFIRMED") {
        setState(() {
          _isConfirmed = true;
        });
        _timer!.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startPeriodicTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConfirmed) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {});
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#F4F4F4"),
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: SingleChildScrollView(
            child: Container(
                color: HexColor("#F4F4F4"),
                child: Column(children: [
                  Image.asset(
                    'assets/icons/Logo.png',
                    height: 60,
                  ),
                  // Card(
                  //   child:
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(top: 15, bottom: 0),
                    margin:
                        const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Paying to',
                            style: GoogleFonts.roboto(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(widget.BusinessName,
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Divider(
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(height: 8),
                        Text('Amount:',
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Text(widget.fiat.toString() + "\$",
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                            )),
                        SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            QrImage(
                              data:
                                  '{"fiat":${widget.fiat},"coin":"${widget.coin}","receiver":"${widget.BusinessName}","type":"${widget.TxType}","id":"${widget.paymentID}"}',
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: AssetImage('assets/icons/logo2.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(height: 8),
                        Text('You can also',
                            style: GoogleFonts.roboto(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Pay Manually',
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                          'Enter the Payment ID manually on the Tylleum app to pay',
                          style: GoogleFonts.roboto(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Payment ID: ${widget.paymentID}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              IconButton(
                                  icon: new Icon(Icons.copy_rounded),
                                  color: Colors.black.withOpacity(.5),
                                  // highlightColor: Colors.white,
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: widget.paymentID));
                                    snackBar(String? message) {
                                      return ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          padding: EdgeInsets.all(20),
                                          content: Text(message!),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }

                                    snackBar("Copied to clipboard");
                                  })
                            ])
                      ],
                    ),
                  ),
                ]))));
  }
}
