import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wtracker/src/widgets/custom_bottom_navigation_bar.dart';
import 'package:wtracker/src/widgets/custom_app_bar.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  const BodyMeasurementsScreen({Key? key}) : super(key: key);

  @override
  _BodyMeasurementsScreenState createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> {
  TextEditingController datumController = TextEditingController();
  TextEditingController mellbosegController = TextEditingController();
  TextEditingController derekbosegController = TextEditingController();
  TextEditingController csipobosegController = TextEditingController();
  TextEditingController felkarBalController = TextEditingController();
  TextEditingController felkarJobbController = TextEditingController();
  TextEditingController combBalController = TextEditingController();
  TextEditingController combJobbController = TextEditingController();
  TextEditingController nyakController = TextEditingController();
  TextEditingController vallController = TextEditingController();
  TextEditingController alkarJobbController = TextEditingController();
  TextEditingController alkarBalController = TextEditingController();
  TextEditingController vadliBalController = TextEditingController();
  TextEditingController vadliJobbController = TextEditingController();

  bool isEdited = false;
  bool isEditing = false;

  DateTime? lastRecordedDate;
  int daysSinceLastRecording = 0;

  @override
  void initState() {
    super.initState();
    fetchMeasurementsData();
  }

  Future<void> fetchMeasurementsData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot userMeasuresSnapshot = await FirebaseFirestore.instance
            .collection('userMeasures')
            .doc(userId)
            .get();

        if (userMeasuresSnapshot.exists) {
          Map<String, dynamic> userMeasuresData =
              userMeasuresSnapshot.data() as Map<String, dynamic>;

          if (userMeasuresData['datum'] != null) {
            lastRecordedDate =
                (userMeasuresData['datum'] as Timestamp).toDate();
            daysSinceLastRecording =
                DateTime.now().difference(lastRecordedDate!).inDays;
          }

          mellbosegController.text = userMeasuresData['mellboseg'].toString();
          derekbosegController.text = userMeasuresData['derekboseg'].toString();
          csipobosegController.text = userMeasuresData['csipoboseg'].toString();
          felkarBalController.text = userMeasuresData['felkarBal'].toString();
          felkarJobbController.text = userMeasuresData['felkarJobb'].toString();
          combBalController.text = userMeasuresData['combBal'].toString();
          combJobbController.text = userMeasuresData['combJobb'].toString();
          nyakController.text = userMeasuresData['nyak'].toString();
          vallController.text = userMeasuresData['vall'].toString();
          alkarJobbController.text = userMeasuresData['alkarJobb'].toString();
          alkarBalController.text = userMeasuresData['alkarBal'].toString();
          vadliBalController.text = userMeasuresData['vadliBal'].toString();
          vadliJobbController.text = userMeasuresData['vadliJobb'].toString();

          setState(() {});
        }
      }
    } catch (error) {}
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void cancelEditing() {
    setState(() {
      isEditing = false;
      isEdited = false;
      fetchMeasurementsData();
    });
  }

  Future<void> saveMeasurements() async {
    if (isEdited) {
      try {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('userMeasures')
              .doc(userId)
              .set({
            'datum': DateTime.now(),
            'mellboseg': double.parse(mellbosegController.text),
            'derekboseg': double.parse(derekbosegController.text),
            'csipoboseg': double.parse(csipobosegController.text),
            'felkarBal': double.parse(felkarBalController.text),
            'felkarJobb': double.parse(felkarJobbController.text),
            'combBal': double.parse(combBalController.text),
            'combJobb': double.parse(combJobbController.text),
            'nyak': double.parse(nyakController.text),
            'vall': double.parse(vallController.text),
            'alkarJobb': double.parse(alkarJobbController.text),
            'alkarBal': double.parse(alkarBalController.text),
            'vadliBal': double.parse(vadliBalController.text),
            'vadliJobb': double.parse(vadliJobbController.text),
          });
        }
      } catch (error) {}

      setState(() {
        isEditing = false;
        isEdited = false;
        fetchMeasurementsData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Testkörméretek",
        actions: [
          if (isEditing)
            TextButton(
              onPressed: cancelEditing,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          if (isEditing && isEdited)
            TextButton(
              onPressed: saveMeasurements,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          if (!isEditing && !isEdited)
            TextButton(
              onPressed: startEditing,
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.blue),
              ),
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
                  const Text(
                    'Utolsó rögzítés: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$daysSinceLastRecording napja',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              buildMeasurementField(
                  'Mellbőség:', mellbosegController, TextInputType.number),
              buildMeasurementField(
                  'Derékbőség:', derekbosegController, TextInputType.number),
              buildMeasurementField(
                  'Csípőbőség:', csipobosegController, TextInputType.number),
              buildMeasurementField(
                  'Felkar (bal):', felkarBalController, TextInputType.number),
              buildMeasurementField(
                  'Felkar (jobb):', felkarJobbController, TextInputType.number),
              buildMeasurementField(
                  'Comb (bal):', combBalController, TextInputType.number),
              buildMeasurementField(
                  'Comb (jobb):', combJobbController, TextInputType.number),
              buildMeasurementField(
                  'Nyak:', nyakController, TextInputType.number),
              buildMeasurementField(
                  'Váll:', vallController, TextInputType.number),
              buildMeasurementField(
                  'Alkar (jobb):', alkarJobbController, TextInputType.number),
              buildMeasurementField(
                  'Alkar (bal):', alkarBalController, TextInputType.number),
              buildMeasurementField(
                  'Vádli (bal):', vadliBalController, TextInputType.number),
              buildMeasurementField(
                  'Vádli (jobb):', vadliJobbController, TextInputType.number),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget buildMeasurementField(
      String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        enabled: isEditing,
        onChanged: (text) {
          setState(() {
            isEdited = true;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
