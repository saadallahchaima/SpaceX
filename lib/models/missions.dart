//j ai utilisé https://app.quicktype.io/ pour "parser"

class Mission {
  final String missionName;
  final String missionId;

  final String wikipedia;
  final String website;
  final String twitter;
  final String description;

  Mission({
    required this.missionName,
    required this.missionId,

    required this.wikipedia,
    required this.website,
    required this.twitter,
    required this.description,
  });
  Map<String, dynamic> toMap() {
    return {
      'mission_name': missionName,
      'mission_id': missionId,
      'wikipedia': wikipedia,
      'website': website,
      'twitter': twitter,
      'description': description,
    };
  }
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionName: json['mission_name'],
      missionId: json['mission_id'],
      wikipedia: json['wikipedia'],
      website: json['website'],
      twitter: json['twitter'] ?? '',
      description: json['description'],
    );
  }

}