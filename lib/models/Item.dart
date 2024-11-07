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
    required this.isNegotiable
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
  bool? isNegotiable;

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
  factory Item.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Item(
      id: data['id'] as String?,
      itemName: data['itemName'] as String?,
      itemPrice: (data['itemPrice'] as num?)?.toDouble(),
      itemCategory: Categoryenum.values.firstWhere(
        (c) => c.toString() == 'CategoryEnum.${data['itemCategory']}',
        orElse: () => Categoryenum.books,
      ),
      itemLocation: data['itemLocation'] as String?,
      dateTime: _getDateTimeFromFirestore(data['dateTime']),
      itemDescription: data['itemDescription'] as String?,
      itemImageURL: data['itemImageURL'] != null
          ? List<String>.from(data['itemImageURL'] as Iterable)
          : null,
      itemStock: (data['itemStock'] as num?)?.toInt(),
      itemRating: (data['itemRating'] as num?)?.toDouble(),
      likes: (data['likes'] as num?)?.toInt(),
      views: (data['views'] as num?)?.toInt(),
      reviews: data['reviews'] != null
          ? List<String>.from(data['reviews'] as Iterable)
          : null,
      user: data['user'] != null
          ? UserData.fromMap(data['user'] as Map<String, dynamic>)
          : null,
      isNegotiable: data['isNegotiable'] as bool? ?? false,
    );
  }
  static DateTime? _getDateTimeFromFirestore(dynamic firestoreDateTime) {
  if (firestoreDateTime is Timestamp) {
    return firestoreDateTime.toDate();
  } else if (firestoreDateTime is String) {
    return DateTime.parse(firestoreDateTime);
  } else {
    return null;
  }
}
}
