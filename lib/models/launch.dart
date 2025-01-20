class Launch {
  final int id;
  final String missionName;
  final String details;
  final String launchYear;

  Launch({
    required this.id,
    required this.missionName,
    required this.details,
    required this.launchYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'flight_number': id,
      'mission_name': missionName,
      'details': details,
      'launch_year': launchYear,
    };
  }

factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      id: json['flight_number'] ?? 0,  
      missionName: json['mission_name'] ?? 'Unknown', 
      details: json['details'] ?? 'No details available',  
      launchYear: json['launch_year'] ?? 'Unknown', 
    
      
    );
  }
  @override
  String toString() {
    return 'Launch(missionName: $missionName, details: $details, launchYear: $launchYear)';
  }
}
