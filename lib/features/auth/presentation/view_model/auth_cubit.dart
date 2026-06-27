import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_wave/features/auth/presentation/view_model/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.photoURL != null) {
        String role = credential.user!.photoURL!;
        emit(AuthSuccessState(role: role));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailureState(error: 'Email is not exist.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailureState(error: 'Wrong password, try again!'));
      } else {
        emit(AuthFailureState(error: 'Faild to sign in, try again!'));
      }
    }
  }

  Future<void> register(String fname, String lname, String phone, String email,
      int role, String password) async {
    emit(AuthLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      await user.updateDisplayName('$fname $lname');
      if (role == 0) {
        await user.updatePhotoURL('0');

        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fname': fname,
          'lname': lname,
          'image': null,
          'phone': phone,
          'email': email,
          'role': 'Traveler',
        }, SetOptions(merge: true));
      } else {
        await user.updatePhotoURL('1');

        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fname': fname,
          'lname': lname,
          'image': null,
          'phone': phone,
          'email': email,
          'role': 'Admin',
        }, SetOptions(merge: true));
      }

      emit(AuthSuccessState(role: role.toString()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(AuthFailureState(error: 'Email is already exist!'));
      } else if (e.code == 'weak-password') {
        emit(AuthFailureState(error: 'Weak password, please re-write agin!'));
      } else {
        emit(AuthFailureState(error: e.toString()));
      }
    }
  }
}
