class ProductionCountry {
  final String name;
  final String iso_3166_1;

  ProductionCountry({
    required this.name,
    required this.iso_3166_1
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
          name: json['name'] ?? '',
          iso_3166_1: json['iso_3166_1'] ?? ''
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'iso_3166_1': iso_3166_1
  };
}