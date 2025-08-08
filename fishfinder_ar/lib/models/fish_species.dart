class FishSpecies {
  final String id;
  final String commonName;
  final String scientificName;
  final String description;
  final String habitat;
  final String region;
  final String imageAsset;
  final String sizeRange;
  final List<String> facts;

  const FishSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.habitat,
    required this.region,
    required this.imageAsset,
    required this.sizeRange,
    this.facts = const [],
  });

  factory FishSpecies.fromJson(Map<String, dynamic> json) {
    return FishSpecies(
      id: json['id'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      description: json['description'] as String,
      habitat: json['habitat'] as String,
      region: json['region'] as String,
      imageAsset: json['imageAsset'] as String,
      sizeRange: json['sizeRange'] as String,
      facts: List<String>.from(json['facts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'description': description,
      'habitat': habitat,
      'region': region,
      'imageAsset': imageAsset,
      'sizeRange': sizeRange,
      'facts': facts,
    };
  }
}