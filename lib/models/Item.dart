
import 'package:firebase_authentication/enum/categoryEnum.dart';
import 'package:firebase_authentication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  Item({
    required this.itemName,
    required this.dateTime,
    required this.itemCategory,
    required this.itemLocation,
    required this.itemPrice,
    required this.itemDescription,
    required this.itemImageURL,
    required this.itemStock,
    required this.itemRating,
    required this.likes,
    required this.views,
    required this.reviews,
    required this.user,
  });

  final String itemName;
  final DateTime dateTime;
  final Categoryenum itemCategory;
  final String itemLocation;
  final double itemPrice;
  final String itemDescription;
  final List<String> itemImageURL;
  final int itemStock;
  final double itemRating;
  final int likes;
  final int views;
  final List<String> reviews;
  final UserData user;

  // Factory constructor to create an Item from Firestore data
  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item(
      itemName: data['itemName'] ?? '',
      itemPrice: (data['itemPrice'] ?? 0).toDouble(),
      itemLocation: data['itemLocation'] ?? '',
      itemDescription: data['itemDescription'] ?? '',
      dateTime: DateTime.parse(data['dateTime'] ?? DateTime.now().toIso8601String()),
      itemCategory: Categoryenum.values.firstWhere(
        (e) => e.toString() == data['itemCategory'],
        orElse: () => Categoryenum.books,  // Default if no match
      ),
      itemImageURL: List<String>.from(data['itemImageURL'] ?? []),
      itemStock: data['itemStock'] ?? 0,
      itemRating: (data['itemRating'] ?? 0).toDouble(),
      likes: data['likes'] ?? 0,
      views: data['views'] ?? 0,
      reviews: List<String>.from(data['reviews'] ?? []),
      user: UserData.fromMap(data['user'] ?? {}),
    );
  }
    
}
