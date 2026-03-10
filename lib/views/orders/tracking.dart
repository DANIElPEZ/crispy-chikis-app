import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/main_button.dart';

class TrackingView extends StatefulWidget {
  const TrackingView({required this.userId});

  final int userId;

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {
  final MapController _mapController = MapController();
  final SupabaseClient _supabase = Supabase.instance.client;
  final ValueNotifier<LatLng?> _driverNotifier = ValueNotifier(null);
  LatLng? _destination;
  StreamSubscription<List<Map<String, dynamic>>>? _streamSub;
  static const LatLng _fallbackCenter = LatLng(7.0653, -73.8547);
  LatLng? _currentDriver;
  LatLng? _targetDriver;
  Timer? _animationTimer;
  LatLng? _lastRouteDriver;
  bool _hasDriver = false;
  final Distance _distance = const Distance();
  final ValueNotifier<List<LatLng>> _routeNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _fetchInitialOrderAndSubscribe();
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    _driverNotifier.dispose();
    super.dispose();
  }

  LatLng? _parseLatLng(dynamic lat, dynamic lng) {
    final latVal = double.tryParse(lat?.toString() ?? '');
    final lngVal = double.tryParse(lng?.toString() ?? '');

    if (latVal == null || lngVal == null) return null;
    if (latVal < -90 || latVal > 90) return null;
    if (lngVal < -180 || lngVal > 180) return null;

    return LatLng(latVal, lngVal);
  }

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/'
          '${start.longitude},${start.latitude};'
          '${end.longitude},${end.latitude}'
          '?overview=full&geometries=geojson';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;
        final route = coords.map((c) => LatLng(c[1], c[0])).toList();

        _routeNotifier.value = route;
      }
    } catch (e) {
      print("Route error $e");
    }
  }

  Future<void> _fetchInitialOrderAndSubscribe() async {
    try {
      final initialRes = await _supabase
          .from('ordenes')
          .select()
          .eq('usuario_id', widget.userId)
          .order('orden_id', ascending: false)
          .limit(1);

      if (initialRes.isNotEmpty) {
        final res = initialRes.first;

        final dest = _parseLatLng(
          res['latitud_destino'],
          res['longitud_destino'],
        );
        _destination = dest;

        final driver = _parseLatLng(
          res['latitud_envio'],
          res['longitud_envio'],
        );

        if (driver != null) {
          _driverNotifier.value = driver;
          if (_destination != null) {
            _fetchRoute(driver, _destination!);
          }
        }
      }

      final stream = _supabase
          .from('ordenes')
          .stream(primaryKey: ['orden_id'])
          .eq('usuario_id', widget.userId)
          .order('orden_id', ascending: false)
          .limit(1);

      _streamSub = stream.listen((data) {
        if (!mounted || data.isEmpty) return;
        final order = data.first;
        final driver = _parseLatLng(
          order['latitud_envio'],
          order['longitud_envio'],
        );

        if (driver != null) {
          final prev = _driverNotifier.value;
          if (prev == null ||
              prev.latitude != driver.latitude ||
              prev.longitude != driver.longitude) {
            _hasDriver = true;
            _animateDriver(driver);
            if (_destination != null) {
              if (_lastRouteDriver == null) {
                _lastRouteDriver = driver;
                _fetchRoute(driver, _destination!);
              } else {
                final meters = _distance(_lastRouteDriver!, driver);
                if (meters > 10) {
                  _lastRouteDriver = driver;
                  _fetchRoute(driver, _destination!);
                }
              }
            }
          }
        }

        final dest = _parseLatLng(
          order['latitud_destino'],
          order['longitud_destino'],
        );

        if (dest != null) {
          if (_destination == null ||
              _destination!.latitude != dest.latitude ||
              _destination!.longitude != dest.longitude) {
            _destination = dest;
            if (mounted) setState(() {});
          }
        }
      }, onError: (err) {
        print("Realtime error: $err");
      });
    } catch (e) {
      print("Error fetch inicial: $e");
    } finally {
      if (mounted) setState(() {});
    }
  }

  void _animateDriver(LatLng newPosition) {
    if (_currentDriver == null) {
      _currentDriver = newPosition;
      _driverNotifier.value = newPosition;
      return;
    }

    _targetDriver = newPosition;
    _animationTimer?.cancel();

    const steps = 25;
    int step = 0;
    final start = _currentDriver!;
    final end = _targetDriver!;

    _animationTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      step++;

      final lat =
          start.latitude + (end.latitude - start.latitude) * (step / steps);
      final lng =
          start.longitude + (end.longitude - start.longitude) * (step / steps);
      final pos = LatLng(lat, lng);
      _driverNotifier.value = pos;
      _currentDriver = pos;

      if (step >= steps) {
        timer.cancel();
        _currentDriver = end;
        _driverNotifier.value = end;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          bg_color: colorsPalete['dark blue']!,
          shape_color: colorsPalete['orange']!,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Container(
          color: colorsPalete['orange'],
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 7),
            child: CustomButton(
              text: 'VOLVER',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _destination != null
              ? FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _destination!,
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.crispychikis.app',
                    ),
                    if (_destination != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            rotate: true,
                            point: _destination!,
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on,
                              color: colorsPalete['orange'],
                              size: 40,
                            ),
                          )
                        ],
                      ),
                    ValueListenableBuilder<LatLng?>(
                      valueListenable: _driverNotifier,
                      builder: (context, driverLoc, _) {
                        if (driverLoc == null) return SizedBox();
                        return MarkerLayer(
                          markers: [
                            Marker(
                              rotate: true,
                              point: driverLoc,
                              width: 160,
                              height: 80,
                              child: Column(
                                children: [
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
                                      'Tu pedido',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.motorcycle,
                                    color: colorsPalete['orange'],
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    ValueListenableBuilder<List<LatLng>>(
                      valueListenable: _routeNotifier,
                      builder: (context, route, _) {
                        if (route.isEmpty) return SizedBox();

                        return PolylineLayer(
                          polylines: [
                            Polyline(
                              points: route,
                              strokeWidth: 5,
                              color: Colors.blue,
                            )
                          ],
                        );
                      },
                    )
                  ],
                )
              : Container(
                  color: colorsPalete['orange'],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 6, color: colorsPalete['dark blue']))),
          ValueListenableBuilder<LatLng?>(
            valueListenable: _driverNotifier,
            builder: (context, driverLoc, _) {
              if (driverLoc == null) {
                return Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    color: colorsPalete['dark blue'],
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: colorsPalete['orange']),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Esperando al repartidor',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
