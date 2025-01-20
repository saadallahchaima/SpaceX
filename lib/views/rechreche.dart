import 'package:flutter/material.dart';
import 'package:test_orange2/components/launchCard.dart';
import 'package:test_orange2/components/missionsCard.dart';
import 'package:test_orange2/models/Launch.dart';
import 'package:test_orange2/models/missions.dart';
import 'package:test_orange2/services/launchService.dart';
import 'package:test_orange2/viewModels/launchViewModel.dart';
import 'package:test_orange2/viewModels/missionViewModel.dart';

class LaunchesAndMissionsPage extends StatefulWidget {
  const LaunchesAndMissionsPage({super.key});

  @override
  _LaunchesAndMissionsPageState createState() =>
      _LaunchesAndMissionsPageState();
}

class _LaunchesAndMissionsPageState extends State<LaunchesAndMissionsPage> {
  List<Mission> allMissions = [];
  List<Launch> allLaunches = [];
  List<Mission> filteredMissions = [];
  List<Launch> filteredLaunches = [];
  TextEditingController searchController = TextEditingController();
  final MissionViewModel _viewModel = MissionViewModel();
  final ApiService apiService = ApiService();
  late final LaunchViewModel launchViewModel;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    launchViewModel = LaunchViewModel(apiService: apiService);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final missions = await _viewModel.fetchMissions(context);
      final launches = await launchViewModel.fetchLaunches();

      setState(() {
        allMissions = missions;
        allLaunches = launches;
        filteredMissions = missions;
        filteredLaunches = launches;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterData(String query) {
    setState(() {
      filteredMissions = allMissions
          .where((mission) =>
              mission.missionName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredLaunches = allLaunches
          .where((launch) =>
              launch.missionName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text(
          'Missions et Lancements',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: searchController,
                onChanged: filterData,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search, color: Colors.orange),
                  hintText: 'Rechercher une mission ou un lancement',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredMissions.isEmpty && filteredLaunches.isEmpty)
              const Center(
                  child: const Text('Aucun résultat trouvé',
                      style: TextStyle(fontSize: 18))),
            if (filteredMissions.isNotEmpty || filteredLaunches.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: filteredMissions.length + filteredLaunches.length,
                  itemBuilder: (context, index) {
                    if (index < filteredMissions.length) {
                      return MissionCard(
                        mission: filteredMissions[index],
                        missionId: '',
                      );
                    } else {
                      return LaunchCard(
                          launch: filteredLaunches[
                          index - filteredMissions.length]
                          );
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
