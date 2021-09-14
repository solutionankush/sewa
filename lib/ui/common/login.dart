import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sewa/common/functions.dart';
import 'package:sewa/ui/common/home.dart';

import '../../backend_work/getting_data.dart';
import '../../common/colors.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Duration get loginTime => Duration(milliseconds: 2250);
  Future<String> _authUser(LoginData data) {
    setState(() {
      Variables.number = data.name;
      Variables.password = data.password;
    });
    return Future.delayed(loginTime).then((_) async{
      var data = await Fun.login(context);
      return data;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Widgets.scaffoldWithoutAppBar(
      FlutterLogin(
        title: '${Variables.appName}',
        logo: '${Variables.Images.logoImage}',
        onLogin: _authUser,
        onSignup: _authUser,
        hideForgotPasswordButton: true,
        hideSignUpButton: true,
        theme: LoginTheme(primaryColor: MyColors.highlightColor),
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
        },
        userType: LoginUserType.phone,
        userValidator: (value) {
          if (value!.isEmpty) {
            return "Please Insert Mobile Number";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value!.isEmpty) {
            return "Please Insert Password";
          }
          return null;
        },
        messages: LoginMessages(
          userHint: 'Mobile',
        ),
        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            callback: () async {
              final GoogleSignInAccount? user = await GoogleSignIn().signIn();
              print(user);

              if (user != null) {
                GettingData.getUserByGoogle(
                    user.displayName, user.email, user.photoUrl, context);
              }
              setState(() {});
            },
          ),
        ],
        onRecoverPassword: (val) {},
      ),
      context,
    );
  }
}
