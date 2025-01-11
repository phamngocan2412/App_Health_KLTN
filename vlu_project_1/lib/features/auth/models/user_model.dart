import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vlu_project_1/core/validate.dart';

class UserModel {
  final String id;
  String username;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String profilePicture;

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
      return null;
    }
    return Validate.phone(phoneNumber);
  }

  String get fullName => '$firstName $lastName';
  String get formattedPhoneNumber =>
      phoneNumber.isNotEmpty ? '+84 $phoneNumber' : '';

  static List<String> nameParts(fullName) => fullName.split(' ');

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split("");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername"; 
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
      id: "",
      firstName: "",
      lastName: "",
      username: "",
      email: "",
      phoneNumber: "",
      profilePicture: "");

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
