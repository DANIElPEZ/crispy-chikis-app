import 'package:chispy_chikis/provider/provider.dart';
import 'package:chispy_chikis/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/components/appbar.dart';
import 'package:chispy_chikis/views/profile.dart';
import 'package:chispy_chikis/views/orders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadSupabase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_)=>crispyProvider())], child: MainView()));
  });
}

Future<void> loadSupabase()async{
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(url: dotenv.env['API_URL']??'',
      anonKey: dotenv.env['API_KEY']??'');
}

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  int indexView=1;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData()async{
    final crispy_provider=Provider.of<crispyProvider>(context, listen: false);
    await crispy_provider.checkConnection();
    await Future.delayed(Duration(microseconds: 900));
    await crispy_provider.fetchProducts();
    await crispy_provider.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                  bg_color: colorsPalete['dark blue']!,
                  shape_color: colorsPalete['orange']!)),
          bottomNavigationBar: NavigationBar(
              animationDuration: Duration(milliseconds: 400),
                onDestinationSelected: (int index){
                  setState(()=>indexView=index);
                },
                backgroundColor: colorsPalete['white'],
                selectedIndex: indexView,
                indicatorColor: Colors.transparent,
                destinations: [
                  NavigationDestination(icon: Icon(indexView==0?Icons.shopping_cart_rounded:Icons.shopping_cart_outlined, size: 34, color: indexView==0?colorsPalete['dark blue']:Colors.black), label: ''),
                  NavigationDestination(icon: Icon(indexView==1?Icons.home:Icons.home_outlined, size: 34, color: indexView==1?colorsPalete['dark blue']:Colors.black), label: ''),
                  NavigationDestination(icon: Icon(indexView==2?Icons.person:Icons.person_outline, size: 34, color: indexView==2?colorsPalete['dark blue']:Colors.black), label: '')
                ]),
          body: [Orders(),Home(),Profile()][indexView]
            )
      ),
    );
  }
}
