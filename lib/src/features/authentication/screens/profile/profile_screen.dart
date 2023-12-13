import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtracker/src/widgets/custom_bottom_navigation_bar.dart';
import 'package:wtracker/src/widgets/custom_app_bar.dart';
import '../../../../repository/user_repository/user_repository.dart';
import '../../models/user_model.dart';
import '../measurments/body_measurments_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _userRepository = Get.find<UserRepository>();

  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String nicknameValue = '';
  bool isEdited = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Load the user's profile data
    loadUserProfile();
  }

  void loadUserProfile() async {
    // Get the current user ID
    String userId = _userRepository.currentUser?.uid ?? '';

    // Fetch the user data from the repository
    UserModel user = await _userRepository.getUser(userId);

    // Set the text controllers with the user data
    nameController.text = user.fullName ?? '';
    genderController.text = user.gender ?? '';
    heightController.text = user.height?.toString() ?? '';
    weightController.text = user.weight?.toString() ?? '';
    ageController.text = user.birthDate?.toString() ?? '';
    nicknameValue = user.nickname ?? '';

    // Set the isEdited flag to false since the data is loaded
    setState(() {
      isEdited = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profil',
        actions: [
          if (!isEditMode)
            TextButton(
              onPressed: () {
                setState(() {
                  isEditMode = true;
                });
              },
              child: const Text('Edit', style: TextStyle(color: Colors.blue)),
            ),
          if (isEdited)
            TextButton(
              onPressed: () {
                // Save the profile information
                saveProfileInformation();
              },
              child: const Text('Save', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/profile/profile_picture.png'),
                    backgroundColor:
                        Colors.white, // Change background color to white
                    radius: 40,
                  ),
                  const SizedBox(width: 16),
                  Text(nicknameValue,
                      style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
              const SizedBox(height: 20),
              buildProfileField(
                  'Név és Vezetéknév:', nameController, TextInputType.text),
              buildProfileField('Nem:', genderController, TextInputType.text),
              buildProfileField(
                  'Magasság:', heightController, TextInputType.number),
              buildProfileField(
                  'Testsúly:', weightController, TextInputType.number),
              buildProfileField(
                  'Születési Dátum:', ageController, TextInputType.datetime),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BodyMeasurementsScreen(),
                      ),
                    );
                  },
                  child: const Text('Testkörméretek követése'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget buildProfileField(
      String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        enabled: isEditMode,
        controller: controller,
        keyboardType: inputType,
        onChanged: (text) {
          setState(() {
            isEdited = true;
          });
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(_getIconBasedOnLabel(label)),
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  IconData _getIconBasedOnLabel(String label) {
    switch (label) {
      case 'Név és Vezetéknév:':
        return Icons.account_circle;
      case 'Nem:':
        return Icons.person;
      case 'Magasság:':
        return Icons.height;
      case 'Testsúly:':
        return Icons.fitness_center;
      case 'Születési Dátum:':
        return Icons.calendar_today;
      default:
        return Icons.edit;
    }
  }

  void saveProfileInformation() async {
    String userId = _userRepository.currentUser?.uid ?? '';

    UserModel updatedUser = UserModel(
      email: '',
      userId: userId,
      fullName: nameController.text,
      gender: genderController.text,
      height: double.tryParse(heightController.text),
      weight: double.tryParse(weightController.text),
      birthDate: DateTime.tryParse(ageController.text),
    );

    await _userRepository.updateUser(updatedUser);

    setState(() {
      isEdited = false;
      isEditMode = false;
    });
  }
}
