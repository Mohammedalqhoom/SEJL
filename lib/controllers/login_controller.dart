import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdad_app/models/User_model.dart';
import '../models/login_state.dart';

class LoginController extends GetxController {
  final Rx<LoginState> _state = LoginState().obs;
  LoginState get state => _state.value;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(LoginCredentials credentials) async {
    _state.value = state.copyWith(
      isLoading: true,
      error: null,
      showRegister: false,
    );

    try {
      // 1️ تحقق مبدئي
      if (!credentials.isValide) {
        throw 'الرجاء إدخال البريد وكلمة المرور';
      }

      // 2️ تسجيل الدخول عبر Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: credentials.email.trim(),
        password: credentials.password.trim(),
      );

      // 3️ التحقق من المستخدم
      User? user = userCredential.user;

      if (user == null) {
        throw 'فشل تسجيل الدخول';
      }

      // 4️ نجاح
      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}');
      // أخطاء Firebase المعروفة
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        _state.value = state.copyWith(
          error: 'الحساب غير موجود',
          showRegister: true,
        );
      } else if (e.code == 'wrong-password') {
        _state.value = state.copyWith(error: 'كلمة المرور غير صحيحه');
      } else {
        _state.value = state.copyWith(error: e.message);
      }
    } finally {
      // 5️ إيقاف التحميل
      _state.value = state.copyWith(isLoading: false);
    }
  }
}
