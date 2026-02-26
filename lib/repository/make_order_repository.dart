import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crispychikis/repository/sqlite_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MakeOrderRepository {
  final client = Supabase.instance.client;
  DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> MakeOrder(String direccion, String metodoPago,
      String aditional_description, List products, double total) async {
    final List productsId = [];
    for (int i = 0; i < products.length; i++) {
      productsId.add(products[i][0]);
    }

    final user=await dbHelper.getUser();

    final Map<String, dynamic> order = {
      'usuario_id': user['usuario_id'],
      'productos': productsId,
      'direccion': direccion,
      'precio_total': total,
      'fecha_creacion_pedido': DateTime.now().toString(),
      'estado': 1,
      'descripcion_adicional': aditional_description
    };

    final response =
        await Supabase.instance.client.from('ordenes').insert(order).select();
    await Supabase.instance.client.from('pagos').insert({
      'orden_id': response.first['orden_id'],
      'metodo': metodoPago == 'Efectivo' ? 1 : 2
    });
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

  Future<List> addProduct(int id, String title, double price, List products)async{
    return [...products, [id, title, price]];
  }

  Future<List> deleteProduct(int id, List products)async{
    for (int i = 0; i < products.length; i++) {
      if (products[i][0] == id) {
        products.removeAt(i);
        break;
      }
    }
    return products;
  }

  Future<List> calculateTotal(List products) async {
    double total = 0;
    double iva=0;
    double totalWithoutIva=0;
    for (int i = 0; i < products.length; i++) {
      total += products[i][2];
    }
    iva = total * 0.19;
    totalWithoutIva = total - iva;

    return [total, iva, totalWithoutIva];
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
}
