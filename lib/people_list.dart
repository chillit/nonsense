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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (_) {
                  setState(() {}); // Update the UI when the search text changes
                },
                decoration: InputDecoration(
                  hintText: 'Поиск курсов',
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
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10.0),
                itemCount: _dataList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> value = _dataList[index];

                  // Filter the list based on the search text
                  String fio = value['DisplayNameAll'].toString().toLowerCase();
                  String searchText = _searchController.text.toLowerCase();
                  if (!fio.contains(searchText)) {
                    return SizedBox.shrink(); // Hide if not matching search text
                  }

                  // Combine class number and letter
                  String combinedClass = "$selectedClass$selectedLetter";

                  // Filter based on selected class
                  if (selectedClass != null && combinedClass != value["DivisionName"]) {
                    return Container();
                  }

                  // Filter based on selected roles
                  if (selectedRoles.isNotEmpty && !selectedRoles.contains(value['PostName'])) {
                    return SizedBox.shrink();
                  }

                  // Filter based on inSchool status
                  if (InSchool && value['Status'] != "1") {
                    return SizedBox.shrink();
                  }

                  return PersonTile(
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
                value: InSchool,
                onChanged: (bool value) {
                  setState(() {
                    InSchool = value;
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
                    InSchool = false;
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
    );
  }
}


class PersonTile extends StatefulWidget {
  const PersonTile({super.key, required this.fio, required this.inSchool, required this.curator, required this.clas, required this.maxin, required this.maxout, required this.minin, required this.role});
  final String fio, curator,clas,maxin,maxout,minin,role;
  final bool inSchool;
  @override
  State<PersonTile> createState() => _PersonTileState();
}

class _PersonTileState extends State<PersonTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (BuildContext context){
          return PersonInfoDialog(fio: widget.fio, curator: widget.curator, inSchool: widget.inSchool,);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,),
        child: SizedBox(
          width: double.infinity,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 242, 241, 247),
                  border: Border.all(color: Colors.grey, width: 0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.fio,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Куратор:',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 20,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.inSchool ? "В школе" : "Не в школе",
                            style: TextStyle(fontSize: 15,),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.curator,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 15,),
                          ),
                        ),
                      ),
                    ],
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