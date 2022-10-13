import 'package:flutter/material.dart';
import 'package:movie/config/routes/routes_const.dart';
import 'package:movie/config/theme/theme.dart';

import 'package:movie/screens/authentication/screens/forget.dart';
import 'package:movie/screens/authentication/screens/signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/screens/movies/bloc/movies_bloc.dart';
import 'package:movie/shared/bloc/auth/auth_bloc.dart';
import 'package:movie/shared/bloc/profile/profile_bloc.dart';
import 'package:movie/widget/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  late bool showPassword;

  @override
  void initState() {
    showPassword = false;
    super.initState();
  }

  void focusListener() async {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: ((previous, current) =>
              current is! SignupResultState || current is! SignUpLoader),
          builder: (context, state) {
            return _displayLoginPage(state);
          },
        ),
      ),
    );
  }

  void _listener(BuildContext context, state) {
    if (state is LogoutState) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => true);
    } else if (state is LoginResultState) {
      if (!state.loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.errorResult.toString())));
      } else {
        _fetchData(context);
      }
    }
  }

  Widget _displayLoginPage(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Opacity(
            opacity: state is AuthLoader ||
                    (state is LoginResultState && state.loggedIn)
                ? 0.01
                : 1,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 100),
                  Image.asset(
                    "assets/images/May-2022-Logo-HelloWoofy-Social-Media-Management-Blog-Management-Smart-Speaker-Marketing-Newsletter-Automation-Direct-Mail-Podcast-Real-Estate-Coaching-Arjun-Rai-Black.png",
                    errorBuilder: ((context, error, stackTrace) {
                      return Container();
                    }),
                  ),
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      cursorColor: LightAppColors.appBlueColor,
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your email";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      cursorColor: LightAppColors.appBlueColor,
                      controller: _passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.black),
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Password',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your password";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.greenAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            context.read<AuthBloc>().add(LoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text));
                          }
                        }
                      },
                      child: Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            LightAppColors.appBlueColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignupPage()));
                      },
                      child: Text(
                        'SIGN UP',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (state is AuthLoader ||
            (state is LoginResultState && state.loggedIn)) ...[
          const Center(child: AppCircularProgressIndicator())
        ]
      ],
    );
  }

  void _fetchData(BuildContext context) {
    context.read<MoviesBloc>().add(GetMoviesEvent(dateTime: DateTime.now()));

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, ((route) => false));
    });
  }
}
