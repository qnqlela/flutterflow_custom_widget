import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class User {

  String? nickname;

  User({
    this.nickname
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname' : nickname,
    };
  }
}


class UserRepository{

  static Future<bool> signup(User user) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await FirebaseFirestore.instance
          .collection('users').doc(auth.currentUser!.uid).update(user.toMap());
      return true;
    } catch(e) {
      return false;
    }
  }
}


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);


  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nicknameController.dispose();
    super.dispose();
  }


  final TextEditingController _nicknameController = TextEditingController();

  final user = User();

  bool _isValid() {
    return (_nicknameController.text.length >= 2);
  }

  void unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }


  void signup(User signupUser) async {
    await UserRepository.signup(signupUser);
  }

  void _register() {
    unfocusKeyboard();
    //validation
    var signupUser = User(
        nickname: _nicknameController.text
    );
    signup(signupUser);
  }


  Widget _notice() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Text('저의 닉네임은',
        style:  TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Widget _nickname() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
      child: TextField(
        onChanged: (text) {
          setState((){});
        },
        controller: _nicknameController,
        maxLength: 16,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(20,10,10,10),
          counterText: '',
          hintText: 'ex.전투개구리',
          hintStyle: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 20,
            fontWeight: FontWeight.bold,),
          labelStyle: TextStyle(
              color: Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(
                  30.0)),
              borderSide: BorderSide(width: 2,
                  color: Colors.black)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(
                  30.0)),
              borderSide: BorderSide(width: 2,
                  color: Colors.black)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(
                  30.0))
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }


  Widget _signin() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: TextButton.icon(
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
              foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.black;
                  } else {
                    return Color(0xff0055ff);
                  }
                },
              ),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              alignment: Alignment.centerLeft
          ),
          onPressed: _isValid()
              ? _register
              : null,
          icon: Text('입니다.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          label: Icon(Icons.play_arrow_outlined,
            size: 25,
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 200),
            _notice(),
            _nickname(),
            _signin(),
          ],
        ),
      ),
    );
  }
}