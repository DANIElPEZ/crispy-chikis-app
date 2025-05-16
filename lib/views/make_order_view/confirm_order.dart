import 'package:flutter/material.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:crispychikis/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:crispychikis/main.dart';

class ConfirmOrder extends StatefulWidget {
  @override
  State<ConfirmOrder> createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrder> {
  TextEditingController directionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardDateController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();

  List<String> paymentMethods = ['Efectivo', //'Tarjeta'
  ];
  String dropDownValue = 'Efectivo';

  Future<void> redirectToOrders() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainView(indexView: 0)),
        (Route<dynamic> route) => false);
  }

  Future<bool> confirmOrder() async {
    final String direccion = sanitizeDirection(directionController.text);
    final String aditional_description = descriptionController.text;
    final String metodoPago = dropDownValue;
    final provider = Provider.of<crispyProvider>(context, listen: false);
    final bool? isMaked;
    if (metodoPago == 'Efectivo') {
      isMaked = await provider.makeOrder(
          direccion, metodoPago, aditional_description);
    } else {
      final bool cardNumber = validateCardNumber(cardNumberController.text);
      final bool cardDate = validateExpiryDate(cardDateController.text);
      final bool cardCvv = validateCVV(cardCvvController.text);

      if (cardNumber && cardDate && cardCvv) {
        isMaked = await provider.makeOrderCard(
            direccion,
            metodoPago,
            aditional_description,
            cardNumberController.text,
            cardDateController.text,
            cardCvvController.text);
      } else {
        isMaked = false;
      }
    }
    await provider.fetchOrders();
    return isMaked;
  }

  String sanitizeDirection(String direction) {
    direction = direction.trim();
    final RegExp regex = RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s#,.\/º°-]+$');
    return regex.hasMatch(direction) ? direction : "";
  }

  String sanitizeDescription(String description) {
    description = description.trim();
    final RegExp regex = RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s ,.-]+$');
    return regex.hasMatch(description) ? description : "";
  }

  bool validateCardNumber(String cardNumber) {
    final RegExp regex = RegExp(r'^\d{13,19}$');
    String cleaned = cardNumber.replaceAll(RegExp(r'\s+'), '');
    return regex.hasMatch(cleaned);
  }

  bool validateExpiryDate(String expiryDate) {
    final RegExp regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    return regex.hasMatch(expiryDate);
  }

  bool validateCVV(String cvv) {
    final RegExp regex = RegExp(r'^\d{3,4}$');
    return regex.hasMatch(cvv);
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<crispyProvider>(context, listen: false);
    provider.checkConnection();
    provider.calculateTotal();
  }

  @override
  void dispose() {
    directionController.dispose();
    descriptionController.dispose();
    cardNumberController.dispose();
    cardDateController.dispose();
    cardCvvController.dispose();
    super.dispose();
  }

  Future<void> cardDialog(BuildContext context)async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=>AlertDialog(
        backgroundColor: colorsPalete['orange'],
        title: Text('Datos de tarjeta',
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorsPalete['white'])),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5
          ),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  CustomTextField(
                      labelText: 'Numero de tarjeta',
                      controller: cardNumberController,
                  placeHolder: '01234567891235'),
                  SizedBox(height: 5),
                  CustomTextField(
                      labelText: 'Fecha de vencimiento',
                      controller: cardDateController,
                  placeHolder: '06/25'),
                  SizedBox(height: 5),
                  CustomTextField(
                      labelText: 'CVC',
                      controller: cardCvvController,
                  placeHolder: '123')
                ]),
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                minimumSize: Size(130, 40),
                backgroundColor: colorsPalete['dark brown']
              ),
              child: Text('Cerrar',
                  style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: colorsPalete['pink'])))
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
                bg_color: colorsPalete['orange']!,
                shape_color: colorsPalete['dark blue']!)),
        body: Stack(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: colorsPalete['orange'],
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
          Consumer<crispyProvider>(builder: (context, provider, child) {
            provider.checkConnection();
            if (provider.getConnection) {
              return Stack(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                              controller: directionController,
                              labelText: 'Direccion',
                          placeHolder: 'Calle 12 av 12 #12-34'),
                          SizedBox(height: 10),
                          CustomTextField(
                              controller: descriptionController,
                              labelText: 'Descripcion adicional',
                          placeHolder: 'Sabor de gaseosa, salsas, etc'),
                          SizedBox(height: 10),
                          Text('Metodo de pago',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colorsPalete['white'])),
                          SizedBox(height: 5),
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
                                          .map<DropdownMenuItem<String>>(
                                              (String value) => DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: colorsPalete[
                                                              'dark brown']))))
                                          .toList(),
                                      onChanged: (String? value) =>
                                          setState(() => dropDownValue = value!)))),
                          dropDownValue == 'Efectivo'
                              ? Container()
                              : Padding(padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: CustomButton(text: 'Datos de tarjeta', onPressed: (){
                              cardDialog(context);
                            })
                          ))
                        ])),
                Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Total productos: \$${provider.totalWithoutIva.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: colorsPalete['white'])),
                              Text(
                                  'Total IVA (19%): \$${provider.iva.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: colorsPalete['white'])),
                              Text(
                                  'Total a pagar: \$${provider.total.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: colorsPalete['white'])),
                              SizedBox(height: 9),
                              Container(
                                  height: 2,
                                  width: MediaQuery.of(context).size.width,
                                  color: colorsPalete['white']),
                              SizedBox(height: 6),
                              FloatingActionButton.extended(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: colorsPalete['dark brown'],
                                  icon: Icon(Icons.arrow_back,
                                      color: colorsPalete['pink']),
                                  label: Text('Regresar',
                                      style: GoogleFonts.nunito(
                                          color: colorsPalete['pink'],
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700))),
                              SizedBox(height: 6),
                              CustomButton(
                                  text: 'HACER PAGO',
                                  onPressed: () async {
                                    final bool isMaked = await confirmOrder();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          isMaked
                                              ? 'Pedido realizado con exito.'
                                              : 'No se pudo realizar el pedido.',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: colorsPalete['white'])),
                                      backgroundColor:
                                          colorsPalete['light brown'],
                                    ));
                                    await Future.delayed(Duration(seconds: 4));
                                    if (isMaked) redirectToOrders();
                                  })
                            ])))
              ]);
            } else {
              return Column(children: [
                Expanded(child: Container()),
                Center(
                    child: Text('Revisa tu conexion a internet',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: colorsPalete['white']))),
                Expanded(child: Container()),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              backgroundColor: colorsPalete['dark brown'],
                              icon: Icon(Icons.arrow_back,
                                  color: colorsPalete['pink']),
                              label: Text('Regresar',
                                  style: GoogleFonts.nunito(
                                      color: colorsPalete['pink'],
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))),
                          SizedBox(height: 12),
                          CustomButton(
                              text: 'Intertar conectarse',
                              onPressed: () {
                                provider.checkConnection();
                              })
                        ]))
              ]);
            }
          })
        ]));
  }
}
