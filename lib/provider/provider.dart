import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chispy_chikis/database/sqlitehelper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chispy_chikis/model/product_model.dart';
import 'package:chispy_chikis/model/order_model.dart';
import 'package:chispy_chikis/model/comment.dart';

class crispyProvider extends ChangeNotifier {
  crispyProvider() {
    loadNamesOfTables();
  }

  DatabaseHelper dbHelper = DatabaseHelper();
  bool isLoading = false;
  bool getConnection = false;
  List products = [];
  List<List<dynamic>> clasifiedProducts = [];
  List orders = [];
  List placeOrder = [];

  //place order
  List myProducts = [];

  //comfirm order
  double total = 0;
  double iva = 0;
  double totalWithoutIva = 0;

  //get user
  final List user = [];

  //get comment by product
  List comments=[];

  //list tables
  Map<String, String> tables = {
    'table1': '',
    'table2': '',
    'table3': '',
    'table4': '',
    'table5': '',
    'table6': '',
  };

  Future<void> loadNamesOfTables() async {
    await dotenv.load(fileName: '.env');
    tables['table1'] = dotenv.env['TABLE_ONE'] ?? '';
    tables['table2'] = dotenv.env['TABLE_TWO'] ?? '';
    tables['table3'] = dotenv.env['TABLE_THREE'] ?? '';
    tables['table4'] = dotenv.env['TABLE_FOUR'] ?? '';
    tables['table5'] = dotenv.env['TABLE_FIVE'] ?? '';
    tables['table6'] = dotenv.env['TABLE_SIX'] ?? '';
  }

  Future<void> checkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      getConnection = (connectivityResult[0] == ConnectivityResult.mobile ||
          connectivityResult[0] == ConnectivityResult.wifi);
    } catch (e) {
      getConnection = false;
    }
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    checkConnection();
    notifyListeners();
    try {
      if (!getConnection) {
        products = [];
        return;
      }
      final response = await Supabase.instance.client
          .from(tables['table1'].toString())
          .select()
          .order('tipo_producto', ascending: true);

      products = List<ProductModel>.from(
          response.map((product) => ProductModel.fromJSON(product)));

      final typeProductResponse = await Supabase.instance.client
          .from(tables['table6'].toString())
          .select();

      Map<String, List<List<dynamic>>> groupedProducts = {};

      for (var type in typeProductResponse) {
        groupedProducts[type['nombre']] = [];
      }

      for (var product in products) {
        for (var type in typeProductResponse) {
          if (type['tipo_producto_id'] == product.tipo_producto) {
            groupedProducts[type['nombre']]?.add([
              product.id,
              product.nombre,
              product.descripcion,
              product.precio,
              product.imagen
            ]);
          }
        }
      }

      clasifiedProducts = groupedProducts.entries.map((entry) {
        return [entry.key, entry.value];
      }).toList();
    } catch (e) {
      products = [];
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fecthCommentsByProduct(int id) async {
    isLoading = true;
    notifyListeners();
    checkConnection();
    try{
      if(!getConnection){
        comments=[];
        return;
      }
      final response=await Supabase.instance.client.from(tables['table5'].toString()).select('nombre_user, descripcion, puntuacion').eq('producto_id', id);

      comments=List<CommentModel>.from(
          response.map((comment) => CommentModel.fromJSON(comment)));
    }catch(e){
      comments=[];
    }
    isLoading=false;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    isLoading = true;
    checkConnection();
    notifyListeners();
    try {
      if (!getConnection) {
        orders = [];
        return;
      }
      final response = await Supabase.instance.client
          .from(tables['table3'].toString())
          .select('productos, fecha_creacion_pedido, estado')
          .eq('usuario_id', user[0]['usuario_id']);

      orders = List<OrderModel>.from(
          response.map((order) => OrderModel.fromJSON(order)));
    } catch (e) {
      orders = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProducts(int id, String title, double price) async {
    myProducts.add([id, title, price]);
    notifyListeners();
  }

  Future<bool> makeOrder(String direccion, String metodoPago) async {
    try {
      if (!getConnection || direccion.isEmpty) return false;

      final productosPedido = [];

      for (int i = 0; i < myProducts.length; i++) {
        productosPedido.add(myProducts[i][0]);
      }

      final Map<String, dynamic> order = {
        'usuario_id': user[0]['usuario_id'],
        'productos': productosPedido,
        'direccion': direccion,
        'precio_total': total,
        'fecha_creacion_pedido': DateTime.now().toString(),
        'estado': 1
      };

      final response = await Supabase.instance.client
          .from(tables['table3'].toString())
          .insert(order)
          .select();
      await Supabase.instance.client.from(tables['table4'].toString()).insert({
        'orden_id': response.first['orden_id'],
        'metodo': metodoPago == 'Efectivo' ? 1 : 2
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteProduct(int id) async {
    for (int i = 0; i < myProducts.length; i++) {
      if (myProducts[i][0] == id) {
        myProducts.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  Future<void> calculateTotal() async {
    total = 0;
    for (int i = 0; i < myProducts.length; i++) {
      total += myProducts[i][2];
    }
    iva = total * 0.19;
    totalWithoutIva = total - iva;
    notifyListeners();
  }

  Future<bool> insertOrUpdateUser(Map<String, dynamic> user) async {
    final ifUserExist = await Supabase.instance.client
        .from(tables['table2'].toString())
        .select('usuario_id, nombre, email, telefono, acepto')
        .eq('email', user['email']);

    if (ifUserExist.isNotEmpty) {
      //actualizar usuario
      try {
        final userSupabase = await Supabase.instance.client
            .from(tables['table2'].toString())
            .update(user)
            .eq('email', user['email'])
            .select();

        final Map<String, dynamic> userMap = {
          'usuario_id': userSupabase.first['usuario_id'],
          'nombre': userSupabase.first['nombre'],
          'email': userSupabase.first['email'],
          'telefono': userSupabase.first['telefono'],
          'acepto': userSupabase.first['acepto']
        };
        await dbHelper.insertORupdate(userMap);
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      //insetar usuario
      try {
        final userSupabase = await Supabase.instance.client
            .from(tables['table2'].toString())
            .insert(user)
            .select();

        final Map<String, dynamic> userMap = {
          'usuario_id': userSupabase.first['usuario_id'],
          'nombre': userSupabase.first['nombre'],
          'email': userSupabase.first['email'],
          'telefono': userSupabase.first['telefono'],
          'acepto': userSupabase.first['acepto']
        };
        await dbHelper.insertORupdate(userMap);
        await loadUser();
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  Future<void> loadUser() async {
    final userSqlite = await dbHelper.getUser();
    user.add(userSqlite.first);
    notifyListeners();
  }
}
