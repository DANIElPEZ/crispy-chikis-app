import 'package:crispychikis/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:crispychikis/provider/provider.dart';
import 'package:crispychikis/views/policities.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool isChecked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final defaultText = {'nombre': '', 'email': '', 'telefono': '', 'acepto': 2};

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<crispyProvider>(context, listen: false);
    final userData = provider.user.isNotEmpty ? provider.user[0] : defaultText;

    nameController.text = userData['nombre'];
    emailController.text = userData['email'];
    phoneController.text = userData['telefono'].toString();
    isChecked = userData['acepto'] == 1;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  Future<void> saveUser(String name, String email, String phone) async {
    final provider = Provider.of<crispyProvider>(context, listen: false);

    final Map<String, dynamic> user = {
      'nombre': name.trim(),
      'email': email.trim(),
      'telefono': phone.trim(),
      'acepto': isChecked ? 1 : 2,
      'tipo_usuario': 2
    };

    final bool isSave = await provider.insertOrUpdateUser(user);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isSave ? 'Perfil guardado.' : 'Perfil no guardado.',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: colorsPalete['white'])),
        backgroundColor: colorsPalete['light brown']));
    provider.loadUser();
  }

  String sanitizeName(String name) {
    name = name.trim();
    final RegExp regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    return regex.hasMatch(name) ? name : "";
  }

  String sanitizeEmail(String email) {
    email = email.trim();
    final RegExp forbiddenChars = RegExp(r'''[<>\"'`;=]''');

    if (forbiddenChars.hasMatch(email)) {
      return "";
    }

    final RegExp regex = RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com)$");

    return regex.hasMatch(email) ? email : "";
  }

  String sanitizePhone(String phone) {
    final RegExp regex = RegExp(r'^\+\d{1,3}\s\d{10}$');
    return regex.hasMatch(phone) ? phone : "";
  }

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
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Column(children: [
            Text('Bienvenido a Crispy Chikis',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: colorsPalete['white'])),
            Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 3, color: colorsPalete['dark brown']!)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/logo.jpeg', width: 150))),
            SizedBox(height: 20),
            Expanded(child:
                Consumer<crispyProvider>(builder: (context, provider, child) {
              provider.checkConnection();
              if (provider.getConnection) {
                return Stack(children: [
                  SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, children: [
                        CustomTextField(
                            controller: nameController, labelText: 'Nombre',
                        placeHolder: 'Rodolfo Ramirez'),
                        SizedBox(height: 10),
                        CustomTextField(
                            controller: emailController, labelText: 'Correo',
                        placeHolder: 'rodolfo.ramirez@gmail.com'),
                        SizedBox(height: 10),
                        CustomTextField(
                            controller: phoneController, labelText: 'Telefono',
                        placeHolder: '+57 3112345678'),
                        SizedBox(height: 15),
                        Text('Leer antes de usar la app',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: colorsPalete['white']
                        )),
                        SizedBox(height: 5),
                        CustomButton(text: 'Politicas', onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>Policities()));
                        }),
                        provider.user.isNotEmpty?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text('Eliminar perfil',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: colorsPalete['white']
                                )),
                            SizedBox(height: 5),
                            CustomButton(text: 'Solicitar eliminación', onPressed: () async{
                              final url = Uri.parse('https://pages-ten-mu.vercel.app');

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication); // Abre en navegador externo
                              } else {
                                throw 'No se pudo abrir el enlace: $url';
                              }
                            }),
                          ],
                        ): Container(),
                        SizedBox(height: 250)
                      ])),
                  Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Stack(
                        children: [
                          Container(
                              color: colorsPalete['orange'],
                              height: 95,
                              width: MediaQuery.of(context).size.width),
                          Column(children: [
                            Row(children: [
                              Checkbox(
                                  value: isChecked,
                                  onChanged: (newValue) {
                                    setState(() => isChecked = newValue!);
                                  },
                                  activeColor: colorsPalete['dark blue']),
                              GestureDetector(
                                onTap: () {
                                  setState(() => isChecked = !isChecked);
                                },
                                child: Text(
                                    'Acepto tratamiento de datos personales.',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: colorsPalete['white'])),
                              )
                            ]),
                            CustomButton(
                                text: 'GUARDAR PERFIL',
                                onPressed: () async {
                                  final name = sanitizeName(nameController.text);
                                  final email = sanitizeEmail(emailController.text);
                                  final phone = sanitizePhone(phoneController.text);
                                  await saveUser(name, email, phone);
                                })
                          ]),
                        ],
                      ))
                ]);
              } else {
                return Column(children: [
                  Expanded(child: Container()),
                  Center(
                      child: Text('Revisa tu conexion a internet.',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: colorsPalete['white']))),
                  Expanded(child: Container()),
                  CustomButton(
                      text: 'Intertar conectarse',
                      onPressed: () {
                        provider.checkConnection();
                      }),
                  SizedBox(height: 20)
                ]);
              }
            }))
          ]))
    ]);
  }
}
