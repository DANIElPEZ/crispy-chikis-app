import 'package:flutter/material.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Policities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = GoogleFonts.poppins(
        color: colorsPalete['white'],
        fontWeight: FontWeight.w800,
        fontSize: 23);
    final content = GoogleFonts.poppins(
        color: colorsPalete['white'],
        fontWeight: FontWeight.w500,
        fontSize: 19);
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('Políticas de Privacidad', style: title),
                        ),
                        SizedBox(height: 12),
                        Text('1. Información recopilada', style: content),
                        SizedBox(height: 4),
                        Text('• Nombre completo', style: content),
                        Text('• Correo electrónico', style: content),
                        Text('• Número de teléfono', style: content),
                        Text('• Dirección de entrega', style: content),
                        SizedBox(height: 12),
                        Text('2. Uso de la información', style: content),
                        SizedBox(height: 4),
                        Text(
                          '• Gestionar y entregar tus pedidos',
                          style: content,
                        ),
                        Text(
                          '• Contactarte sobre tu pedido',
                          style: content,
                        ),
                        SizedBox(height: 12),
                        Text('3. Almacenamiento y seguridad', style: content),
                        SizedBox(height: 4),
                        Text(
                          '• Tus datos se almacenan de forma segura mediante Supabase',
                          style: content,
                        ),
                        SizedBox(height: 12),
                        Text('4. Pagos', style: content),
                        Text(
                          '• Los pagos en línea se realizan a través de una página web externa abierta dentro de la aplicación',
                          style: content,
                        ),
                        Text(
                          '• Wompi gestiona directamente todos los medios de pago disponibles',
                          style: content,
                        ),
                        Text(
                          '• La aplicación no procesa, almacena ni tiene acceso a la información de tus tarjetas o datos financieros',
                          style: content,
                        ),
                        Text(
                          '• Toda la información de pago es administrada de forma segura por Wompi',
                          style: content,
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: Text(
                            'Términos de Uso',
                            style: title,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Al usar la aplicación, aceptas:',
                          style: content,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Proporcionar información veraz y actualizada',
                          style: content,
                        ),
                        Text(
                          '• No utilizar información falsa o fraudulenta',
                          style: content,
                        ),
                        Text(
                          '• No usar la aplicación con fines ilegales o no autorizados',
                          style: content,
                        ),
                        SizedBox(height: 12),

                        Text(
                          '• El incumplimiento de estas condiciones puede ocasionar la cancelación del pedido o la suspensión de la cuenta',
                          style: content,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Al continuar usando la aplicación, aceptas estas políticas y términos.',
                          style: content,
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6),
                CustomButton(text: 'Volver', onPressed: (){
                  Navigator.pop(context);
                }),
                SizedBox(height: 20)
              ],
            )));
  }
}
