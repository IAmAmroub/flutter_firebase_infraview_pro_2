import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/asset_model.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import 'work_log_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _locationService = LocationService();

  LatLng? _currentLocation;
  bool _isLoadingLocation = true;
  String? _locationError;

  @override
  void initState() {
    _loadCurrentLocation();
    super.initState();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(
          position.latitude,
          position.longitude,
        );

        _isLoadingLocation = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _locationError = error.toString();
        _isLoadingLocation = false;
      });
    }
  }

  Set<Marker> _createAssetMarkers(List<AssetModel> assets) {
    return assets.map((asset) {
      return Marker(
        markerId: MarkerId(asset.id),
        position: LatLng(
          asset.latitude,
          asset.longitude,
        ),
        infoWindow: InfoWindow(
          title: asset.location,
          snippet: 'Status: ${asset.status}',
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.fingerprint),
            onPressed: () async {
              final authenticated = await BiometricService().authenticate();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    authenticated
                        ? 'Biometric authentication successful.'
                        : 'Biometric authentication failed.',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            tooltip: 'Work Log',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WorkLogScreen(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () async {
              await _authService.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoadingLocation) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_locationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _locationError!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _locationError = null;
                    _isLoadingLocation = true;
                  });

                  _loadCurrentLocation();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    final currentLocation = _currentLocation;

    if (currentLocation == null) {
      return const Center(
        child: Text('Current location is unavailable.'),
      );
    }

    return StreamBuilder<List<AssetModel>>(
      stream: _firestoreService.getAssets(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load asset locations.'),
          );
        }

        final assets = snapshot.data ?? [];
        final markers = _createAssetMarkers(assets);

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation,
            zoom: 14,
          ),
          markers: markers,

          // Requires location permission.
          myLocationEnabled: true,

          // Displays Google's current-location button.
          myLocationButtonEnabled: true,

          zoomControlsEnabled: true,
        );
      },
    );
  }
}
