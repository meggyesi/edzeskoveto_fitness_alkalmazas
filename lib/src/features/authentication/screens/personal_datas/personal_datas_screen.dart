import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtracker/src/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/image_strings.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../welcome/welcome.dart'; // Add the correct file path.
import '../../../../repository/user_repository/user_repository.dart';
import '../../models/user_model.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  String? _selectedGender;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  Future<void> _handleDataSubmission() async {
    if (_formKey.currentState!.validate()) {
      // Get the current user ID
      String? userId = AuthenticationRepository.instance.currentUser?.uid;

      if (userId != null) {
        // Create user in Firestore if it doesn't exist, otherwise update personal data
        UserModel newUser = UserModel(
          email: '',
          userId: userId,
          fullName: _fullNameController.text.trim(),
          gender: _selectedGender,
          height: double.tryParse(_heightController.text.trim()),
          weight: double.tryParse(_weightController.text.trim()),
          birthDate: _selectedDate,
        );

        DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .get();

        if (userDocSnapshot.exists) {
          UserRepository.instance.updateUser(newUser);
        } else {
          UserRepository.instance.createUser(newUser);
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Welcome(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: Image(
                      image: AssetImage(barbellLogo),
                      width: 130.0,
                      height: 65.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: defaultSize - 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                              label:
                                  Text(AppLocalizations.of(context)!.fullName),
                              prefixIcon:
                                  const Icon(Icons.person_outline_rounded)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _heightController,
                          decoration: InputDecoration(
                              label: Text(AppLocalizations.of(context)!.height),
                              prefixIcon: const Icon(Icons.height)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your height';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.scale_outlined),
                            label: Text(AppLocalizations.of(context)!.weight),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Gender Dropdown
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.grey[200],
                            textTheme: const TextTheme(
                              titleMedium:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.people),
                              labelText: AppLocalizations.of(context)!.gender,
                              border: const OutlineInputBorder(),
                            ),
                            items: <String>[
                              AppLocalizations.of(context)!.male,
                              AppLocalizations.of(context)!.female,
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Date Picker
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.birthDate,
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              _selectedDate = pickedDate;
                              _dateController.text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your birth date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleDataSubmission,
                            child: Text(
                              AppLocalizations.of(context)!.continouText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
