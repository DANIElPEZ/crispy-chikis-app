import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crispychikis/repository/sqlite_helper.dart';

class OrdersRepository {
  final client = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getLatestOrder(int userId){
    return client
        .from('ordenes')
        .stream(primaryKey: ['orden_id'],)
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

  Future<List<List<dynamic>>> loadOrder(List products, int userId) async{
    List<List<dynamic>> resumen = [];
    Map<int, int> conteo = {};
    final order = await client
        .from('ordenes')
        .select('productos')
        .eq('usuario_id', userId)
        .order('orden_id', ascending: false)
        .limit(1);

    if(products.isEmpty || order.isEmpty) return [];

    final idsOrder=order.first['productos'];

    for (var id in idsOrder) {
      conteo[id] = (conteo[id] ?? 0) + 1;
    }

    conteo.forEach((id, cantidad) {
      final producto = products.firstWhere(
              (p) => p['producto_id'] == id,
          orElse: () => <String, dynamic>{});

      if (producto.isNotEmpty) {
        resumen.add(
            [cantidad, producto['nombre'], producto['precio'] * cantidad]);
      }
    });

    return resumen;
  }
}