import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wtracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:wtracker/src/features/authentication/screens/login/login_screen.dart';
import '../features/authentication/screens/profile/profile_screen.dart'; // Replace with the correct path
import '../features/authentication/screens/welcome/welcome.dart'; // Replace with the correct path

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(LineAwesomeIcons.user, size: 30, color: Colors.black),
              onPressed: () {
                // Navigate to the ProfileScreen when the profile button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(LineAwesomeIcons.home, size: 30, color: Colors.black),
              onPressed: () {
                // Navigate to the Welcome screen when the home button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Welcome()),
                );
              },
            ),
            IconButton(
              icon: const Icon(LineAwesomeIcons.alternate_sign_out,
                  size: 30, color: Colors.black),
              onPressed: () {
                AuthenticationRepository.instance.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
