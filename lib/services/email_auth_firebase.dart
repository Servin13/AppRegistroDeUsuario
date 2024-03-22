import 'package:firebase_auth/firebase_auth.dart';

//Clase para registrarnos y autenticarnos
class EmailAuthFirebase {
  final auth = FirebaseAuth.instance;

//Dar de alta en firebase
  Future<bool> signUpUser(
      {required String name,
      required String password,
      required String email}) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        userCredential.user!
            .sendEmailVerification(); //Se envia el email para que verfique y se almacene en firebase
        return true;
      }
      return false;
    } catch (e) {
      print("Error al registrar usuario: $e");
      return false;
    }
  }

  Future<bool> signInUser(
      {required String password, required String email}) async {
    var flag = false;
    final userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      if (userCredential.user!.emailVerified) {
        flag = true;
      }
    }
    return flag;
  }
}