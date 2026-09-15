import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/asset_model.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final authService = AuthService();
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<AssetModel>>(
        stream: firestoreService.getAssets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load assets.'),
            );
          }

          final assets = snapshot.data ?? [];

          if (assets.isEmpty) {
            return const Center(
              child: Text('No assets available.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.location_city),
                  ),
                  title: Text(asset.location),
                  subtitle: Text(
                    'ID: ${asset.id}\n'
                    'Status: ${asset.status}\n'
                    'Lat: ${asset.latitude}, Lng: ${asset.longitude}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
