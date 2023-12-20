class User {
  final String name;
  final String email;
  final String country;
  final String registrationDate;
  final String city;
  final String state;
  String? postcode;
  String? userImage;
  String? age;
  String? birthDate;

  User(
      {required this.name,
      required this.email,
      required this.country,
      required this.registrationDate,
      required this.city,
      required this.state,
      this.postcode,
      this.userImage,
      this.age,
      this.birthDate});

  // Convert User object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'country': country,
      'registrationDate': registrationDate,
      'city': city,
      'state': state,
      'postcode': postcode,
      'userImage': userImage,
      'age': age,
      'birthDate': birthDate,
    };
  }
}
