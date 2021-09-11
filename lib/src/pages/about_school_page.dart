import 'dart:io';

import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:engelsburg_app/src/constants/asset_path_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutSchoolPage extends StatefulWidget {
  const AboutSchoolPage({Key? key}) : super(key: key);

  @override
  _AboutSchoolPageState createState() => _AboutSchoolPageState();
}

class _AboutSchoolPageState extends State<AboutSchoolPage> {
  final LatLng _engelsburgPosition = const LatLng(51.315228, 9.488160);
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.aboutTheSchool)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(AssetPaths.schoolImage),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Text(
              AppConstants.info,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
          const Text(AppConstants.schoolDescription),
          RichText(
              text: TextSpan(
                  text: AppConstants.source + ': ',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color),
                  children: [
                TextSpan(
                    text: AppConstants.schoolDescriptionSourceDomain,
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        url_launcher
                            .launch(AppConstants.schoolDescriptionSourceUrl);
                      })
              ])),
          const Padding(
            padding: EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Text(
              AppConstants.location,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: SizedBox(
              height: 250,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationButtonEnabled: false,
                liteModeEnabled: Platform.isAndroid,
                initialCameraPosition:
                    CameraPosition(target: _engelsburgPosition, zoom: 14.0),
                markers: {
                  Marker(
                    markerId: const MarkerId('0'),
                    position: _engelsburgPosition,
                    infoWindow: const InfoWindow(
                      title: AppConstants.schoolName,
                      snippet: AppConstants.schoolAddress,
                    ),
                  ),
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
          ),
          ListTile(
              leading: const Icon(Icons.phone),
              title: const Text(AppConstants.callPforte),
              onTap: () =>
                  url_launcher.launch('tel:' + AppConstants.pforteNumber)),
          ListTile(
              leading: const Icon(Icons.phone),
              title: const Text(AppConstants.callSekretariat),
              onTap: () =>
                  url_launcher.launch('tel:' + AppConstants.sekretariatNumber)),
          ListTile(
              leading: const Icon(Icons.mail),
              title: const Text(AppConstants.emailToSekretariat),
              onTap: () => url_launcher
                  .launch('mailto:' + AppConstants.sekretariatEmail)),
        ],
      ),
    );
  }
}
