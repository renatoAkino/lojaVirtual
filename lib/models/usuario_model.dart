import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;


  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrent();
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSucess, @required VoidCallback onFailed}) {
    loadChangeStatus();

    _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: pass)
        .then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSucess();
      loadChangeStatus();
    }).catchError((e) {
      onFailed();
      loadChangeStatus();
    });
  }

  Future<void> signIn(
      {@required String email, @required String pass, @required VoidCallback onSucess, @required VoidCallback onFailed}) async {

    loadChangeStatus();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
            (user) async {
          firebaseUser = user;

          await _loadCurrent();

          onSucess();
          loadChangeStatus();
        }).catchError(
            (e) {
             onFailed();
             loadChangeStatus();
        });
  }

  void recoverPass(String email) {
      _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  bool isLoggedin() {
    return firebaseUser != null;
  }

  void loadChangeStatus() {
    if (isLoading) {
      isLoading = false;
    } else {
      isLoading = true;
    }
    notifyListeners();
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrent() async{
      if(firebaseUser == null)
        firebaseUser = await _auth.currentUser();
      if(firebaseUser != null) {
        if (userData['name'] == null) {
          DocumentSnapshot docUser = await Firestore.instance.collection(
              'users').document(firebaseUser.uid).get();
          userData = docUser.data;
        }
      }
      notifyListeners();
  }

}