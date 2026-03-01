import 'package:flutter/material.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/views/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_event.dart';
import 'package:crispychikis/blocs/make_order/make_order_state.dart';
import 'package:crispychikis/components/snack_bar_message.dart';

class ConfirmOrder extends StatefulWidget {
  @override
  State<ConfirmOrder> createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrder> {
  TextEditingController directionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> paymentMethods = ['Efectivo', //'Online'
  ];
  String dropDownValue = 'Efectivo';

  @override
  void initState() {
    context.read<MakeOrderBloc>().add(CalculateTotal());
    super.initState();
  }

  @override
  void dispose() {
    directionController.dispose();
    descriptionController.dispose();
    super.dispose();
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
        body: BlocListener<MakeOrderBloc, MakeOrderState>(
          listenWhen: (previous, current) =>
              previous.isMaked != current.isMaked || previous.orderError != current.orderError,
          listener: (context, state) async{
            if (state.isMaked) {
              final messenger = ScaffoldMessenger.of(context);
              snackBarMessage(messenger, 'Pedido realizado con exito');
              await Future.delayed(Duration(milliseconds: 1500));
              if(!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainView(indexView: 0)),
                      (Route<dynamic> route) => false);
            }else if (state.orderError == true){
              snackBarMessage(ScaffoldMessenger.of(context), 'No se pudo realizar el pedido');
            }
          },
          child: Stack(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: colorsPalete['orange'],
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                child: Column(
                  children: [
                    CustomTextField(
                        controller: directionController,
                        labelText: 'Direccion',
                        placeHolder: 'Calle 12 #12-34'),
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
                                                    fontWeight: FontWeight.w600,
                                                    color: colorsPalete[
                                                        'dark brown']))))
                                    .toList(),
                                onChanged: (String? value) =>
                                    setState(() => dropDownValue = value!)))),
                    SizedBox(height: 30),
                    dropDownValue == 'Efectivo'
                        ? Container():Center(
                      child: CustomButton(text: 'Pagar en linea', onPressed: (){
                        snackBarMessage(ScaffoldMessenger.of(context), 'En desarrollo');
                      }))
                  ],
                )),
            BlocBuilder<MakeOrderBloc, MakeOrderState>(
                builder: (context, state) {
              return Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Total productos: \$${state.totalWithoutIva.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    color: colorsPalete['white'])),
                            Text(
                                'Total IVA (19%): \$${state.iva.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    color: colorsPalete['white'])),
                            Text(
                                'Total a pagar: \$${state.total.toStringAsFixed(2)}',
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
                                text: 'HACER PEDIDO',
                                onPressed: () {
                                  context.read<MakeOrderBloc>().add(MakeOrder(
                                      direccion: directionController.text,
                                      aditional_description:
                                          descriptionController.text,
                                      metodoPago: dropDownValue));
                                })
                          ])));
            })
          ]),
        ));
  }
}