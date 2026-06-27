class Room {
  String? id;
  String? type;
  String? description;
  List<String>? amenities;
  double? pricePerNight;

  Room({
    this.id,
    this.type,
    this.description,
    this.amenities,
    this.pricePerNight,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'] as String?,
        type: json['type'] as String?,
        description: json['description'] as String?,
        amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
        pricePerNight: json['pricePerNight'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'description': description,
        'amenities': amenities,
        'pricePerNight': pricePerNight,
      };
}
