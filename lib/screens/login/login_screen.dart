import 'package:expenses_app/extentions.dart';
import 'package:expenses_app/models/user.dart';
import 'package:expenses_app/screens/expenses/expenses_screen.dart';
import 'package:expenses_app/screens/login/login_bloc.dart';
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
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
                            hintText: 'Enter valid email id as abc@gmail.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter E-mail';
                          } else if (!value.isValidEmail()) {
                            return 'enter a valid email format';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: StreamBuilder<bool>(
                          stream: bloc.passStreamController.stream,
                          builder: (context, snapshot) {
                            return TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Enter secure password',
                                    suffix: InkWell(
                                      onTap: () {},
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
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
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
                      await bloc.authService.signInWithEmailAndPassword(AppUser(
                          email: emailController.text,
                          password: passwordController.text));
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
            const SizedBox(
              height: 130,
            ),
            const Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
