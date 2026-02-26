import 'package:crispychikis/theme/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/profile/profile_bloc.dart';
import 'package:crispychikis/blocs/profile/profile_state.dart';
import 'package:crispychikis/blocs/profile/profile_event.dart';
import 'package:crispychikis/views/policities.dart';
import 'package:crispychikis/components/snack_bar_message.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(loadUser());
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  Future<void> updatePasswordModal(BuildContext context) async {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (context) => AlertDialog(
          backgroundColor: colorsPalete['dark brown'],
          title: Text(
            'Actualizar contraseña',
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: colorsPalete['white'],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                    controller: passwordController,
                    labelText: 'Contraseña',
                    placeHolder: '******',
                    isPassword: true),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: colorsPalete['dark blue'],
              ),
              child: Text(
                'Cerrar',
                style: GoogleFonts.nunito(
                  color: colorsPalete['white'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                context.read<ProfileBloc>().add(
                    updatePassword(
                        passwordController.text));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: colorsPalete['dark blue'],
              ),
              child: Text(
                'Actualizar',
                style: GoogleFonts.nunito(
                  color: colorsPalete['white'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
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
            Expanded(
                child: BlocConsumer<ProfileBloc, ProfileState>(
                    listenWhen: (prev, curr) =>
                        prev.name != curr.name || prev.email != curr.email,
                    listener: (context, state) {
                      if (state.name.isNotEmpty) {
                        nameController.text = state.name;
                        emailController.text = state.email;
                        phoneController.text = state.phone;
                      }
                    },
                    builder: (context, state) {
                      if (state.name.isNotEmpty &&
                          state.email.isNotEmpty &&
                          state.phone.isNotEmpty) {
                        return SingleChildScrollView(
                          key: ValueKey(1),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                    controller: nameController,
                                    labelText: 'Nombre',
                                    placeHolder: 'Juan Garcia'),
                                SizedBox(height: 10),
                                CustomTextField(
                                    controller: emailController,
                                    labelText: 'Correo',
                                    placeHolder: 'juan.g@gmail.com'),
                                SizedBox(height: 10),
                                CustomTextField(
                                    controller: phoneController,
                                    labelText: 'Telefono',
                                    placeHolder: '+57 3112345678'),
                                SizedBox(height: 10),
                                CustomButton(
                                    text: 'Actualizar usuario',
                                    onPressed: () {
                                      context.read<ProfileBloc>().add(
                                          updateUser(
                                              nameController.text,
                                              emailController.text,
                                              phoneController.text));
                                      snackBarMessage(
                                          ScaffoldMessenger.of(context), 'Usuario actualizado.');
                                    }),
                                SizedBox(height: 15),
                                CustomButton(
                                    text: 'Actualizar contraseña',
                                    onPressed: () {
                                      updatePasswordModal(context);
                                    }),
                                SizedBox(height: 15),
                                CustomButton(
                                    text: 'Politicas',
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Policities()));
                                    }),
                                SizedBox(height: 15),
                                CustomButton(
                                    text: 'Cerrar sesion',
                                    onPressed: () {
                                      context.read<ProfileBloc>().add(logOut());
                                    }),
                                Text(state.message,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: colorsPalete['white']))
                              ]),
                        );
                      }

                      if (state.isRegister) {
                        return SingleChildScrollView(
                          key: ValueKey(2),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                    controller: nameController,
                                    labelText: 'Nombre',
                                    placeHolder: 'Juan Garcia'),
                                SizedBox(height: 10),
                                CustomTextField(
                                    controller: emailController,
                                    labelText: 'Correo',
                                    placeHolder: 'juan.g@gmail.com'),
                                SizedBox(height: 10),
                                CustomTextField(
                                    controller: phoneController,
                                    labelText: 'Telefono',
                                    placeHolder: '+57 3112345678'),
                                SizedBox(height: 10),
                                CustomTextField(
                                    controller: passwordController,
                                    labelText: 'Contraseña',
                                    placeHolder: '******',
                                    isPassword: true),
                                SizedBox(height: 10),
                                Row(children: [
                                  Checkbox(
                                      value: isChecked,
                                      onChanged: (newValue) {
                                        setState(() => isChecked = newValue!);
                                      },
                                      activeColor: colorsPalete['dark blue']),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Policities()));
                                    },
                                    child: Text('Acepto las politicas.',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.white),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: colorsPalete['white'])),
                                  )
                                ]),
                                SizedBox(height: 10),
                                CustomButton(
                                    text: 'Registrarse',
                                    onPressed: () {
                                      context.read<ProfileBloc>().add(
                                          registerUser(
                                              nameController.text,
                                              emailController.text,
                                              passwordController.text,
                                              phoneController.text,
                                              isChecked));
                                      snackBarMessage(
                                          ScaffoldMessenger.of(context), 'Usuario registrado.');
                                    }),
                                SizedBox(height: 15),
                                CustomButton(
                                    text: 'Iniciar sesion',
                                    onPressed: () {
                                      context.read<ProfileBloc>().add(
                                          toggleRegister(isRegister: false));
                                    }),
                                Text(state.message,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: colorsPalete['white']))
                              ]),
                        );
                      }

                      return SingleChildScrollView(
                        key: ValueKey(3),
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextField(
                                  controller: emailController,
                                  labelText: 'Correo',
                                  placeHolder: 'juan.g@gmail.com'),
                              SizedBox(height: 10),
                              CustomTextField(
                                  controller: passwordController,
                                  labelText: 'Contraseña',
                                  placeHolder: '******',
                                  isPassword: true),
                              SizedBox(height: 10),
                              CustomButton(
                                  text: 'Iniciar sesion',
                                  onPressed: () {
                                    context.read<ProfileBloc>().add(loginUser(
                                        emailController.text,
                                        passwordController.text));
                                  }),
                              SizedBox(height: 15),
                              CustomButton(
                                  text: 'Registrarse',
                                  onPressed: () {
                                    context
                                        .read<ProfileBloc>()
                                        .add(toggleRegister(isRegister: true));
                                  }),
                              Text(state.message,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: colorsPalete['white']))
                            ]),
                      );
                    }))
          ]))
    ]);
  }
}
