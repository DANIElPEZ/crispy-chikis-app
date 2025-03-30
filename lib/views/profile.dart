import 'package:chispy_chikis/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/components/text_field.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool isChecked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Container(
            color: colorsPalete['dark blue'],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.19),
        Flexible(
            child: Container(
                color: colorsPalete['orange'],
                width: MediaQuery.of(context).size.width))
      ]),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(children: [
            Text('Bienvenido a Crispy Chikis',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: colorsPalete['white'])),
            Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 3, color: colorsPalete['dark brown']!)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/logo.jpeg', width: 150))),
            SizedBox(height: 25),
            Expanded(
                child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CustomTextField(
                          controller: nameController, labelText: 'Nombre'),
                      SizedBox(height: 10),
                      CustomTextField(
                          controller: emailController, labelText: 'Correo'),
                      SizedBox(height: 10),
                      CustomTextField(
                          controller: phoneController, labelText: 'Telefono'),
                    ]))),
            SizedBox(height: 110)
          ])),
      Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              Row(children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (newValue) {
                      setState(() => isChecked = newValue!);
                    },
                    activeColor: colorsPalete['dark blue']),
                Text('Acepto tratamiento de datos personales.',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: colorsPalete['white']))
              ]),
              CustomButton(text: 'GUARDAR PERFIL', onPressed: () {})
            ]),
          ))
    ]);
  }
}
