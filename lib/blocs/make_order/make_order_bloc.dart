import 'package:bloc/bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_state.dart';
import 'package:crispychikis/blocs/make_order/make_order_event.dart';
import 'package:crispychikis/repository/make_order_repository.dart';
import 'package:crispychikis/utils/utils.dart';

class MakeOrderBloc extends Bloc<MakeOrderEvent, MakeOrderState> {
  final MakeOrderRepository makeOrderRepository;

  MakeOrderBloc({required this.makeOrderRepository})
      : super(MakeOrderState.initial()) {
    on<MakeOrder>((event, emit) async {
      emit(state.copyWith(isMaked: false, orderError: false));
      try {
        if (sanitizeDescription(event.aditional_description) &&
            (await makeOrderRepository.getCurrentTime())) {
          await makeOrderRepository.MakeOrder(
              state.address,
              event.metodoPago,
              event.aditional_description,
              state.productsOrder,
              state.total,
              state.latitude,
              state.longitude);
          emit(state.copyWith(
              isMaked: true,
              orderError: false,
              totalWithoutIva: 0,
              iva: 0,
              total: 0,
              productsOrder: []));
          return;
        }
        throw Exception('Condicion incorrecta.');
      } catch (e) {
        emit(state.copyWith(isMaked: false, orderError: true));
      }
    });
    on<AddProduct>((event, emit) async {
      final newListProducts = await makeOrderRepository.addProduct(
          event.id, event.title, event.price, state.productsOrder);
      emit(state.copyWith(productsOrder: newListProducts));
    });
    on<DeleteProduct>((event, emit) async {
      final newListProducts = await makeOrderRepository.deleteProduct(
          event.id, state.productsOrder);
      emit(state.copyWith(productsOrder: newListProducts));
    });
    on<CalculateTotal>((event, emit) async {
      final values =
          await makeOrderRepository.calculateTotal(state.productsOrder);
      emit(state.copyWith(
          total: values[0], iva: values[1], totalWithoutIva: values[2]));
    });
    on<loadProducts>((event, emit) async {
      emit(state.copyWith(loading: true));
      final products = await makeOrderRepository.fetchProducts();
      emit(state.copyWith(
          products: products, filteredProducts: products, loading: false));
    });
    on<searchProduct>((event, emit) async {
      final filterProducts =
          await makeOrderRepository.searchProduct(event.query, state.products);
      emit(state.copyWith(filteredProducts: filterProducts));
    });
    on<setDestination>((event, emit) async {
      emit(state.copyWith(loading: true));
      final address = await makeOrderRepository.getAddress(event.point);
      emit(state.copyWith(
          address: address,
          latitude: event.point.latitude,
          longitude: event.point.longitude,
          loading: false));
    });
  }
}
