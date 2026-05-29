import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_booking/models/place.dart';

class MapScreen extends StatefulWidget {
  final Place? place;

  const MapScreen({super.key, this.place});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Position? currentPosition;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
    _determinePosition();
  }

  void _setInitialMarkers() {
    if (widget.place != null && widget.place!.latitude != null && widget.place!.longitude != null) {
      markers.add(
        Marker(
          markerId: MarkerId(widget.place!.id),
          position: LatLng(widget.place!.latitude!, widget.place!.longitude!),
          infoWindow: InfoWindow(
            title: widget.place!.name,
            snippet: widget.place!.location,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
    
    _fitMarkers();
  }

  void _fitMarkers() {
    if (mapController == null || markers.isEmpty) return;

    if (markers.length == 1) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(markers.first.position, 14.0),
      );
    } else {
      LatLngBounds bounds;
      List<LatLng> positions = markers.map((m) => m.position).toList();
      
      double? minLat, maxLat, minLong, maxLong;
      
      for (var p in positions) {
        if (minLat == null || p.latitude < minLat) minLat = p.latitude;
        if (maxLat == null || p.latitude > maxLat) maxLat = p.latitude;
        if (minLong == null || p.longitude < minLong) minLong = p.longitude;
        if (maxLong == null || p.longitude > maxLong) maxLong = p.longitude;
      }
      
      bounds = LatLngBounds(
        southwest: LatLng(minLat!, minLong!),
        northeast: LatLng(maxLat!, maxLong!),
      );
      
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = const LatLng(10.7769, 106.7009); // Default to HCM city
    
    if (widget.place != null && widget.place!.latitude != null && widget.place!.longitude != null) {
      initialPosition = LatLng(widget.place!.latitude!, widget.place!.longitude!);
    } else if (currentPosition != null) {
      initialPosition = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place != null ? "Vị trí ${widget.place!.name}" : "Bản đồ"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          if (currentPosition != null || widget.place != null) {
             _fitMarkers();
          }
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 13.0,
        ),
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fitMarkers,
        backgroundColor: const Color(0xFF003580),
        child: const Icon(Icons.center_focus_strong, color: Colors.white),
      ),
    );
  }
}
