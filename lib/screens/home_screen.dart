import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../configs/app_config.dart';
import '../services/api_service.dart';
import '../models/batch_model.dart';

// सभी जरूरी स्क्रीन इम्पोर्ट करें
import 'batch_detail_screen.dart';
import 'test_list_screen.dart';
import 'all_classes_screen.dart';
import 'ask_doubt_screen.dart';
import 'khazana_screen.dart';
import 'my_batches_screen.dart';
import 'my_downloads_screen.dart';
import 'study_material_screen.dart';
import 'video_player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. डार्क हेडर (PW Style) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("YOUR BATCH", 
                    style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  SizedBox(height: 8),
                  Text("MISSION 30 PRO BATCH", 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // --- 2. मूविंग बैनर स्लाइडर (Dynamic) ---
            const SizedBox(height: 25),
            _buildBannerSlider(),

            // --- 3. क्विक एक्शन ग्रिड (Fully Functional Icons) ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _pwIcon(context, Icons.menu_book, "Classes", Colors.blue, () async {
                    var myBatches = await ApiService.fetchMyBatches();
                    if (myBatches.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => AllClassesScreen(batch: myBatches.first)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Join a batch first!")));
                    }
                  }),
                  _pwIcon(context, Icons.assignment, "Tests", Colors.green, 
                    () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TestListScreen()))),
                  _pwIcon(context, Icons.help_center, "Doubts", Colors.purple, 
                    () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AskDoubtScreen()))),
                  _pwIcon(context, Icons.auto_awesome, "Khazana", Colors.orange, 
                    () => Navigator.push(context, MaterialPageRoute(builder: (c) => const KhazanaScreen()))),
                ],
              ),
            ),

            // --- 4. अपकमिंग / लाइव क्लासेस सेक्शन (बैनर कार्ड्स के साथ) ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Upcoming Classes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildUpcomingClasses(context),

            // --- 5. My Study Zone ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Text("My Study Zone", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _zoneCard(context, Icons.school, "My Batches", const MyBatchesScreen()),
                _zoneCard(context, Icons.download_for_offline, "Downloads", const MyDownloadsScreen()),
                _zoneCard(context, Icons.library_books, "Library", const StudyMaterialScreen()),
              ],
            ),

            // --- 6. उपलब्ध बैच लिस्ट (Real Firebase Data) ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text("Available Batches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            FutureBuilder<List<Batch>>(
              future: ApiService.fetchBatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text("No Batches Found."),
                  ));
                }

                final batches = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: batches.length,
                  itemBuilder: (context, index) {
                    return _buildPremiumCard(context, batches[index], primaryColor);
                  },
                );
              },
            ),
            
            const SizedBox(height: 40),
            const Center(
              child: Text("VISTER TECHNOLOGIES", 
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 2.5, fontSize: 12)),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- १. लाइव क्लास विजेट (प्रोफेशनल बैनर कार्ड लुक) ---
  Widget _buildUpcomingClasses(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('live_classes')
          .where('instituteId', isEqualTo: AppConfig.instituteId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No live classes scheduled today.", style: TextStyle(color: Colors.grey)),
          );
        }

        final liveDocs = snapshot.data!.docs;

        return SizedBox(
          height: 200, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: liveDocs.length,
            itemBuilder: (context, index) {
              var liveData = liveDocs[index].data() as Map<String, dynamic>;
              bool isLive = liveData['status'] == 'live';

              return Container(
                width: 320,
                margin: const EdgeInsets.only(right: 15, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                          child: Image.network(
                            liveData['thumbnail'] ?? "https://pwaadcontent.azureedge.net/general/lakshya_batch.png",
                            height: 120, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (c,e,s) => Container(color: Colors.blueGrey, height: 120),
                          ),
                        ),
                        if (isLive)
                          Positioned(
                            top: 10, left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                              child: const Text("🔴 LIVE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(liveData['topic'] ?? "Live Session", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(isLive ? "Started Now" : "Scheduled Soon", style: TextStyle(color: isLive ? Colors.red : Colors.grey, fontSize: 11)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final String url = liveData['playbackUrl'] ?? "";
                              if (url.isNotEmpty) {
                                if (isLive && (url.contains('.m3u8') || liveData['type'] == 'hls')) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(videoUrl: url, title: liveData['topic'])
                                  ));
                                } else {
                                  final Uri uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLive ? Colors.red : Colors.blue,
                              shape: const StadiumBorder(), elevation: 0,
                            ),
                            child: Text(isLive ? "JOIN" : "DETAILS", style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --- २. उपलब्ध कोर्सेस के कार्ड ---
  Widget _buildPremiumCard(BuildContext context, Batch batch, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              batch.banner,
              height: 160, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.grey[100], height: 160, child: const Icon(Icons.play_circle_fill, size: 50, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(batch.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("By ${batch.teacher}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BatchDetailScreen(batch: batch))),
                      child: Text("DETAILS", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool success = await ApiService.enrollInBatch(batch.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? "Enrolled Successfully!" : "Enrollment Failed!"), backgroundColor: success ? Colors.green : Colors.red),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: color, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 25)),
                      child: const Text("ENROLL NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- ३. बैनर इंजन ---
  Widget _buildBannerSlider() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('banners').where('instituteId', isEqualTo: AppConfig.instituteId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox(height: 10);
        return CarouselSlider(
          options: CarouselOptions(height: 150, autoPlay: true, enlargeCenterPage: true, viewportFraction: 0.9),
          items: snapshot.data!.docs.map((doc) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(doc['imageUrl'], fit: BoxFit.cover, width: double.infinity, 
                errorBuilder: (c, e, s) => Container(color: Colors.grey[200], child: const Icon(Icons.image))),
            );
          }).toList(),
        );
      },
    );
  }

  // --- ४. हेल्पर्स ---
  Widget _pwIcon(BuildContext context, IconData icon, String label, Color color, Function()? onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(50), child: Column(children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ]));
  }

  Widget _zoneCard(BuildContext context, IconData icon, String label, Widget targetPage) {
    return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => targetPage)), borderRadius: BorderRadius.circular(15), child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(15)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: Colors.blue.shade400, size: 32),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ]),
    ));
  }
}