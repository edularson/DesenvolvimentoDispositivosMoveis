import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceException implements Exception {
  final String message;
  AuthServiceException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'O e-mail é obrigatório.';
    }
    if (!email.contains('@')) {
      return 'Digite um e-mail válido.';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'A senha é obrigatória.';
    }
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirme sua senha.';
    }
    if (password != confirmPassword) {
      return 'As senhas não conferem.';
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // pega o erro do firebase e mostra a exceção traduzida
      throw AuthServiceException(_tratarErroFirebase(e.code));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(_tratarErroFirebase(e.code));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // erros do firebase
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _tratarErroFirebase(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-email':
        return 'E-mail ou senha incorretos.';

      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro desconhecido ($code). Tente novamente.';
    }
  }
}
