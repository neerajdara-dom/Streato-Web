import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/vendor.dart';
import '../services/vendor_service.dart';

class StreatoMapPage extends StatefulWidget {
  final double userLat;
  final double userLon;
  final Function(Vendor) onOpenStall; // ✅ ADD THIS

  const StreatoMapPage({
    super.key,
    required this.userLat,
    required this.userLon,
    required this.onOpenStall,
  });


  @override
  State<StreatoMapPage> createState() => _StreatoMapPageState();
}

class _StreatoMapPageState extends State<StreatoMapPage> {
  Vendor? hoveredVendor;
  List<Vendor> vendors = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadVendors();
  }

  Future<void> loadVendors() async {
    final all = await VendorService.getAllVendors();

    final userPos = LatLng(widget.userLat, widget.userLon);
    final Distance distance = Distance();

    // 🔥 Only stalls within 5 km
    final nearby = all.where((v) {
      final d = distance(
        userPos,
        LatLng(v.lat, v.lng),
      );
      return d <= 5000; // meters = 5km
    }).toList();

    setState(() {
      vendors = nearby;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final userPos = LatLng(widget.userLat, widget.userLon);

    return FlutterMap(
      options: MapOptions(
        initialCenter: userPos,
        initialZoom: 15,
        minZoom: 5,
        maxZoom: 19,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        // 🌍 STREET MAP TILE
        TileLayer(
          urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.streato.app',
        ),


        // 📏 DISTANCE LINES
        PolylineLayer(
          polylines: vendors.map((v) {
            return Polyline(
              points: [
                userPos,
                LatLng(v.lat, v.lng),
              ],
              color: Colors.amber.withOpacity(0.4),
              strokeWidth: 2,
            );
          }).toList(),
        ),

        // 📍 MARKERS
        MarkerLayer(
          markers: [
            // 🧍 USER MARKER
            Marker(
              point: userPos,
              width: 50,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),

            // 🍔 VENDOR MARKERS
            ...vendors.map((v) {
              final isHovered = hoveredVendor?.id == v.id;

              return Marker(
                point: LatLng(v.lat, v.lng),
                width: 160,
                height: 120,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() => hoveredVendor = v);
                  },
                  onExit: (_) {
                    setState(() => hoveredVendor = null);
                  },
                  child: GestureDetector(
                    onTap: () {
                      widget.onOpenStall(v); // ✅ OPEN STALL PAGE
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // 💬 HOVER CARD
                        if (isHovered)
                          Positioned(
                            bottom: 50,
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    v.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "⭐ ${v.rating}",
                                    style: const TextStyle(color: Colors.amber, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // 📍 PIN
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.restaurant, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

          ],
        ),
      ],
    );
  }
}
