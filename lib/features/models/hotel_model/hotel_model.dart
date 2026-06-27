import '../review.dart';
import 'room.dart';

class HotelModel {
  String? id;
  String? name;
  String? location;
  String? cover;
  String? contactNumber;
  String? email;  
  String? description;
  List<String>? images;
  double? rating;
  List<Room>? rooms;
  List<Review>? reviews;

  HotelModel({
    this.id,
    this.name,
    this.location,
    this.cover,
    this.contactNumber,
    this.email,
    this.description,
    this.images,
    this.rating,
    this.rooms,
    this.reviews,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => HotelModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        location: json['location'] as String?,
        cover: json['cover'] as String?,
        contactNumber: json['contactNumber'] as String?,
        email: json['email'] as String?,
        description: json['description'] as String?,
        images: (json['images'] as List<dynamic>?)?.cast<String>(),
        rating: (json['rating'] as num?)?.toDouble(),
        rooms: (json['rooms'] as List<dynamic>?)
            ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
            .toList(),
        reviews: (json['reviews'] as List<dynamic>?)
            ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cover': cover,
        'location': location,
        'contactNumber': contactNumber,
        'email': email,
        'description': description,
        'images': images,
        'rating': rating,
        'rooms': rooms?.map((e) => e.toJson()).toList(),
        'reviews': reviews?.map((e) => e.toJson()).toList(),
      };
}
