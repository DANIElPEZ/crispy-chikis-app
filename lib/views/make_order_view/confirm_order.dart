import 'package:flutter/material.dart';
import 'package:chispy_chikis/components/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/components/text_field.dart';

class ConfirmOrder extends StatefulWidget {
  @override
  State<ConfirmOrder> createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrder> {
  TextEditingController directionController = TextEditingController();

  List<String> paymentMethods = [
    'Efectivo',
  //  'Tarjeta'
  ];

  String dropDownValue = 'Efectivo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
                bg_color: colorsPalete['orange']!,
                shape_color: colorsPalete['dark blue']!)),
        body: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: colorsPalete['orange'],
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          controller: directionController,
                          labelText: 'Direccion'),
                      SizedBox(height: 25),
                      Text('Metodo de pago',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colorsPalete['white'])),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: colorsPalete['pink'],
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  dropdownColor: colorsPalete['pink'],
                                  value: dropDownValue,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: colorsPalete['dark brown']),
                                  items: paymentMethods
                                      .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorsPalete[
                                                      'dark brown']))))
                                      .toList(),
                                  onChanged: (String? value) =>
                                      setState(() => dropDownValue = value!))))
                    ])),
            Positioned(
                bottom: 85,
                left: 30,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total productos: \$38000',
                          style: GoogleFonts.poppins(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: colorsPalete['white'])),
                      Text('Total IVA (19%): \$7900',
                          style: GoogleFonts.poppins(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: colorsPalete['white'])),
                      Text('Total a pagar: \$45900',
                          style: GoogleFonts.poppins(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: colorsPalete['white']))
                    ])),
            Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: CustomButton(text: 'HACER PAGO', onPressed: () {})))
          ],
        ));
  }
}
