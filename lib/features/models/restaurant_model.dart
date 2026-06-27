import 'package:hotel_wave/features/models/review.dart';

class RestuarentModel {
  String? id;
  String? name;
  String? description;
  String? cover;
  String? location;
  double? rating;
  List<Review>? reviews;
  String? contactNumber;

  RestuarentModel({
    this.id,
    this.name,
    this.cover,
    this.description,
    this.location,
    this.rating,
    this.reviews,
    this.contactNumber,
  });

  factory RestuarentModel.fromJson(Map<String, dynamic> json) =>
      RestuarentModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        cover: json['cover'],
        location: json['location'],
        rating: json['rating'],
        contactNumber: json['contactNumber'],
        reviews: (json['reviews'] as List<dynamic>?)
            ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'cover': cover,
        'location': location,
        'rating': rating,
        'contactNumber': contactNumber,
        'reviews': reviews?.map((e) => e.toJson()).toList(),
      };
}
