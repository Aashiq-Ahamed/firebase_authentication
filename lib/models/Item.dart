import 'package:firebase_authentication/enum/categoryEnum.dart';
import 'package:firebase_authentication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  Item({
    this.id,
    required this.itemName,
    required this.dateTime,
    required this.itemCategory,
    required this.itemLocation,
    required this.itemPrice,
    required this.itemDescription,
    required this.itemImageURL,  // This remains as a List<String> for full item
    required this.itemStock,
    required this.itemRating,
    required this.likes,
    required this.views,
    required this.reviews,
    required this.user,
  });

  Item.lite({
    this.id,
    required this.itemName,
    required this.itemPrice,
    required this.itemDescription,
    required this.itemImageURL,  // Now a String? for a single URL
    required this.views,
  });

  String? id;
  String? itemName;
  double? itemPrice;
  Categoryenum? itemCategory;
  String? itemLocation;
  DateTime? dateTime;
  String? itemDescription;
  List<String>? itemImageURL;  // Full item constructor uses List<String>
  int? itemStock;
  double? itemRating;
  int? likes;
  int? views;
  List<String>? reviews;
  UserData? user;

  // Factory constructor to create an Item from Firestore data
  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Item.lite(
      id: doc.id,
      itemName: data['itemName'] ?? '',
      itemPrice: data['itemPrice']?.toDouble() ?? 0.0,
      itemDescription: data['itemDescription'] ?? '',
      itemImageURL: (data['itemImageURL'] as List<dynamic>?)?.cast<String>(),  // Extract first URL as String
      views: data['views'] ?? 0,
    );
  }
}
