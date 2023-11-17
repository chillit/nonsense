import 'package:flutter/material.dart';
import 'package:nonsense/person_info_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({Key? key}) : super(key: key);

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase().reference().child('users');
  List<Map<String, dynamic>> _dataList = [];
  bool isGRAY = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData() async {
    try {
      DatabaseEvent dataSnapshot = await _database.once();
      if (dataSnapshot.snapshot.value != null) {
        List<dynamic> dataList = dataSnapshot.snapshot.value as List<dynamic>;
        setState(() {
          _dataList = List<Map<String, dynamic>>.from(dataList);
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
  bool InSchool = true; // Track whether the user is a student or not
  List<String> classes = ['7', '8', '9', '10', '11', '12'];
  List<String> letters = ['A', 'B', 'C', 'D', 'E'];
  String? selectedClass = "7";
  String? selectedLetter;
  List<String> roles = ["Ученик", "Куратор", "Учитель", "Тех-персонал", "Администрация"];
  List<String> selectedRoles = [];
  bool includeInternat = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(child: Text('NIS Security')),
        leading: IconButton( // Use leading property instead of actions
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15,bottom: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {}); // Update the UI when the search text changes
                  },
                  decoration: InputDecoration(
                    hintText: 'Поиск',
                    suffixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 242, 241, 247),
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseDatabase.instance.ref().child('users').onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data!.snapshot.value.runtimeType !=
                      List<dynamic>) {
                    return Center(
                      child: Text('Ошибка'),
                    );
                  }
                  List<dynamic> _dataList =
                      snapshot.data?.snapshot.value as List<dynamic>;
                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(10.0),
                      itemCount: _dataList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> value = _dataList[index];

                        // Filter the list based on the search text
                        String fio =
                            value['DisplayNameAll'].toString().toLowerCase();
                        String clas = value["DivisionName"].toString().toLowerCase();
                        String searchText =
                            _searchController.text.toLowerCase();
                        if ("${fio} ${clas}".contains(searchText)) {
                          return Container(); // Hide if not matching search text
                        }

                        // Combine class number and letter
                        String combinedClass = "$selectedClass$selectedLetter";

                        // Filter based on selected class
                        if ((selectedRoles.contains('Ученик') || selectedRoles.contains('Ученик инт'))
                          && selectedClass != null &&
                            selectedLetter != null &&
                            combinedClass != value["DivisionName"]) {
                          return Container();
                        }

                        // Filter based on selected roles
                        if (selectedRoles.isNotEmpty &&
                            !selectedRoles.contains(value['PostName'])) {
                          return Container();
                        }

                        // Filter based on inSchool status
                        if (InSchool && value['Status'] != "1") {
                          return Container();
                        }

                        isGRAY = !isGRAY;

                        return PersonTile(
                          isGray: isGRAY,
                          role: value["PostName"],
                          maxin: value["MaxIn"],
                          minin: value["MinIn"],
                          maxout: value["MaxOut"],
                          clas: value["DivisionName"],
                          fio: value['DisplayNameAll'],
                          inSchool: value['Status'] == "1",
                          curator: value['Manager'],
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 16),
              child: Text(
                'Фильтры:',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontFamily: 'Futura'),
              ),
            ),
            ListTile(
              title: Text('В школе'),
              trailing: Switch(
                value: InSchool,
                onChanged: (bool value) {
                  setState(() {
                    InSchool = value;
                    selectedClass =
                        null; // Reset selected class when switching between student and non-student
                  });
                },
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 16.0,
              children: roles
                  .map((role) => FilterChip(
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
                      ))
                  .toList(),
            ),
            if (selectedRoles.contains("Ученик")) ...[
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
              // Show class selection only when the role is "Ученик"
              if (selectedRoles.contains("Ученик")) ...[
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
                          items: classes
                              .map<DropdownMenuItem<String>>((String value) {
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
                          items: letters
                              .map<DropdownMenuItem<String>>((String value) {
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
                ListTile(
                  title: Text('Включать интернатовцев'),
                  trailing: Switch(
                    value: includeInternat,
                    onChanged: (bool value) {
                      setState(() {
                        includeInternat = value;
                      });
                      if (includeInternat) {
                        selectedRoles.add('Ученик инт');
                      } else {
                        selectedRoles.remove('Ученик инт');
                      }
                    },
                  ),
                ),
              ],
            ],
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 16, end: 16),
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    InSchool = false;
                    selectedRoles.clear();
                    selectedClass = null;
                    selectedLetter = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey, // Замените на ваш цвет по вашему выбору
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
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'ОПАСНАЯ ЗОНА',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonTile extends StatefulWidget {
  PersonTile(
      {super.key,
        required this.isGray,
      required this.fio,
      required this.inSchool,
      required this.curator,
      required this.clas,
      required this.maxin,
      required this.maxout,
      required this.minin,
      required this.role});
  final String fio, curator, clas, maxin, maxout, minin, role;
  final bool inSchool;
  bool isGray;
  @override
  State<PersonTile> createState() => _PersonTileState();
}

class _PersonTileState extends State<PersonTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return PersonInfoDialog(
                fio: widget.fio,
                curator: widget.curator,
                inSchool: widget.inSchool,
                clas: widget.clas,
                maxin: widget.maxin,
                maxout: widget.maxout,
                minin: widget.minin,
                role: widget.role,
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Material(
            child: Container(
              padding: EdgeInsets.only(top: 0,bottom: 0,right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: widget.isGray?Colors.grey[250]:Color.fromARGB(255, 242, 241, 247),
                  border: Border.all(color: Colors.transparent, width: 0)),
              child: Row(
                children: [
                  // Glowing stick
                  Container(
                    height: 70,
                    width: 10,
                    decoration: BoxDecoration(
                      color: widget.inSchool ?  Colors.red: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: widget.inSchool ?  Colors.red :Colors.green ,
                          blurRadius: 0,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between the stick and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.fio} ${widget.clas}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.inSchool ? "В школе" : "Не в школе",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Куратор: ${widget.curator}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
