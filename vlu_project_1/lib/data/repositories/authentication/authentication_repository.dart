// ignore_for_file: avoid_print, depend_on_referenced_packages

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

  // Variables
  final _storageService = StorageService();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  // Called from
  @override
  void onReady() {
    // Remove the native splash screen
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
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

      await _storageService.saveData('UserLoggedIn', true); // Lưu trạng thái đăng nhập
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
      // Update user's display name in Firebase Auth
      await _auth.currentUser?.updateProfile(displayName: newName);
      // Refresh the user to get the updated information
      await _auth.currentUser?.reload();

      // After updating the profile, update the name in Firestore
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
      
      // Kiểm tra nếu người dùng hủy đăng nhập
      if (userAccount == null) {
        FullScreenLoader.stopLoading(); // Dừng loading nếu người dùng hủy đăng nhập
        Get.offAll(() => const SignInScreen());
        throw Exception('Người dùng đã hủy đăng nhập.');
      }

      final GoogleSignInAuthentication? googleAuth = await userAccount.authentication;

      // Kiểm tra nếu googleAuth là null
      if (googleAuth == null) {
        FullScreenLoader.stopLoading();
        Get.offAll(() => const SignInScreen()); // Dừng loading nếu googleAuth là null
        throw Exception('Lỗi xác thực từ Google.');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      FullScreenLoader.stopLoading(); // Dừng loading nếu có lỗi FirebaseAuthException
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      FullScreenLoader.stopLoading(); // Dừng loading nếu có lỗi FirebaseException
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      FullScreenLoader.stopLoading(); // Dừng loading nếu có lỗi FormatException
      throw const TFormatException();
    } on PlatformException catch (e) {
      FullScreenLoader.stopLoading(); // Dừng loading nếu có lỗi PlatformException
      throw TPlatformException(e.code).message;
    } catch (e) {
      FullScreenLoader.stopLoading(); // Dừng loading nếu có lỗi khác
      if (kDebugMode) print('Có gì đó không đúng: $e');
      throw Exception('Đăng nhập thất bại.'); // Ném ngoại lệ rõ ràng
    }
  }



  // [FacebookAuthentication FACEBOOK

  Future<UserCredential> signInWithFacebook() async {
    try {
      // Đăng nhập với Facebook
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);

      // Kiểm tra nếu người dùng hủy đăng nhập
      if (loginResult.status == LoginStatus.cancelled) {
        FullScreenLoader.stopLoading();
        Get.offAll(() => const SignInScreen());
        return Future.error('Người dùng đã hủy đăng nhập.');
      }

      // Kiểm tra nếu có lỗi trong quá trình đăng nhập
      if (loginResult.status != LoginStatus.success) {
        FullScreenLoader.stopLoading();
        Get.offAll(() => const SignInScreen());
        return Future.error('Đăng nhập Facebook thất bại.');
      }

      // Đăng nhập vào Firebase bằng token Facebook
      final AuthCredential credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Kiểm tra nếu đăng nhập bằng Facebook thì bỏ qua xác minh email
      if (userCredential.additionalUserInfo?.providerId == 'facebook.com') {
        // Không yêu cầu xác minh email
        return userCredential;
      }

      // Nếu muốn xác minh email trong các trường hợp khác (ngoại trừ Facebook), xử lý tại đây
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }

    return userCredential;
    } on FirebaseAuthException catch (e) {
      FullScreenLoader.stopLoading();
      return Future.error(TFirebaseAuthException(e.code).message);
    } on FirebaseException catch (e) {
      FullScreenLoader.stopLoading();
      return Future.error(TFirebaseException(e.code).message);
    } on FormatException catch (_) {
      FullScreenLoader.stopLoading();
      return Future.error(const TFormatException());
    } on PlatformException catch (e) {
      FullScreenLoader.stopLoading();
      return Future.error(TPlatformException(e.code).message);
    } catch (e) {
      FullScreenLoader.stopLoading();
      if (kDebugMode) print('Có gì đó không đúng: $e');
      return Future.error('Đăng nhập thất bại.');
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
