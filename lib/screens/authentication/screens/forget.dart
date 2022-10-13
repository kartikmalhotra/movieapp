import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/config/theme/theme.dart';
import 'package:movie/widget/widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(0.0),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(),
      // body: BlocListener<AuthBloc, AuthState>(
      //   listener: _listener,
      //   child: BlocBuilder<AuthBloc, AuthState>(
      //     buildWhen: ((previous, current) =>
      //         current is ForgetPasswordLoader ||
      //         current is ForgetPasswordState),
      //     builder: (context, state) {
      //       return _displayResetPasswordContents(state);
      //     },
      //   ),
      // ),
    );
  }

  Widget _displayResetPasswordContents(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Image.asset(
                "assets/images/May-2022-Logo-HelloWoofy-Social-Media-Management-Blog-Management-Smart-Speaker-Marketing-Newsletter-Automation-Direct-Mail-Podcast-Real-Estate-Coaching-Arjun-Rai-Black.png",
                errorBuilder: ((context, error, stackTrace) {
                  return Container();
                }),
              ),
              const SizedBox(height: 100),
              Text(
                "Forgot password ?",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: _emailController,
                  cursorColor: LightAppColors.appBlueColor,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: Colors.grey.withOpacity(0.1),
                    prefixIcon: Icon(Icons.mail_outline, color: Colors.black),
                    helperStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          LightAppColors.appBlueColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    // onPressed: () => context
                    //     .read<AuthBloc>()
                    //     .add(ForgetPasswordEvent(email: _emailController.text)),
                    child: Text(
                      'CONFIRM',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (state is ForgetPasswordLoader) ...[
        //   Center(
        //     child: AppCircularProgressIndicator(),
        //   )
        // ]
      ],
    );
  }
}

void _listener(BuildContext context, state) {
  // if (state is ForgetPasswordState) {
  //   if (state.message?.isNotEmpty ?? false) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.grey,
  //         content: Text(state.message.toString())));
  //   } else if (state.errorResult?.isNotEmpty ?? false) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.grey,
  //         content: Text(state.errorResult.toString())));
  //   }
  // }
}
