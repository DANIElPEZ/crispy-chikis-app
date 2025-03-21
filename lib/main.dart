import 'package:chispy_chikis/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/components/appbar.dart';
import 'package:chispy_chikis/views/profile.dart';
import 'package:chispy_chikis/views/orders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadSupabase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    //runApp(MultiProvider(providers: [], child: MainView()));
    runApp(MainView());
  });
}

Future<void> loadSupabase()async{

}

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  int indexView=0;

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
