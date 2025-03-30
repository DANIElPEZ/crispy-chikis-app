import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chispy_chikis/database/sqlitehelper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chispy_chikis/model/product_model.dart';

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
          .from(tables['table1'].toString()).select().order('tipo_producto', ascending: true);

      products = List<ProductModel>.from(
          response.map((product) => ProductModel.fromJSON(product)));

      final typeProductResponse = await Supabase.instance.client.from(
          tables['table6'].toString()).select();

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

  Future<void> fetchOrders(int id) async {
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
          .select()
          .eq('usuario_id', id);
      orders = [];
    } catch (e) {
      orders = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final user = dbHelper.getUser();
    print(user);
  }
}
