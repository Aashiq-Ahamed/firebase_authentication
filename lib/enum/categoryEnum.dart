enum Categoryenum {
  electronics,
  furniture,
  clothing,
  vehicles,
  books,
}

extension CategoryExtension on Categoryenum {
  String get displayTitle {
    switch (this) {
      case Categoryenum.electronics:
        return 'Electronics';
      case Categoryenum.furniture:
        return 'Furniture';
      case Categoryenum.clothing:
        return 'Clothing';
      case Categoryenum.vehicles:
        return 'Vehicles';
      case Categoryenum.books:
        return 'Books';
    }
  }
}
