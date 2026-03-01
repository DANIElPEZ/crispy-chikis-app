import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersRepository {
  final client = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getLatestOrder(int userId){
    return client
        .from('ordenes')
        .stream(primaryKey: ['orden_id'])
        .eq('usuario_id', userId)
        .order('orden_id', ascending: false)
        .limit(1);
  }

  Future<List> fetchProducts()async{
    return await client
        .from('productos')
        .select('producto_id, nombre, precio')
        .order('tipo_producto', ascending: true);
  }

  Future<void> makePhoneCall(String phoneNumber)async{
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );

    try {
      await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Error fatal al intentar abrir el marcador: $e");
    }
  }
}