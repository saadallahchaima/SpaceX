import 'package:flutter/material.dart';
import 'package:test_orange2/components/cell.dart';
import 'package:test_orange2/models/Launch.dart';
import 'package:test_orange2/services/launchService.dart';
import 'package:test_orange2/viewModels/launchViewModel.dart';
class Listelaunch extends StatelessWidget {
  final ApiService apiService = ApiService();
  late final LaunchViewModel launchViewModel;

  Listelaunch({super.key}) {
    launchViewModel = LaunchViewModel(apiService: apiService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launches'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Launch>>(
        future: launchViewModel.fetchLaunches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString(), context);
          }

          final launches = snapshot.data ?? [];
          if (launches.isEmpty) {
            return const Center(child: Text('No launches available'));
          }

          return ListView.builder(
            itemCount: launches.length,
            itemBuilder: (context, index) {
              final launch = launches[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LaunchDetailsScreen(launchId: launch.id),
                    ),
                  );
                },
                child: Cell(launch),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String errorMessage, BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            'Oops, something went wrong: $errorMessage',
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class LaunchDetailsScreen extends StatelessWidget {
  final int launchId;
  final LaunchViewModel _viewModel;

  LaunchDetailsScreen({
    Key? key,
    required this.launchId,
  })  : _viewModel = LaunchViewModel(apiService: ApiService()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<Launch?>(
        future: _viewModel.fetchLaunchDetails(launchId),
        builder: (context, snapshot) {
          return _buildBody(snapshot, theme);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Mission Details'),
      backgroundColor: Colors.orange,
    );
  }

  Widget _buildBody(AsyncSnapshot<Launch?> snapshot, ThemeData theme) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoadingView();
    }

    if (snapshot.hasError) {
      return _buildErrorView(snapshot.error.toString(), theme);
    }

    final launch = snapshot.data;
    if (launch == null) {
      return _buildNotFoundView();
    }

    return _buildLaunchDetailsView(launch, theme);
  }

  Widget _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorView(String errorMessage, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            'Oops, something went wrong:\n$errorMessage',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Add retry logic
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundView() {
    return const Center(
      child: Text(
        'Launch not found',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildLaunchDetailsView(Launch launch, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildLaunchInfoRow(
              'Launch Name:', launch.missionName, Icons.flight_takeoff, theme),
          const SizedBox(height: 16),
          _buildLaunchDetailsText(launch.details ?? 'Details not available', theme),
          const SizedBox(height: 16),
          _buildLaunchInfoRow('Launch Year:',
              launch.launchYear ?? 'Not specified', Icons.calendar_today, theme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLaunchInfoRow(String label, String value, IconData icon, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.iconTheme.color, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLaunchDetailsText(String details, ThemeData theme) {
    return Text(
      details,
      style: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: theme.textTheme.bodyMedium?.color ?? Colors.black87,
      ),
    );
  }
}
