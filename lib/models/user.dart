

class UserData {
  

  UserData({
    this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.emailAddress,
    this.favouritItemIDs
  });

  String? id;
  final String name;
  final String location;
  final String phoneNumber;
  final String emailAddress;
  List<String>? favouritItemIDs;

  // Optionally, you can add a method to display user details
  @override
  String toString() {
    return 'User(name: $name, location: $location, phoneNumber: $phoneNumber, emailAddress: $emailAddress)';
  }

  // Factory constructor to create a UserData instance from a Firestore map
  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      emailAddress: data['emailAddress'] ?? '',
    );
  }
}
