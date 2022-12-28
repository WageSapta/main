import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:ekskul/constant/color.dart';
import 'package:ekskul/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GMap extends StatefulWidget {
  const GMap({Key? key}) : super(key: key);

  @override
  GMapState createState() => GMapState();
}

class GMapState extends State<GMap> {
  Position? mylocation;
  LatLng position = const LatLng(-8.155539, 113.435163);
  double distance = 0.0;
  double totalDistance = 0;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  final List<Marker> _markers = <Marker>[];
  final Completer<GoogleMapController> _mapController = Completer();

  void _setMarks() {
    List<LatLng> polygonLatLongs = <LatLng>[];
    polygonLatLongs.add(const LatLng(-8.156885, 113.434783));
    polygonLatLongs.add(const LatLng(-8.154985, 113.435674));
    polygonLatLongs.add(const LatLng(-8.154910, 113.435573));
    polygonLatLongs.add(const LatLng(-8.154741, 113.435701));
    polygonLatLongs.add(const LatLng(-8.154688, 113.435613));
    polygonLatLongs.add(const LatLng(-8.154829, 113.435514));
    polygonLatLongs.add(const LatLng(-8.154723, 113.435355));
    polygonLatLongs.add(const LatLng(-8.155534, 113.434804));
    polygonLatLongs.add(const LatLng(-8.155484, 113.434657));
    polygonLatLongs.add(const LatLng(-8.156016, 113.434397));
    polygonLatLongs.add(const LatLng(-8.156112, 113.434607));
    polygonLatLongs.add(const LatLng(-8.156673, 113.434335));

    _polygons.add(
      Polygon(
        polygonId: const PolygonId("1"),
        points: polygonLatLongs,
        fillColor: background.withOpacity(0.3),
        strokeWidth: 2,
        strokeColor: background,
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId("1"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: 'Lokasi Sekolah',
        ),
      ),
    );
    _markers.add(Marker(
      markerId: const MarkerId("2"),
      position: LatLng(mylocation!.latitude, mylocation!.longitude),
      infoWindow: const InfoWindow(
        title: 'Lokasi Saya',
      ),
    ));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    super.initState();
    mylocation = Provider.of<LocationProviderClass>(context).position;
    _setMarks();
    Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        setState(() {
          distance = calculateDistance(position.latitude, position.longitude,
              position.latitude, position.longitude);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18,
            ),
            polygons: _polygons,
            markers: Set<Marker>.of(_markers),
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.hybrid,
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 10),
                child: Material(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const SizedBox(height: 5),
                        distance != 0.0
                            ? Text(
                                "${distance.toStringAsFixed(2)} KM",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: background,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'Sekolah',
            heroTag: null,
            backgroundColor: Colors.white,
            onPressed: () async {
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 17,
              );

              final GoogleMapController controller =
                  await _mapController.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            },
            child: const Icon(
              Icons.location_city_rounded,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            tooltip: 'Saya',
            heroTag: null,
            backgroundColor: Colors.white,
            onPressed: () async {
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(mylocation!.latitude, mylocation!.longitude),
                zoom: 17,
              );

              final GoogleMapController controller =
                  await _mapController.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            },
            child: const Icon(
              Icons.my_location_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
