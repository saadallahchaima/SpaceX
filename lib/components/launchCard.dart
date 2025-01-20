import 'package:flutter/material.dart';
import 'package:test_orange2/models/Launch.dart';
import 'package:test_orange2/views/listeLaunch.dart';

class LaunchCard extends StatelessWidget {
  final Launch launch;

  const LaunchCard({Key? key, required this.launch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(launch.missionName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('Year: ${launch.launchYear}'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaunchDetailsScreen(launchId: launch.id),
            ),
          );
        },
      ),
    );
  }
}
