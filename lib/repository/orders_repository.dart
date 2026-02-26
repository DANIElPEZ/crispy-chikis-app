import 'package:supabase_flutter/supabase_flutter.dart';

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
}