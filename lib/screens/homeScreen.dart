import 'package:flutter/material.dart';
import 'package:test_orange2/views/listeLaunch.dart';
import 'package:test_orange2/views/missionListPage.dart';
import 'package:test_orange2/views/rechreche.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isDark = false; // État pour gérer le mode sombre/claire
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Initialiser le TabController
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Orange',
      theme: themeData,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SpaceX',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          actions: [
            // Switch pour changer de mode
            Switch(
              value: isDark,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                });
              },
              activeColor: Colors.orange,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.orange,
            labelStyle: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            tabs: const <Widget>[
              Tab(
                icon: Icon(
                  Icons.rocket,
                  size: 30,
                  color: Colors.orange,
                ),
                text: 'Launches',
                iconMargin: EdgeInsets.only(bottom: 4),
              ),
              Tab(
                icon: Icon(
                  Icons.rocket_launch,
                  size: 30,
                  color: Colors.orange,
                ),
                text: 'Missions',
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.orange,
                ),
                text: 'Recherche',
                iconMargin: EdgeInsets.only(bottom: 4),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
             Center(child: Listelaunch()),
            Center(child: MissionListPage()),
            const Center(child: LaunchesAndMissionsPage()),
          ],
        ),
      ),
    );
  }
}
