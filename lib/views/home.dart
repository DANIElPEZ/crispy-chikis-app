import 'package:crispychikis/views/home/menu.dart';
import 'package:flutter/material.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/views/profile/profile.dart';
import 'package:crispychikis/views/orders/orders.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class MainView extends StatefulWidget {
  MainView({required this.indexView});

  int indexView;

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late int indexView=widget.indexView;
  late PageController pageController;

  Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(androidId: 'com.dnv.dev.crispychikis');
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (context) => AlertDialog(
          backgroundColor: colorsPalete['dark brown'],
          title: Text(
            'Nueva version disponible.',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorsPalete['white'],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await newVersion.launchAppStore(
                  'https://play.google.com/store/apps/details?id=com.dnv.dev.crispychikis',
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: colorsPalete['dark blue'],
              ),
              child: Text(
                'Actualizar',
                style: GoogleFonts.nunito(
                  color: colorsPalete['white'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: indexView);
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                selectedIndex: indexView,
                indicatorColor: Colors.transparent,
                destinations: [
                  NavigationDestination(
                      icon: Icon(
                          indexView == 0
                              ? Icons.restaurant
                              : Icons.restaurant_outlined,
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
                Menu(),
                Profile()
              ],
            )
        ));
  }
}
