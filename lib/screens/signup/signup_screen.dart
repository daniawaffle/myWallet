import 'package:expenses_app/screens/signup/signup_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  SignupBloc bloc = SignupBloc();
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
                        child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter secure password',
                            ),
                            validator: (value) {
                              return bloc.validatePassword(value);
                            })),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 20),
                        child: TextFormField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                              hintText: 'Confirm secure password',
                            ),
                            validator: (value) {
                              return bloc.validatePasswordsMatch(
                                  value, passwordController.text);
                            })),
                  ],
                )),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () async {
                  if (bloc.formkey.currentState!.validate()) {
                    try {
                      await bloc.signUpWithEmailAndPassword(
                          emailController.text, passwordController.text);

                      Fluttertoast.showToast(
                        msg:
                            "Sign up successful! please return to log in screen",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.teal,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      emailController.text = '';
                      passwordController.text = '';
                      confirmPasswordController.text = '';
                      setState(() {});
                    } on FirebaseAuthException catch (error) {
                      Fluttertoast.showToast(
                        msg: error.message!,
                        gravity: ToastGravity.BOTTOM,
                      );
                    } on PlatformException catch (error) {
                      Fluttertoast.showToast(
                        msg: error.message!,
                        gravity: ToastGravity.BOTTOM,
                      );
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: e.toString(),
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  }
                },
                child: const Text(
                  'Signup',
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
