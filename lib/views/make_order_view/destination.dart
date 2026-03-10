import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_event.dart';
import 'package:crispychikis/blocs/make_order/make_order_state.dart';

class destinationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => destinationState();
}

class destinationState extends State<destinationView> {
  final MapController mapController = MapController();
  LatLng? initialCenter;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    findYourPosition();
  }

  void onMapTap(TapPosition tapPosition, LatLng point) {
    context.read<MakeOrderBloc>().add(setDestination(point: point));
  }

  Future<void> findYourPosition()async{
    try{
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied){
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
        initialCenter=LatLng(position.latitude, position.longitude);
        isLoading=false;
      });
    }catch(e){
      print("Error obteniendo ubicación: $e");
      setState(() {
        initialCenter=LatLng(7.065612, -73.863979);
        isLoading=false;
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
        body: BlocBuilder<MakeOrderBloc, MakeOrderState>(
            builder: (context, state) {
          final bool hasDestination =
              state.latitude != 0 && state.longitude != 0;
          final LatLng? selectedPoint =
              hasDestination ? LatLng(state.latitude, state.longitude) : null;
          return Stack(
            children: [
              isLoading?Stack(
                children: [
                  Container(
                      color: colorsPalete['orange'],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height),
                  Center(child: CircularProgressIndicator(strokeWidth: 6, color: colorsPalete['dark blue'])),
                ],
              ):FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      initialCenter: initialCenter!,
                      initialZoom: 16,
                      interactionOptions:
                          InteractionOptions(flags: InteractiveFlag.all),
                      onTap: onMapTap),
                  children: [
                    mapLayer,
                    if (selectedPoint != null)
                      MarkerLayer(markers: [
                        Marker(
                            point: selectedPoint,
                            width: 60,
                            height: 70,
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
                                  'Destino',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
                      ])
                  ]),
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: colorsPalete['dark blue']!.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app,
                          color: colorsPalete['orange']!, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Toca el mapa para seleccionar tu destino',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasDestination && selectedPoint != null)
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, -4),
                            )
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: colorsPalete['orange']!, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'Destino seleccionado',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: colorsPalete['dark blue'],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: state.loading
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: colorsPalete['orange'],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text('Obteniendo dirección...',
                                                style: TextStyle(
                                                    color: Colors.grey[600])),
                                          ],
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Icon(Icons.map_outlined,
                                                  size: 18,
                                                  color: Colors.grey[600]),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  state.address.isNotEmpty
                                                      ? state.address
                                                      : 'Dirección no disponible',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ])),
                              Padding(
                                padding: EdgeInsets.only(top: 6, left: 2),
                                child: Text(
                                  'Lat: ${selectedPoint.latitude.toStringAsFixed(6)}  '
                                  'Lng: ${selectedPoint.longitude.toStringAsFixed(6)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              SizedBox(height: 14),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorsPalete['orange'],
                                        foregroundColor: Colors.white,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: state.loading
                                          ? null
                                          : () => Navigator.of(context).pop(),
                                      child: Text('CONFIRMAR DESTINO',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))))
                            ])))
            ],
          );
        }),
        bottomNavigationBar: Builder(builder: (context) {
          final hasDestination = context.select<MakeOrderBloc, bool>(
              (bloc) => bloc.state.latitude != 0 && bloc.state.longitude != 0);
          return hasDestination
              ? SizedBox.shrink()
              : SizedBox(
                  height: 90,
                  child: Container(
                    color: colorsPalete['orange'],
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 20, left: 20, right: 20, top: 7),
                        child: CustomButton(
                            text: 'VOLVER',
                            onPressed: () => Navigator.of(context).pop())),
                  ),
                );
        }));
  }

  TileLayer get mapLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.dnv.dev.crispychikis');
}
