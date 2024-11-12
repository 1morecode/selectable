//
// Created by 1 More Code on 09/11/24.
//

class Restaurant {
  String id;
  String name;
  String ownerId;
  Location location;
  Contact contact;
  String openingHours;
  List<String> amenities;
  List<String> images;
  double rating;
  List<String> reviews;
  String description;
  String thumbnail;
  String createdAt;
  String updatedAt;
  Availability availability;

  Restaurant({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.location,
    required this.contact,
    required this.openingHours,
    required this.amenities,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.thumbnail,
    required this.createdAt,
    required this.updatedAt,
    required this.availability,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(
      id: id,
      name: json['name'],
      ownerId: json['ownerId'],
      location: Location.fromJson(json['location']),
      contact: Contact.fromJson(json['contact']),
      openingHours: json['openingHours'],
      amenities: List<String>.from(json['amenities']),
      images: List<String>.from(json['images']),
      rating: json['rating'].toDouble(),
      reviews: List<String>.from(json['reviews']),
      description: json['description'],
      thumbnail: json['thumbnail'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      availability: Availability.fromJson(json['availability']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'location': location.toJson(),
      'contact': contact.toJson(),
      'openingHours': openingHours,
      'amenities': amenities,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'thumbnail': thumbnail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'availability': availability.toJson(),
    };
  }
}

class Location {
  String address;
  String city;
  String state;
  String zipCode;
  double latitude;
  double longitude;

  Location({
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Contact {
  String phone;
  String email;
  String website;

  Contact({
    required this.phone,
    required this.email,
    required this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
    };
  }
}

class Availability {
  Map<String, List<String>> availability;

  Availability({required this.availability});

  factory Availability.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> availability = {};
    json.forEach((key, value) {
      availability[key] = List<String>.from(value);
    });
    return Availability(availability: availability);
  }

  Map<String, dynamic> toJson() {
    return availability;
  }
}

