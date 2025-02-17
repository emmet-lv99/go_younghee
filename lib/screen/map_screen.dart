import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.onSpeedChanged});

  final Function(double) onSpeedChanged;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late Position _position;
  bool _isPositionInitialized = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Check if permission is denied permanently
    if (permission == LocationPermission.deniedForever) {
      // Show a dialog or a message to the user explaining that they need to enable permissions
      // You can use a dialog or a snackbar to inform the user
      return false; // Permission denied permanently
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _initLocation() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

    _position = await Geolocator.getCurrentPosition();
    _isPositionInitialized = true;
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      // 위치 정보가 유효한지 확인
      if (position.latitude != 0.0 && position.longitude != 0.0) {
        _position = position;
        _updateCameraPosition(position);
        if (position.speed.isNaN || position.speed.isInfinite) {
          widget.onSpeedChanged(0.0);
        } else {
          widget.onSpeedChanged(position.speed);
        }
      } else {
        // 유효하지 않은 위치 정보 처리
        widget.onSpeedChanged(0.0); // 기본값 설정
      }
    });
  }

  Future<void> _updateCameraPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(
      LatLng(position.latitude, position.longitude),
    ));
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _checkLocationPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading map'));
          }
          if (snapshot.data == false) {
            return const Center(child: Text('Location permission denied'));
          }

          if (!_isPositionInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return GoogleMap(
            key: const ValueKey('google_map'),
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(_position.latitude, _position.longitude),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }
}
