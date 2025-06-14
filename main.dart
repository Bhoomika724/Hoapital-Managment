import 'package:flutter/material.dart';

void main() => runApp(SmartDisplayApp());

class SmartDisplayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wenlock Hospital',
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isStaffView = false;
  String emergencyCode = '';

  // Simulated token queue (based on token_queue.csv)
  final List<Map<String, String>> tokenQueue = [
    {'token_id': '101', 'patient': 'A. Kumar', 'dept': 'Cardiology', 'status': 'Waiting'},
    {'token_id': '102', 'patient': 'B. Reddy', 'dept': 'Cardiology', 'status': 'Called'},
    {'token_id': '205', 'patient': 'C. Fernandes', 'dept': 'Orthopedics', 'status': 'Waiting'},
    {'token_id': '310', 'patient': 'D. Shetty', 'dept': 'General Medicine', 'status': 'In Progress'},
  ];

  // Simulated drug inventory (based on drug_inventory.csv)
  final List<Map<String, String>> inventory = [
    {'drug': 'Paracetamol 500mg', 'status': 'Available'},
    {'drug': 'Amoxicillin 250mg', 'status': 'Low Stock'},
    {'drug': 'Insulin Injection', 'status': 'Out of Stock'},
    {'drug': 'ORS Sachet', 'status': 'Available'},
  ];

  void triggerEmergency(String code) {
    setState(() {
      emergencyCode = code;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        emergencyCode = '';
      });
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Wenlock Hospital',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz, color: Colors.white),
            onPressed: () {
              setState(() {
                isStaffView = !isStaffView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (emergencyCode.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: emergencyCode == 'Code Blue' ? Colors.blue : Colors.red,
              child: Center(
                child: Text(
                  '$emergencyCode Alert!',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isStaffView ? 'Staff-Facing View: OT/Consultation + Inventory' : 'Patient-Facing View: OT/Consultation Schedules',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: isStaffView ? buildStaffView() : buildPatientView()),
        ],
      ),
      floatingActionButton: isStaffView
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  onPressed: () => triggerEmergency('Code Blue'),
                  label: Text('Code Blue'),
                  icon: Icon(Icons.warning),
                  backgroundColor: Colors.blue,
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () => triggerEmergency('Code Red'),
                  label: Text('Code Red'),
                  icon: Icon(Icons.warning_amber),
                  backgroundColor: Colors.red,
                ),
              ],
            )
          : null,
    );
  }

  Widget buildPatientView() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Text("Current Token Queue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...tokenQueue.map((entry) => Card(
              child: ListTile(
                leading: Icon(Icons.confirmation_number),
                title: Text('Token: ${entry['token_id']} - ${entry['patient']}'),
                subtitle: Text('${entry['dept']} - Status: ${entry['status']}'),
              ),
            )),
      ],
    );
  }

  Widget buildStaffView() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Text("Drug Inventory", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...inventory.map((item) => Card(
              child: ListTile(
                title: Text(item['drug']!),
                trailing: Text(
                  item['status']!,
                  style: TextStyle(color: getStatusColor(item['status']!)),
                ),
              ),
            )),
        SizedBox(height: 20),
        Text("OT/Consultation Schedules", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...tokenQueue.map((entry) => Card(
              child: ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Token: ${entry['token_id']} - ${entry['patient']}'),
                subtitle: Text('${entry['dept']} - Status: ${entry['status']}'),
              ),
            )),
      ],
    );
  }
}
