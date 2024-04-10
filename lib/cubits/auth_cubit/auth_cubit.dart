import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoadingState());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(RegisterFailureState(errorMsg: 'weak password'));
      } else if (ex.code == 'email-already-in-use') {
        emit(RegisterFailureState(errorMsg: 'email already in use'));
      }
    } on Exception catch (e) {
      emit(RegisterFailureState(errorMsg: e.toString()));
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(LoginFailureState(errorMsg: 'weak password'));
      } else if (e.code == 'email-already-in-use') {
        emit(LoginFailureState(errorMsg: 'email alreday in use'));
      }
    } catch (e) {
      emit(LoginFailureState(errorMsg: e.toString()));
    }
  }
}
