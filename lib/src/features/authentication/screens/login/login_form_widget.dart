import 'package:flutter/material.dart';
import 'package:wtracker/src/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wtracker/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:wtracker/src/features/authentication/screens/welcome/welcome.dart';
import '../../controllers/SignUpController.dart';
import 'package:uuid/uuid.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool loggedIn = await SignUpController.instance.userLogin(email, password);

    if (loggedIn) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Welcome()),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Please check your email and password.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _guestLogin() async {
    var uuid = const Uuid();
    final email = '${uuid.v4().substring(0, 25)}@gmail.com';
    final password = uuid.v4().substring(0, 10);

    bool loggedIn =
        await SignUpController.instance.userRegister(email, password);

    if (loggedIn) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Welcome()),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Please check your email and password.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: defaultSize - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: "E-Mail",
                hintText: "E-Mail",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: defaultSize - 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: _isHidden,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint_sharp),
                labelText: "Password",
                hintText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _toggleVisibility,
                  icon: Icon(
                    _isHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: defaultSize - 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.forgetPasswordText,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                child: Text(
                  AppLocalizations.of(context)!.loginText,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: defaultSize - 10,
                ),
                Text(AppLocalizations.of(context)!.loginOr),
                const SizedBox(
                  height: defaultSize - 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guestLogin,
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(
                          255, 227, 223, 223), // Set the button color to white
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signInWithGoogle,
                      style: TextStyle(
                        color: Colors
                            .black, // Set the text color to black or any other color you prefer
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: Text.rich(TextSpan(
                        text: AppLocalizations.of(context)!.noAccount,
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.register,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ]))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
