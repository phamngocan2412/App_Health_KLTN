import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vlu_project_1/core/validate.dart';


// Model class representing user data
class UserModel {
  final String id;
  String username;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String profilePicture;

  // Constructor for user model
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profilePicture,
  });

  bool get isPhoneNumberEmpty => phoneNumber.isEmpty;

  String? validatePhoneNumber() {
    if (isPhoneNumberEmpty) {
      return null; // Do not validate if empty
    }
    return Validate.phone(phoneNumber);
  }

  // Helper functions to get user full name
  String get fullName => '$firstName $lastName';

  // Helper functions to get user formatted phone number
  String get formattedPhoneNumber =>
      phoneNumber.isNotEmpty ? '+84 $phoneNumber' : '';

  // Helper functions to split user full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(' ');

  // Static function to generate a username from user full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split("");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  // Static function to create an empty user model.
  static UserModel empty() => UserModel(
      id: "",
      firstName: "",
      lastName: "",
      username: "",
      email: "",
      phoneNumber: "",
      profilePicture: "");

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? "",
        lastName: data['LastName'] ?? "",
        username: data['Username'] ?? "",
        email: data['Email'] ?? "",
        phoneNumber: data['PhoneNumber'] ?? "",
        profilePicture: data['ProfilePicture'] ?? "",
      );
    } else {
      return UserModel.empty();
    }
  }
}
