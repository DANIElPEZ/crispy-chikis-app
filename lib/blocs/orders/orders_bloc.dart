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
      emit(state.copyWith(loading: true));
      final products = await ordersRepository.fetchProducts();
      emit(state.copyWith(products: products));
      add(createListProducts());
    });

    on<StreamGetLatestOrder>((event, emit) async {
      try {
        emit(state.copyWith(loading: true));
        final user = await dbHelper.getUser();
        final userId = user['usuario_id'] as int;
        await emit.forEach<List<Map<String, dynamic>>>(
            ordersRepository.getLatestOrder(userId), onData: (data) {
          return state.copyWith(data: data, loading: false);
        }, onError: (error, stackTrace) {
          return state.copyWith(loading: false);
        });
      } catch (e) {
        if (!emit.isDone) emit(state.copyWith(loading: false));
      }
    });

    on<createListProducts>((event, emit) async{
      final user = await dbHelper.getUser();
      final userId = user['usuario_id'] as int;
      final resume=await ordersRepository.loadOrder(state.products, userId);
      emit(state.copyWith(resume: resume, loading: false));
    });

    on<makeCall>((event, emit) async {
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

//