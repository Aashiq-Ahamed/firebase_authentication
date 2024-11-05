class UserData {
  

  UserData({
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.emailAddress,
  });

  final String name;
  final String location;
  final String phoneNumber;
  final String emailAddress;

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


  // Example static method to generate dummy users
  static List<UserData> getDummyUsers() {
    return [
      UserData(
        name: 'John Doe',
        location: 'New York, USA',
        phoneNumber: '+1 123 456 7890',
        emailAddress: 'john.doe@example.com',
      ),
      UserData(
        name: 'Jane Smith',
        location: 'Los Angeles, USA',
        phoneNumber: '+1 987 654 3210',
        emailAddress: 'jane.smith@example.com',
      ),
      UserData(
        name: 'Alice Johnson',
        location: 'London, UK',
        phoneNumber: '+44 1234 567890',
        emailAddress: 'alice.johnson@example.co.uk',
      ),
    ];
  }
}
