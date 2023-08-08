import 'package:expenses_app/screens/expenses/expenses_screen.dart';
import 'package:expenses_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:expenses_app/screens/login/login_bloc.dart';
import 'package:expenses_app/screens/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginBloc bloc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/Wallet.png')),
              ),
            ),
            Form(
                key: bloc.formkey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText:
                                  'Enter valid email id as abc@gmail.com'),
                          validator: (value) {
                            return bloc.validateEmail(value);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: StreamBuilder<bool>(
                          stream: bloc.passStreamController.stream,
                          builder: (context, snapshot) {
                            return TextFormField(
                                controller: passwordController,
                                obscureText: !bloc.isPasswordVisable,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Enter secure password',
                                    suffix: InkWell(
                                      onTap: () {
                                        bloc.togglePasswordVisibility();
                                      },
                                      child: Text(
                                        bloc.isPasswordVisable
                                            ? "Hide"
                                            : "show",
                                      ),
                                    )),
                                validator: (value) {
                                  return bloc.validatePassword(value);
                                });
                          }),
                    ),
                  ],
                )),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignupScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Signup',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () async {
                  if (bloc.formkey.currentState!.validate()) {
                    // try {
                    //   bloc.loginToFirebase(
                    //       emailController.text, passwordController.text);
                    // } on FirebaseAuthException catch (error) {
                    //   Fluttertoast.showToast(
                    //       msg: error.message!, gravity: ToastGravity.TOP);
                    // }
                    try {
                      await bloc.loginToFirebase(
                          emailController.text, passwordController.text);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const ExpensesScreen()));
                      }
                    } on FirebaseAuthException catch (error) {
                      Fluttertoast.showToast(
                        msg: error.message!,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
