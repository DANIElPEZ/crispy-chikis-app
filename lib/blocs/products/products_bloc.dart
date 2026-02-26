import 'package:bloc/bloc.dart';
import 'package:crispychikis/repository/products_repository.dart';
import 'package:crispychikis/blocs/products/products_state.dart';
import 'package:crispychikis/blocs/products/products_event.dart';

class ProductsBloc extends Bloc<ProductEvent, ProductsState>{
  final ProductsRepository productsRepository;

  ProductsBloc({required this.productsRepository}):super(ProductsState.initial()){
    on<loadProducts>((event, emit)async{
      emit(state.copyWith(loading: true));
      final products=await productsRepository.fetchProducts();
      final userExist=await productsRepository.getUser();
      emit(state.copyWith(loading: false, products: products, filteredProducts: products, userExist: userExist));
    });
    on<loadCommentsByProduct>((event, emit)async{
      final comments=await productsRepository.fecthCommentsByProduct(event.id);
      emit(state.copyWith(comments: comments));
    });
    on<searchProduct>((event, emit)async{
      final filterProducts=await productsRepository.searchProduct(event.query, state.products);
      emit(state.copyWith(filteredProducts: filterProducts));
    });
    on<canOrder>((event, emit)async{
      final canOrder=await productsRepository.getCurrentTime();
      final result=await productsRepository.getUser();
      emit(state.copyWith(canOrder: canOrder && result));
    });
  }
}