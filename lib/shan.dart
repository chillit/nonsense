import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nonsense/shandet.dart';

class shan extends StatefulWidget {
  const shan({super.key});

  @override
  State<shan> createState() => _shanState();
}

class _shanState extends State<shan> {
  late Map<String, dynamic> currentUserData;
  final currentUser = FirebaseAuth.instance.currentUser;
  bool loading = true;
  final databaseReference = FirebaseDatabase.instance.reference().child('shan');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(child: Text('NIS Security')),
        leading: IconButton( // Use leading property instead of actions
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder<DatabaseEvent>(
          stream: databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              DataSnapshot dataValues = snapshot.data!.snapshot;
              if (dataValues.value != null) {
                List<dynamic> events = [];
                dynamic data = dataValues.value;
                if (data is List) {
                  events.addAll(data);
                } else if (data is Map) {
                  data.forEach((key, value) {
                    events.add({'key': key, 'value': value});
                  });
                }
                final double screenWidth = MediaQuery.of(context).size.width;
                final double screenHeight = MediaQuery.of(context).size.height;
                int crossAxisCount = 2;
                if (screenWidth > screenHeight) {
                  crossAxisCount = 4;
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                      },
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => shandet(curator: events[index]['value']),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Display key in the center
                                Text(
                                  '${events[index]['key']}',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                // Display image in the center
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      'assets/shan.png',
                                      width: 100, // Adjust the width as needed
                                      height: 100, // Adjust the height as needed
                                    ),
                                  ),
                                ),
                                // Display value in the center
                                Text(
                                  '${events[index]['value']}',
                                  style: TextStyle(fontSize: 16.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('Данные не найдены'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}