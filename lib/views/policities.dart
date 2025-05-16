import 'package:flutter/material.dart';
import 'package:crispychikis/color/colors.dart';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('Políticas de Privacidad', style: title),
                        ),
                        SizedBox(height: 8),
                        Text('Datos personales que recopilamos:',
                            style: content),
                        SizedBox(height: 4),
                        Text('• Nombre completo', style: content),
                        Text('• Correo electrónico', style: content),
                        Text('• Número de teléfono', style: content),
                        SizedBox(height: 8),
                        Text('Datos de ubicación al realizar pedidos:',
                            style: content),
                        SizedBox(height: 4),
                        Text('• Dirección de entrega', style: content),
                        SizedBox(height: 8),
                        Text(
                          'Finalidad de los datos:',
                          style: content,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Procesar, gestionar y entregar los pedidos realizados en la app.',
                          style: content,
                        ),
                        Text(
                          '• Mejorar la calidad de nuestros servicios y la experiencia del usuario.',
                          style: content,
                        ),
                        Text(
                          '• Contactarte si es necesario para completar tu pedido.',
                          style: content,
                        ),
                        SizedBox(height: 8),
                        Text('Almacenamiento de datos:', style: content),
                        SizedBox(height: 4),
                        Text(
                          '• Todos los datos personales y de pedidos se almacenan de forma segura en nuestros servidores a través de Supabase.',
                          style: content,
                        ),
                        Text(
                          '• Implementamos medidas de seguridad para proteger tus datos contra accesos no autorizados.',
                          style: content,
                        ),
                        SizedBox(height: 8),
                        Text('Sobre pagos y seguridad:', style: content),
                        SizedBox(height: 4),
                        Text(
                          '• No recolectamos, almacenamos ni tenemos acceso a los datos de tus tarjetas de crédito o débito.',
                          style: content,
                        ),
                        Text(
                          '• Los pagos son procesados de forma segura a través de Wompi, quien cuenta con protocolos de seguridad certificados.',
                          style: content,
                        ),
                        Text(
                          '• Para más información sobre la seguridad de pagos, te invitamos a consultar las políticas de Wompi.',
                          style: content,
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: Text('Políticas de Uso', style: title),
                        ),
                        SizedBox(height: 8),
                        Text('Al utilizar esta aplicación, aceptas:',
                            style: content),
                        SizedBox(height: 4),
                        Text(
                          '• Proporcionar información veraz, precisa y actualizada.',
                          style: content,
                        ),
                        Text(
                          '• No proporcionar información falsa, incompleta o fraudulenta.',
                          style: content,
                        ),
                        Text(
                          '• No utilizar la aplicación para fines ilícitos o no autorizados.',
                          style: content,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'El incumplimiento de estas condiciones podrá resultar en la cancelación de tu pedido o la suspensión de tu cuenta.',
                          style: content,
                        ),
                        SizedBox(height: 24),
                        Text('Notas adicionales:', style: content),
                        SizedBox(height: 4),
                        Text(
                          '• Al presionar "Hacer pedido", la aplicación realiza una consulta a un servidor externo para obtener la hora actual y garantizar la correcta gestión del pedido.',
                          style: content,
                        ),
                        Text(
                          '• Si esta consulta falla, te recomendamos verificar tu conexión a Internet o intentar nuevamente más tarde.',
                          style: content,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Al continuar usando esta aplicación, aceptas nuestras políticas de privacidad y términos de uso.',
                          style: content,
                        ),
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
