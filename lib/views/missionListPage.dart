import 'package:flutter/material.dart';
import 'package:test_orange2/models/missions.dart';
import 'package:test_orange2/utils/missionDatabaseHelper.dart';
import 'package:test_orange2/viewModels/missionViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionListPage extends StatelessWidget {
  final MissionViewModel _viewModel = MissionViewModel();
  final MissionDatabaseHelper missionsDataHelper = MissionDatabaseHelper();
  MissionListPage({super.key});

  Future<void> _saveMission(Mission mission, BuildContext context) async {
    try {
      await missionsDataHelper.insertMission(mission);
    } catch (e) {
      //print('Erreur lors de la sauvegarde: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missions'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Mission>>(
        future: _viewModel.fetchMissions(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorScreen(context, snapshot.error);
          }
          final missions = snapshot.data ?? [];

          return ListView.builder(
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(Icons.flight_takeoff,
                      size: 40, color: Colors.orange),
                  title: Text(mission.missionName ?? 'No Name',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(mission.website ?? "Website Unknown"),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MissionDetailPage(missionId: mission.missionId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MissionDetailPage extends StatelessWidget {
  final String missionId;

  MissionDetailPage({required this.missionId});

  final MissionViewModel _viewModel = MissionViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Details'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Mission?>(
        future: _viewModel.fetchMissionById(missionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorScreen(context, snapshot.error);
          }
          final mission = snapshot.data;
          if (mission == null) {
            return const Center(child: Text('Mission not found'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    mission.missionName ?? 'No Name',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  const SizedBox(height: 16),
                  mission.website.isNotEmpty
                      ? _buildLinkRow('Website', mission.website)
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 16,
                    width: 20,
                  ),
                  Text(
                    mission.description ?? 'Description not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  mission.wikipedia.isNotEmpty
                      ? _buildLinkRow('Wikipedia', mission.wikipedia)
                      : const SizedBox.shrink(),
                  mission.twitter.isNotEmpty
                      ? _buildLinkRow('Twitter', mission.twitter)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinkRow(String label, String url) {
    return Row(
      children: [
        const Icon(Icons.link, color: Colors.orange),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => _launchURL(url),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.orange,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Widget _buildErrorScreen(BuildContext context, dynamic error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.signal_wifi_off,
          size: 80,
          color: Colors.orange,
        ),
        const SizedBox(height: 16),
        const Text(
          "No connection detected. Please check your network and try again.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MissionListPage()),
            );
          },
          child: const Text("Retry"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
      ],
    ),
  );
}
