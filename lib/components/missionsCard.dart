import 'package:flutter/material.dart';
import 'package:test_orange2/models/missions.dart';
import 'package:test_orange2/views/missionListPage.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final String missionId;

  const MissionCard({Key? key, required this.mission, required this.missionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(mission.missionName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(mission.website),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
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
  }
}
