import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/slaughterhouse_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;

  LatLng _currentCenter = LatLng(51.1657, 10.4515); // Default center for Germany
  double _currentZoom = 6.0; // Default initial zoom

  String? _selectedName;
  String? _selectedDetails;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    Provider.of<SlaughterhouseProvider>(context, listen: false).loadData();
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
    });
    _mapController.move(_currentCenter, _currentZoom);
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
    });
    _mapController.move(_currentCenter, _currentZoom);
  }

  void _showInfoCard(
      String name,
      String street,
      String postalCode,
      String city,
      String district,
      String state,
      String category,
      String activities,
      String species,
      String notes,
      ) {
    setState(() {
      _selectedName = name;
      _selectedDetails = '''
Adresse: $street
Postleitzahl: $postalCode
Stadt: $city
Landkreis: $district
Bundesland: $state
Kategorie: ${_expandCategory(category)}
Weitere Aktivitäten: ${_expandActivities(activities)}
Tierarten: ${_expandSpecies(species)}
Bemerkungen: ${notes.isEmpty ? "Keine" : notes}
''';
    });
  }

  String _expandCategory(String category) {
    // Expand category abbreviations
    return category
        .replaceAll("CP", "Zerlegungsbetrieb")
        .replaceAll("SH", "Schlachthof");
  }

  String _expandActivities(String activities) {
    return activities
        .replaceAll("XIII(PP)", "Kategorie XIII (Verarbeitungsbetrieb für behandelte Mägen, Blasen und Därme)")
        .replaceAll("II(SH)", "Kategorie II (Schlachthof für Geflügel und Hasentiere)")
        .replaceAll("II(CP)", "Kategorie II (Zerlegebetrieb für Geflügel und Hasentiere)")
        .replaceAll("III(SH)", "Kategorie III (Schlachthof für Farmwild)")
        .replaceAll("III(CP)", "Kategorie III (Zerlegebetrieb für Farmwild)")
        .replaceAll("IV(GHE)", "Kategorie IV (Wildbearbeitungsbetrieb)")

        .replaceAll("IV(CP)", "Kategorie IV (Zerlegebetrieb für Wild)")
        .replaceAll("V(MM)", "Kategorie V (Betrieb für Hackfleisch)")
        .replaceAll("V(MP)", "Kategorie V (Betrieb für Fleischzubereitungen)")
        .replaceAll("VI(PP)", "Kategorie VI (Verarbeitungsbetrieb für Fleischerzeugnisse)")
        .replaceAll("VIII(PP)", "Kategorie VIII (Verarbeitungsbetrieb für Fischerzeugnisse)")
        .replaceAll("X(PP)", "Kategorie X (Verarbeitungsbetrieb für Eier und Eiprodukte)")
        .replaceAll("X(EPC)", "Kategorie X (Eierpackstelle)")
        .replaceAll("XII(PP)", "Kategorie XII (Verarbeitungsbetrieb für geschmolzene tierische Fette und Grieben)")
        .replaceAll("0(CS)", "Kategorie 0 (Kühlhaus)")
        .replaceAll("0(RW)", "Kategorie 0 (Betrieb für Umpacken und Neuverpacken)")
        .replaceAll("0(WM)", "Kategorie 0 (Großhandelsmarkt)");
  }




  String _expandSpecies(String species) {
    // Expand species abbreviations
    return species
        .replaceAll("B", "Rinder")
        .replaceAll("P", "Schweine")
        .replaceAll("C", "Ziegen")
        .replaceAll("O", "Schafe")
        .replaceAll("S", "Einhufer");
  }



  @override
  Widget build(BuildContext context) {
    final slaughterhouses = Provider.of<SlaughterhouseProvider>(context).slaughterhouses;

    if (slaughterhouses.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // Define markers with dialogs for popups
    List<Marker> markers = slaughterhouses.map((sh) {
      return Marker(
        point: LatLng(sh.latitude, sh.longitude),
        width: 40.0,
        height: 40.0,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentCenter = LatLng(sh.latitude, sh.longitude);
              _currentZoom = 17.0; // Street-level zoom
            });
            _mapController.move(_currentCenter, _currentZoom);
            _showInfoCard(
              sh.name,
              sh.street,
              sh.postalCode,
              sh.city,
              sh.district,
              sh.state,
              sh.category,
              sh.activities,
              sh.species,
              sh.notes,
            );
          },
          child: Icon(Icons.location_on, color: Colors.red, size: 40),
        ),

      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Schlachthöfe in Deutschland")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: _currentZoom,
              onPositionChanged: (position, hasGesture) {
                // Update current center and zoom when the map is moved or zoomed
                setState(() {
                  _currentCenter = position.center;
                  _currentZoom = position.zoom;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: Size(50, 50),
                  markers: markers,
                  builder: (context, clusterMarkers) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          '${clusterMarkers.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  onClusterTap: (cluster) {
                    List<LatLng> points = cluster.markers.map((marker) => marker.point).toList();

                    // Calculate bounds for all points in the cluster
                    final bounds = LatLngBounds.fromPoints(points);

                    // Calculate the map center (midpoint of bounds)
                    final center = LatLng(
                      (bounds.northEast.latitude + bounds.southWest.latitude) / 2,
                      (bounds.northEast.longitude + bounds.southWest.longitude) / 2,
                    );

                    if (points.length <= 5) {
                      // Final cluster: Fit all markers with manual zoom adjustment
                      double latDiff = bounds.northEast.latitude - bounds.southWest.latitude;
                      double lngDiff = bounds.northEast.longitude - bounds.southWest.longitude;

                      // Adjust zoom level dynamically based on bounds size
                      double zoomAdjustment = 20.0; // Add padding
                      double estimatedZoom = _currentZoom;

                      if (latDiff > 0.5 || lngDiff > 0.5) {
                        estimatedZoom -= zoomAdjustment; // Zoom out for larger bounds
                      } else {
                        estimatedZoom += zoomAdjustment; // Zoom in for smaller bounds
                      }

                      setState(() {
                        _currentCenter = center;
                        _currentZoom = estimatedZoom;
                      });
                      _mapController.move(_currentCenter, _currentZoom);
                    } else {
                      // Normal cluster zoom behavior
                      double estimatedZoom = _currentZoom + 2.0; // Zoom in dynamically

                      setState(() {
                        _currentCenter = center;
                        _currentZoom = estimatedZoom;
                      });
                      _mapController.move(_currentCenter, _currentZoom);
                    }
                  },



                ),
              ),
            ],
          ),
          // Floating info card in the upper-left corner
          if (_selectedName != null && _selectedDetails != null)
            Positioned(
              top: 20,
              left: 20,
              child: Card(
                elevation: 5,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 250, // Minimum width for the card
                    maxWidth: 300, // Maximum width for the card
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedName!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(_selectedDetails!),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedName = null;
                              _selectedDetails = null;
                            });
                          },
                          child: Text("Schließen"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
,
          // Floating action buttons for zoom controls
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  tooltip: 'Zoom In',
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  tooltip: 'Zoom Out',
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
