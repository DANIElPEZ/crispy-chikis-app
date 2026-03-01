import 'dart:async';
import 'package:crispychikis/repository/sqlite_helper.dart';
import 'package:crispychikis/repository/orders_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/orders/orders_state.dart';
import 'package:crispychikis/blocs/orders/orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;
  StreamSubscription? orderSubscription;
  DatabaseHelper dbHelper = DatabaseHelper();

  OrdersBloc({required this.ordersRepository}) : super(OrdersState.initial()) {
    on<loadProducts>((event, emit) async {
      final products = await ordersRepository.fetchProducts();
      emit(state.copyWith(products: products));
    });
    on<StreamGetLatestOrder>((event, emit) async {
      await orderSubscription?.cancel();
      try {
        emit(state.copyWith(loading: true));
        final user = await dbHelper.getUser();
        final userId = user['usuario_id'] as int;
        orderSubscription =
            ordersRepository.getLatestOrder(userId).listen((data) {
          add(OnOrderDataReceived(data));
        }, onError: (error) {
          emit(state.copyWith(loading: false));
        });
      } catch (e) {
        emit(state.copyWith(loading: false));
      }
    });
    on<OnOrderDataReceived>((event, emit) {
      emit(state.copyWith(data: event.data, loading: false));
      add(createListProducts());
    });
    on<createListProducts>((event, emit) {
      if (state.data.isEmpty || state.products.isEmpty) return;
      final idsOrder = state.data.first['productos'];
      List<List<dynamic>> resumen = [];
      Map<int, int> conteo = {};

      for (var id in idsOrder) {
        conteo[id] = (conteo[id] ?? 0) + 1;
      }

      conteo.forEach((id, cantidad) {
        final producto = state.products.firstWhere(
                (p) => p['producto_id'] == id, orElse: () => <String, dynamic>{});

        if (producto != null) {
          resumen.add([cantidad, producto['nombre'], producto['precio'] * cantidad]);
        }
      });
      emit(state.copyWith(resume: resumen));
    });
    on<makeCall>((event, emit)async{
      final order = state.data.first;
      await ordersRepository.makePhoneCall(order['phone_order']);
    });
  }

  @override
  Future<void> close() {
    orderSubscription?.cancel();
    return super.close();
  }
}
