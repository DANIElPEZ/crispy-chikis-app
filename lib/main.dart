import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/views/home.dart';
import 'package:crispychikis/repository/profile_repository.dart';
import 'package:crispychikis/repository/make_order_repository.dart';
import 'package:crispychikis/repository/orders_repository.dart';
import 'package:crispychikis/repository/products_repository.dart';
import 'package:crispychikis/blocs/profile/profile_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_bloc.dart';
import 'package:crispychikis/blocs/orders/orders_bloc.dart';
import 'package:crispychikis/blocs/products/products_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadSupabase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Main());
  });
}

Future<void> loadSupabase() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
      url: dotenv.env['API_URL'] ?? '', anonKey: dotenv.env['API_KEY'] ?? '');
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductsRepository>(
            create: (context) => ProductsRepository()),
        RepositoryProvider<OrdersRepository>(
            create: (context) => OrdersRepository()),
        RepositoryProvider<MakeOrderRepository>(
            create: (context) => MakeOrderRepository()),
        RepositoryProvider<ProfileRepository>(
            create: (context) => ProfileRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductsBloc>(
              create: (context) => ProductsBloc(
                  productsRepository:
                      RepositoryProvider.of<ProductsRepository>(context))),
          BlocProvider<OrdersBloc>(
              create: (context) => OrdersBloc(
                  ordersRepository:
                      RepositoryProvider.of<OrdersRepository>(context))),
          BlocProvider<MakeOrderBloc>(
              create: (context) => MakeOrderBloc(
                  makeOrderRepository:
                      RepositoryProvider.of<MakeOrderRepository>(context))),
          BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(
                  profileRepository:
                      RepositoryProvider.of<ProfileRepository>(context))),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.noScaling),
                    child: SafeArea(child: child!));
              },
              home: MainView(indexView: 1));
        }),
      ),
    );
  }
}
