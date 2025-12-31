import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/batch_model.dart';
import 'batch_detail_screen.dart';

class MyBatchesScreen extends StatelessWidget {
  // --- यह लाइन सबसे ज़रूरी है ---
  const MyBatchesScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Batch>>(
        future: ApiService.fetchMyBatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final batches = snapshot.data ?? [];
          if (batches.isEmpty) return const Center(child: Text("No Enrolled Batches"));

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(batch.banner, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(batch.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("By ${batch.teacher}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => BatchDetailScreen(batch: batch))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}