import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/main_button.dart';

class locationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => locationState();
}

class locationState extends State<locationView> {
  final MapController mapController = MapController();
  LatLng? initialCenter;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    findYourPosition();
  }

  Future<void> findYourPosition() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permiso cerrado.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permiso cerrado.');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).timeout(const Duration(seconds: 10));

      setState(() {
        initialCenter = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      print("Error obteniendo ubicación: $e");
      setState(() {
        initialCenter = LatLng(7.065612, -73.863979);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
              bg_color: colorsPalete['dark blue']!,
              shape_color: colorsPalete['orange']!)),
      body: isLoading
          ? Stack(
              children: [
                Container(
                    color: colorsPalete['orange'],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height),
                Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 6, color: colorsPalete['dark blue'])),
              ],
            )
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  initialCenter: initialCenter!,
                  initialZoom: 16,
                  interactionOptions:
                      InteractionOptions(flags: InteractiveFlag.all)),
              children: [mapLayer, MarkerLayer(markers: [
        Marker(
            point: LatLng(7.065612, -73.863979),
            height: 70,
            width: 160,
            rotate: true,
        child: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: colorsPalete['dark blue']!,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]),
            child: Text(
              'Restaurante principal',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            Icons.location_pin,
            color: colorsPalete['orange']!,
            size: 40,
          )
        ]))
              ])]),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Container(
          color: colorsPalete['orange'],
          child: Padding(
              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 7),
              child: CustomButton(
                  text: 'VOLVER',
                  onPressed: () {
                    Navigator.of(context).pop();
                  })),
        ),
      ),
    );
  }

  TileLayer get mapLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.dnv.dev.crispychikis');
}
