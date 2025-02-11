// ignore_for_file: avoid_print, depend_on_referenced_packages, unnecessary_nullable_for_final_variable_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vlu_project_1/core/exceptions/exceptions.dart';
import 'package:vlu_project_1/core/exceptions/firebase_auth_exceptions.dart';
import 'package:vlu_project_1/data/repositories/user/user_repository.dart';
import 'package:vlu_project_1/features/auth/screens/onboarding/onboarding_screen.dart';
import 'package:vlu_project_1/features/auth/screens/sign_in/sign_in_screen.dart';
import 'package:vlu_project_1/features/auth/screens/verify_email/verify_email_screen.dart';
import 'package:vlu_project_1/shared/navigation_menu.dart';
import 'package:vlu_project_1/shared/widgets/full_screen_loader.dart';
import 'package:vlu_project_1/storage.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _storageService = StorageService();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {

      if (user.emailVerified || user.providerData.any((userInfo) => userInfo.providerId == 'facebook.com')) {
        print('Chuyển hướng đến NavigationMenu...');
        Get.offAll(() => const NavigationMenu());
      } else {
        print('Chuyển hướng đến VerifyEmailScreen...');
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      bool isFirstTime = _storageService.readData<bool>('IsFirstTime') ?? true;
      if (isFirstTime) {
        await _storageService.saveData('IsFirstTime', false);
        Get.off(() => const OnboardingScreen());
      } else {
        Get.offAll(() => const SignInScreen());
      }
    }
  }
  /* --------------------------------------Email & Password ------------------------------------- */

  //[EmailAuthentication] - SIGN IN

  Future<UserCredential> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Tài khoản không tồn tại.');
      }

      await _storageService.saveData('UserLoggedIn', true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("General Exception: $e");
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }

  // [EmailAuthentication] - REGISTER

  Future<UserCredential> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _storageService.saveData('UserLoggedIn', true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("General Exception: $e");
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }
  //[EmailVerification] MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;

      // Chỉ gửi email xác thực nếu người dùng không đăng nhập bằng Facebook
      if (user != null && user.providerData.any((info) => info.providerId != 'facebook.com')) {
        await user.sendEmailVerification();
        print('Email xác thực đã được gửi.');
      } else {
        print('Người dùng đăng nhập bằng Facebook, không cần xác minh email.');
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("General Exception: $e");
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }

  // Check AuthenticationRepository
  Future<bool> checkEmailExists(String email) async {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final querySnapshot =
        await userCollection.where('Email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      print("Email tồn tại trong hệ thống.");
      return true;
    } else {
      print("Email không tồn tại.");
      return false;
      
    }
  }

  // Update Name
  Future<void> updateUserName(String newName) async {
    try {
      await _auth.currentUser?.updateProfile(displayName: newName);
      await _auth.currentUser?.reload();
      if (authUser != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authUser!.uid)
            .update({
          'Name': newName,
        });
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("General Exception: $e");
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }

  // [EmailAuthentication] FORGET PASSWORD

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("General Exception: $e");
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }

  // [ReAuthenticate] - RE AUTHENTICATE USER

  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }

  /* ----------------------- Federated identity & social sign-in ----------------------- */

  // [GoogleAuthentication] - G00GLE

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      if (userAccount == null) {
        FullScreenLoader.stopLoading(); 
        Get.offAll(() => const SignInScreen());
        throw Exception('Người dùng đã hủy đăng nhập.');
      }

      final GoogleSignInAuthentication? googleAuth = await userAccount.authentication;

      if (googleAuth == null) {
        FullScreenLoader.stopLoading();
        Get.offAll(() => const SignInScreen());
        throw Exception('Lỗi xác thực từ Google.');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      FullScreenLoader.stopLoading(); 
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      FullScreenLoader.stopLoading(); 
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      FullScreenLoader.stopLoading(); 
      throw const TFormatException();
    } on PlatformException catch (e) {
      FullScreenLoader.stopLoading(); 
      throw TPlatformException(e.code).message;
    } catch (e) {
      FullScreenLoader.stopLoading();
      if (kDebugMode) print('Có gì đó không đúng: $e');
      throw Exception('Đăng nhập thất bại.');
    }
  }



  // [FacebookAuthentication FACEBOOK

  Future<UserCredential> signInWithFacebook() async {
    try {
      print('Bắt đầu xác thực Facebook...');
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
      print('Kết quả đăng nhập Facebook: ${loginResult.status}');

      if (loginResult.status == LoginStatus.cancelled) {
        print('Người dùng đã hủy đăng nhập Facebook.');
        FullScreenLoader.stopLoading();
        Get.offAll(() => const SignInScreen());
        throw Exception('Người dùng đã hủy đăng nhập.');
      }

      if (loginResult.status != LoginStatus.success) {
        print('Đăng nhập Facebook thất bại: ${loginResult.status}');
        FullScreenLoader.stopLoading();
        Get.offAll(() => const SignInScreen());
        throw Exception('Đăng nhập Facebook thất bại.');
      }

      print('Lấy access token từ Facebook...');
      final AccessToken accessToken = loginResult.accessToken!;
      print('Access token: ${accessToken.tokenString}');

      print('Tạo credential từ Facebook...');
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

      print('Đăng nhập vào Firebase bằng credential Facebook...');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('Đăng nhập Firebase thành công: ${userCredential.user?.uid}');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Lỗi FirebaseAuthException: ${e.code}');
      FullScreenLoader.stopLoading();
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print('Lỗi FirebaseException: ${e.code}');
      FullScreenLoader.stopLoading();
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print('Lỗi FormatException');
      FullScreenLoader.stopLoading();
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('Lỗi PlatformException: ${e.code}');
      FullScreenLoader.stopLoading();
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Lỗi không xác định: $e');
      FullScreenLoader.stopLoading();
      throw Exception('Đăng nhập thất bại.');
    }
  }

    /* ----------------------- ./end Federated identity & social sign-in ----------------------- */

    // [LogoutUser) Valid for any authentication.

    Future<void> logout() async {
      try {
        await _auth.signOut();
        await _storageService.clearAll();
        Get.offAll(() => const SignInScreen());
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException: ${e.message}");
        throw TFirebaseAuthException(e.code).message;
      } on FirebaseException catch (e) {
        print("FirebaseException: ${e.message}");
        throw TFirebaseException(e.code).message;
      } on FormatException catch (_) {
        throw const TFormatException();
      } on PlatformException catch (e) {
        print("PlatformException: ${e.message}");
        throw TPlatformException(e.code).message;
      } catch (e) {
        print("General Exception: $e");
        throw "Có gì đó không đúng. Làm ơn thử lại";
      }
    }

  // [DeleteUser] Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("General Exception: $e");
      throw "Có gì đó không đúng. Làm ơn thử lại";
    }
  }
}
