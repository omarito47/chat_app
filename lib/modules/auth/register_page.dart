import 'package:chat_app/global/services/auth/auth_service.dart';
import 'package:chat_app/global/components/custom_button.dart';
import 'package:chat_app/global/components/custom_text_field.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => RregisterStatePage();
}

class RregisterStatePage extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwControlller = TextEditingController();
  final TextEditingController _confirmPwControlller = TextEditingController();
  // register function
  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwControlller.text == _confirmPwControlller.text) {
      try {
        _auth.signUpWithEmailAndPassword(
          _emailController.text,
          _pwControlller.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder:(context) =>  AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    else{
      showDialog(
          context: context,
          builder:(context) =>  AlertDialog(
            title: Text("Passwords don't match!"),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 30,
            ),

            // welcome back message
            Text(
              'Let\'s create an account for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // email textFiled
            CustomTextFiled(
              hintText: "Email",
              obsucureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            // password textFiled
            CustomTextFiled(
              hintText: "Password",
              obsucureText: true,
              controller: _pwControlller,
            ),
            const SizedBox(
              height: 10,
            ),
            // confirm password textfiled
            CustomTextFiled(
              hintText: "Confirm password",
              obsucureText: true,
              controller: _confirmPwControlller,
            ),
            const SizedBox(
              height: 25,
            ),
            // register button
            CustomButton(onTap: () => register(context), text: "Register"),
            const SizedBox(
              height: 25,
            ),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
