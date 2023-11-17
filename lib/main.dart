import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nonsense/people_list.dart';
import 'package:nonsense/Login_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCbzuhWcyuvbGg5tLE01P6Zbi1AL2XP5y0",
          authDomain: "nonsense-378e9.firebaseapp.com",
          projectId: "nonsense-378e9",
          storageBucket: "nonsense-378e9.appspot.com",
          messagingSenderId: "767035250430",
          appId: "1:767035250430:web:098b4d8a8660fa67bc77af",
          measurementId: "G-9LN8KYQ05P")
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "NIS Security",
    theme: ThemeData(
      fontFamily: 'Futura',
    ),
    home: LoginPage(),
    // Login()
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  bool isStudent = false; // Track whether the user is a student or not
  List<String> classes = ['7', '8', '9', '10', '11', '12'];
  List<String> letters = ['A', 'B', 'C', 'D', 'E'];
  String? selectedClass = "7";
  String? selectedLetter;
  List<String> roles = ["Ученик", "Куратор", "Учитель", "Тех-персонал", "Администрация"];
  List<String> selectedRoles = [];
  void initState() {
    super.initState();
    selectedClass = "7"; // Например, '7'
    selectedLetter = "A"; // Например, 'A'
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('NEskuchnoAta')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsetsDirectional.only(start: 16),
              child: Text(
                'Фильтры:',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontFamily: 'Futura'),
              ),),
            ListTile(
              title: Text('В школе'),
              trailing: Switch(
                value: isStudent,
                onChanged: (bool value) {
                  setState(() {
                    isStudent = value;
                    selectedClass = null; // Reset selected class when switching between student and non-student
                  });
                },
              ),
            ),
              Wrap(
                spacing: 8.0,
                runSpacing: 16.0,
                children: roles.map((role) => FilterChip(
                  label: Text(role),
                  selected: selectedRoles.contains(role),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedRoles.add(role);
                      } else {
                        selectedRoles.remove(role);
                      }
                    });
                  },
                )).toList(),
              ),
            if (isStudent) ...[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16),
                child: Text(
                  'Выберите класс и букву:',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontFamily: 'Futura'),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Выбор класса
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedClass,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue;
                          });
                        },
                        items: classes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Выбор буквы
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedLetter,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLetter = newValue;
                          });
                        },
                        items: letters.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 16,end: 16),
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isStudent = false;
                    selectedRoles.clear();
                    selectedClass = null;
                    selectedLetter = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Замените на ваш цвет по вашему выбору
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Сбросить фильтры',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontFamily: 'Futura',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                SizedBox(width: 16,),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 6,),
                Text('ОПАСНАЯ ЗОНА',style: TextStyle(color: Colors.red),),
                SizedBox(width: 6,),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 16,),
              ],
            ),
            SizedBox(height: 16,),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20,end: 20),
              child: ElevatedButton(onPressed:
                  (){
              },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Выйти с аккаунта',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontFamily: 'Futura',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}