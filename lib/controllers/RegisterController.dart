import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sdad_app/models/RegisterModel.dart';
import 'package:sdad_app/models/login_state.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<LoginState> _state = LoginState().obs;
  LoginState get state => _state.value;

  Future<void> register(Registermodel model) async {
    _state.value = state.copyWith(isLoading: true, error: null);
    try {
      if (!model.isValid) {
        throw 'جميع الحقول مطلوبه';
      }
      //created acounts new
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: model.email,
            password: model.password,
          );

      final User? user = userCredential.user;
      if (user == null) {
        throw 'حدث خطا اثنا انشاء الحساب';
      }
      //Save data user in fai stor
      await _firestore.collection('shop_owners').doc(user.uid).set({
        'shop_name': model.shopName,
        'email': model.email,
        'phone': model.phone,
        'fcm_token': '',
        'create_at': FieldValue.serverTimestamp(),
      });
      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _state.value = state.copyWith(error: 'هاذا البريد مسجل من قبل');
      } else {
        _state.value = state.copyWith(error: e.message);
      }
    } catch (e) {
      _state.value = state.copyWith(error: e.toString());
    } finally {
      _state.value = state.copyWith(
        //stop dowenlod
        isLoading: false,
      );
    }
  }
}
