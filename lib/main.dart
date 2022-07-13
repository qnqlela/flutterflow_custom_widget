import 'package:firebase_auth/firebase_auth.dart';


class User {
  String nickname;

  User({this.nickname});

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
    };
  }
}



// User Repository 생성.
class UserRepository {
  static Future<bool> signup(User user) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid)
          .update(user.toMap()); // ② 전달받은 인자를 User Model에 명시된 toMap메소드를 통해 Map형식으로 Firebase의 user collection의 uid와 일치하는 document에 사용자로부터 입력받은 nickname 데이터를 갱신.
      return true;
    } catch (e) {
      return false;
    }
  }
}



// SignupPage 시작.
class SignupPage extends StatefulWidget {
  const SignupPage({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nicknameController.dispose();
    super.dispose();
  }

  // Textfield에 입력되는 값을 읽기 위한 controller.
  final TextEditingController _nicknameController = TextEditingController();

  // _register 함수에 쓰일 user 선언.
  final user = User();

  // 간단한 validation.
  bool _isValid() {
    return (_nicknameController.text.length >= 2);
  }

  void unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ① UserRepository에 명시된 signup메소드에 signupUser라는 매개변수(=변수) 자체를 전달하는 기능을 하는 함수.
  void signup(User signupUser) async {
    await UserRepository.signup(signupUser);
  }

  // 버튼을 눌렀을 때의 기능을 담당하는 함수.
  void _register() {
    unfocusKeyboard();
    var signupUser = User(nickname: _nicknameController.text);
    signup(signupUser);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
            HomePageWidget()), (route) => false); // 기존 flutter에서 사용하는 방식 그대로이지만, flutterflow에서 정상적으로 사용하려면 이와 같이 페이지명 뒤에 widget을 붙여야 합니다!
  }

  Widget _notice() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Text(
        '저의 닉네임은',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 닉네임 입력란
  Widget _nickname() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
      child: TextField(
        onChanged: (text) { // TextField에 입력되는 값(text)을 인식하여 그 때마다 setState((){})를 통해 화면을 갱신해줍니다.
          setState(() {});
        },
        controller: _nicknameController,
        maxLength: 16,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
          counterText: '',
          hintText: 'ex.전투개구리',
          hintStyle: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(width: 2, color: Colors.black)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(width: 2, color: Colors.black)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  // 회원가입 완료 버튼 위젯(제출 버튼 위젯)
  Widget _signin() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: TextButton.icon(
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
              foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.black; // Textfield의 onChanged로 항상 감시하다가 _isValid함수가 충족되지 않았을 경우 글씨 색깔 검은색 유지.
                  } else {
                    return Color(0xff4B39EF); // _isValid함수 충족 시, 앞에 명시된 색깔로 반환.
                  }
                },
              ),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              alignment: Alignment.centerLeft),
          onPressed: _isValid()
              ? _register // _isValid함수가 유효한 경우 _register함수를 실행합니다.
              : null,// 그렇지 않다면 null값을 반환합니다.(작동 불가 상태) => 이 값을 이용하여 위와 같이 글씨 색깔에 변화를 줄 수 있습니다.
          icon: Text(
            '입니다.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          label: Icon(
            Icons.play_arrow_outlined,
            size: 25,
          )),
    );
  }


  // SignupPage의 위젯 빌드
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