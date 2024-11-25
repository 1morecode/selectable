// Created by 1 More Code on 09/11/24.

// This class represents a restaurant and contains all the necessary details related to a restaurant.
class Restaurant {
  String id; // Unique identifier for the restaurant
  String name; // Name of the restaurant
  String ownerId; // ID of the restaurant owner
  Location location; // Location details of the restaurant
  Contact contact; // Contact details of the restaurant
  String openingHours; // Opening hours of the restaurant
  List<String> amenities; // List of amenities offered by the restaurant
  List<String> images; // List of image URLs related to the restaurant
  double rating; // Average rating of the restaurant
  List<String> reviews; // List of reviews for the restaurant
  String description; // Description of the restaurant
  String thumbnail; // Thumbnail image for the restaurant
  String createdAt; // Timestamp when the restaurant was created
  String updatedAt; // Timestamp when the restaurant details were last updated
  Availability availability; // Availability details of the restaurant (e.g., open or closed)

  // Constructor to initialize all properties of the restaurant
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

  // Factory method to create a Restaurant object from a JSON map
  factory Restaurant.fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(
      id: id,
      name: json['name'],
      ownerId: json['ownerId'],
      location: Location.fromJson(json['location']), // Convert Location JSON to Location object
      contact: Contact.fromJson(json['contact']), // Convert Contact JSON to Contact object
      openingHours: json['openingHours'],
      amenities: List<String>.from(json['amenities']),
      images: List<String>.from(json['images']),
      rating: json['rating'].toDouble(),
      reviews: List<String>.from(json['reviews']),
      description: json['description'],
      thumbnail: json['thumbnail'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      availability: Availability.fromJson(json['availability']), // Convert Availability JSON to Availability object
    );
  }

  // Method to convert the Restaurant object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'location': location.toJson(), // Convert Location object back to JSON
      'contact': contact.toJson(), // Convert Contact object back to JSON
      'openingHours': openingHours,
      'amenities': amenities,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'thumbnail': thumbnail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'availability': availability.toJson(), // Convert Availability object back to JSON
    };
  }
}

// This class represents the location of the restaurant.
class Location {
  String address; // Address of the restaurant
  String city; // City where the restaurant is located
  String state; // State where the restaurant is located
  String zipCode; // Zip code for the restaurant's location
  double latitude; // Latitude of the restaurant
  double longitude; // Longitude of the restaurant

  // Constructor to initialize all properties of the Location
  Location({
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create a Location object from a JSON map
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

  // Method to convert the Location object back to a JSON map
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

// This class represents the contact details of the restaurant.
class Contact {
  String phone; // Restaurant's phone number
  String email; // Restaurant's email address
  String website; // Restaurant's website URL

  // Constructor to initialize all properties of Contact
  Contact({
    required this.phone,
    required this.email,
    required this.website,
  });

  // Factory method to create a Contact object from a JSON map
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
    );
  }

  // Method to convert the Contact object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
    };
  }
}

// This class represents the availability information of the restaurant (e.g., open or closed).
class Availability {
  Map<String, List<String>> availability; // A map of days and available time slots

  // Constructor to initialize the availability map
  Availability({required this.availability});

  // Factory method to create an Availability object from a JSON map
  factory Availability.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> availability = {};
    json.forEach((key, value) {
      availability[key] = List<String>.from(value); // Convert the list values from JSON
    });
    return Availability(availability: availability);
  }

  // Method to convert the Availability object back to a JSON map
  Map<String, dynamic> toJson() {
    return availability;
  }
}
