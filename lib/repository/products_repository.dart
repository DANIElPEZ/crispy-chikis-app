import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crispychikis/repository/sqlite_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsRepository {
  final client = Supabase.instance.client;
  DatabaseHelper dbHelper = DatabaseHelper();

  Future<List> fetchProducts()async{
    final products = await client
        .from('productos')
        .select()
        .order('tipo_producto', ascending: true);

    final typeProductResponse = await client
        .from('tipo_producto')
        .select();

    Map<String, List<List<dynamic>>> groupedProducts = {};

    for (var type in typeProductResponse) {
      groupedProducts[type['nombre']] = [];
    }

    for (var product in products) {
      for (var type in typeProductResponse) {
        if (type['tipo_producto_id'] == product['tipo_producto']) {
          groupedProducts[type['nombre']]?.add([
            product['producto_id']??0,
            product['nombre']??'',
            product['descripcion']??'',
            product['precio']??0,
            product['imagen']??''
          ]);
        }
      }
    }

    return groupedProducts.entries.map((entry) {
      return [entry.key, entry.value];
    }).toList();
  }

  Future<List> fecthCommentsByProduct(int id)async{
    return await client
        .from('resenas')
        .select('nombre_user, descripcion, puntuacion')
        .eq('producto_id', id);
  }

  Future<List> searchProduct(String query, List products) async {
    final filterProducts= products
        .map((category) {
      String categoryName = category[0];
      List<List<dynamic>> products = category[1];

      List<List<dynamic>> filteredProducts = products
          .where((product) => product[1].toLowerCase().contains(query))
          .toList();

      if (filteredProducts.isNotEmpty) {
        return [categoryName, filteredProducts];
      } else {
        return null;
      }
    })
        .where((category) => category != null)
        .toList()
        .cast<List<dynamic>>();

    return filterProducts;
  }

  Future<bool> getCurrentTime() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api-time-crispy-chikis.vercel.app/api/date'
      ));
      if (response.statusCode != 200) return false;

      final data = json.decode(response.body);
      if (data == null) return false;

      final day = data['day'];
      final hour = data['hour'];

      return (day != 'Monday') && (9 < hour && hour < 22);
    }catch(e){
      return false;
    }
  }

  Future<bool> getUser()async{
    final result=await dbHelper.getUser();
    if(result.isEmpty) return false;
    final order=await client
        .from('ordenes')
        .select('estado')
        .eq('usuario_id', result['usuario_id'])
        .order('orden_id', ascending: false)
        .limit(1);
    if(order.isEmpty) return true;
    final data=order.first;
    return data['estado']==3?true:false;
  }
}