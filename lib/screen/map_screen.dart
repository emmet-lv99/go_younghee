import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Function(double) onSpeedChanged;
  const MapScreen({super.key, required this.onSpeedChanged});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late Position _position;

  bool _isPositionInitialized = false;

  StreamSubscription<Position>? _positionStreamSubscription;

  Future<void> _initLocation() async {
    try {
      await _checkLocationPermission();
      _position = await Geolocator.getCurrentPosition();
      _isPositionInitialized = true;

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      );

      _positionStreamSubscription?.cancel();

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          if (!mounted) return;

          double speedKmh = 0;
          if (!position.speed.isNaN &&
              !position.speed.isInfinite &&
              position.speed >= 0) {
            speedKmh = double.parse((position.speed * 3.6).toStringAsFixed(2));
          }

          if (speedKmh < 0.5) {
            speedKmh = 0;
          }

          widget.onSpeedChanged(speedKmh);
        },
        onError: (error) {
          print('Position Stream error: $error');
        },
      );
    } catch (e) {
      print('Error in _initLocation: $e');
    }
  }

  Future<void> _checkLocationPermission() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      throw Exception('Location service is not enabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      throw Exception('Location permission denied');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: _initLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!_isPositionInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_position.latitude, _position.longitude),
                zoom: 17,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
