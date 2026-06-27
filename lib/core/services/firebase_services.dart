import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hotel_wave/features/models/hotel_model/hotel_model.dart';

class FirebaseServices {
  static late FirebaseAuth _auth;
  static late FirebaseFirestore _db;
  static late FirebaseStorage _storage;

  static late User? user;

  static void init() {
    _auth = FirebaseAuth.instance;
    _db = FirebaseFirestore.instance;
    _storage =
        FirebaseStorage.instanceFor(bucket: 'gs://hotel-wave.appspot.com');
  }

  static void logout() {
    _auth.signOut();
  }

  static User getUser() {
    return _auth.currentUser!;
  }

  static Future<void> addToFav({
    required HotelModel model,
    required User user,
  }) async {
    await FirebaseFirestore.instance
        .collection('favourite-list')
        .doc(user.uid)
        .set({
      model.id ?? '': model.toJson(),
    }, SetOptions(merge: true));
  }

  static void deleteItemFromFav(hotelId) {
    FirebaseFirestore.instance.collection('favourite-list').doc(user?.uid).set({
      hotelId: FieldValue.delete(),
    }, SetOptions(merge: true));
  }
}
