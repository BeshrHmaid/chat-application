import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoadingState());
        try {
          UserCredential user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          emit(LoginSuccessState());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(LoginFailureState(errorMsg: 'user-not-found'));
          } else if (e.code == 'wrong-password') {
            emit(LoginFailureState(errorMsg: 'wrong-password'));
          }
        } catch (e) {
          emit(LoginFailureState(errorMsg: e.toString()));
        }
      } else if (event is RegisterEvent) {
        emit(RegisterLoadingState());
        try {
          UserCredential user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: event.email, password: event.password);
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
    });
  }
}
