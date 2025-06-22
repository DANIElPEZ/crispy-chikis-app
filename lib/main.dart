import 'package:crispychikis/provider/provider.dart';
import 'package:crispychikis/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/views/profile.dart';
import 'package:crispychikis/views/orders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadSupabase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => crispyProvider())],
        child: MainView(indexView: 1)));
  });
}

Future<void> loadSupabase() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
      url: dotenv.env['API_URL'] ?? '', anonKey: dotenv.env['API_KEY'] ?? '');
}

class MainView extends StatefulWidget {
  MainView({required this.indexView});

  int indexView;

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  int? indexView;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    indexView = widget.indexView;
    pageController = PageController(initialPage: indexView!);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeData();
    });
  }

  Future<void> initializeData() async {
    final crispy_provider = Provider.of<crispyProvider>(context, listen: false);
    await crispy_provider.checkConnection();
    await Future.delayed(Duration(microseconds: 900));
    await crispy_provider.fetchProducts();
    await crispy_provider.loadUser();
    await crispy_provider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: CustomAppBar(
                      bg_color: colorsPalete['dark blue']!,
                      shape_color: colorsPalete['orange']!)),
              bottomNavigationBar: NavigationBar(
                  animationDuration: Duration(milliseconds: 400),
                  onDestinationSelected: (int index) {
                    setState(() => indexView = index);
                    pageController.animateToPage(index,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  backgroundColor: colorsPalete['white'],
                  selectedIndex: indexView!,
                  indicatorColor: Colors.transparent,
                  destinations: [
                    NavigationDestination(
                        icon: Icon(
                            indexView == 0
                                ? Icons.shopping_cart_rounded
                                : Icons.shopping_cart_outlined,
                            size: 34,
                            color: indexView == 0
                                ? colorsPalete['dark blue']
                                : Colors.black),
                        label: ''),
                    NavigationDestination(
                        icon: Icon(
                            indexView == 1 ? Icons.home : Icons.home_outlined,
                            size: 34,
                            color: indexView == 1
                                ? colorsPalete['dark blue']
                                : Colors.black),
                        label: ''),
                    NavigationDestination(
                        icon: Icon(
                            indexView == 2
                                ? Icons.person
                                : Icons.person_outline,
                            size: 34,
                            color: indexView == 2
                                ? colorsPalete['dark blue']
                                : Colors.black),
                        label: '')
                  ]),
              body: PageView(
                controller: pageController,
                onPageChanged: (int index) {
                  setState(() => indexView = index);
                },
                children: [
                  Orders(),
                  Home(),
                  Profile()
                ],
              )
          )),
    );
  }
}
