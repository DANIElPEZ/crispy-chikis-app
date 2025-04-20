import 'package:flutter/material.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Policities extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final title=GoogleFonts.poppins(
      color: colorsPalete['white'],
      fontWeight: FontWeight.w800,
      fontSize: 23
    );
    final content=GoogleFonts.poppins(
        color: colorsPalete['white'],
        fontWeight: FontWeight.w500,
        fontSize: 19
    );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
              bg_color: colorsPalete['orange']!,
              shape_color: colorsPalete['dark blue']!)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalete['orange'],
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Politicas de privacidad',
                    style: title),
                  ),
                  SizedBox(height: 8),
                  Text('Recolectamos datos personales:', style: content),
                  SizedBox(height: 4),
                  Text('• Nombre completo', style: content),
                  Text('• Correo electrónico', style: content),
                  Text('• Número de teléfono', style: content),
                  Text('Recolectamos datos de ubicación al hacer un pedido:', style: content),
                  Text('• Dirección de entrega', style: content),
                  SizedBox(height: 8),
                  Text(
                      'Estos datos se usan únicamente para procesar tu pedido.',
                      style: content),
                  SizedBox(height: 8),
                  Text('Sobre pagos y seguridad:', style: content),
                  SizedBox(height: 4),
                  Text(
                      '• No se recolectan ni almacenan datos de tarjetas.',
                      style: content),
                  Text(
                      '• Los pagos se procesan de forma segura con Wompi.',
                      style: content),
                  Text(
                      '• Wompi maneja sus propios protocolos de seguridad.',
                      style: content),
                  SizedBox(height: 24),
                  Center(child: Text('Políticas de uso', style: title)),
                  SizedBox(height: 8),
                  Text('Al usar esta app, te comprometes a:', style: content),
                  SizedBox(height: 4),
                  Text(
                      '• Proporcionar datos reales, precisos y actualizados.',
                      style: content),
                  Text(
                      '• No enviar información falsa o incompleta.',
                      style: content),
                  SizedBox(height: 8),
                  Text(
                      'El mal uso puede causar problemas o cancelación del pedido.',
                      style: content),
                  SizedBox(height: 24),
                  Text('Nota importante:', style: content),
                  SizedBox(height: 4),
                  Text(
                      '• Al presionar "Hacer pedido", a app intenta consultar la hora actual a través de una API (una conexión con un servidor que da la hora exacta).',
                      style: content),
                  Text(
                      '• Si esto ocurre, intenta nuevamente más tarde o revisa tu conexión a internet.',
                      style: content)
                ]
              ),
            )),
            SizedBox(height: 6),
            CustomButton(text: 'Volver', onPressed: (){
              Navigator.pop(context);
            }),
            SizedBox(height: 20)
          ]
        )
      )
    );
  }
}