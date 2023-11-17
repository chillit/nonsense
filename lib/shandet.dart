import 'package:flutter/material.dart';
import 'package:nonsense/person_info_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class shandet extends StatefulWidget {
  final String curator;
  const shandet({Key? key, required this.curator}) : super(key: key);

  @override
  State<shandet> createState() => _shandetState();
}

class _shandetState extends State<shandet> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _database =
      FirebaseDatabase().reference().child('users');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('NEskuchnoAta')),
        actions: <Widget>[],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(
                        () {}); // Update the UI when the search text changes
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

                  bool isGRAY = false;
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
                        String clas =
                            value["DivisionName"].toString().toLowerCase();
                        String searchText =
                            _searchController.text.toLowerCase();
                        if (!"${fio} ${clas}".contains(searchText)) {
                          return Container(); // Hide if not matching search text
                        }
                        String curator =
                            value['Manager'].toString().toLowerCase();
                        String wCurator = widget.curator.toLowerCase();
                        if (curator != wCurator) {
                          return Container();
                        }

                        isGRAY = !isGRAY;

                        return PersonTile(
                          index: index.toString(),
                          isGray: isGRAY,
                          role: value["PostName"],
                          maxin: value["MaxIn"],
                          minin: value["MinIn"],
                          maxout: value["MaxOut"],
                          clas: value["DivisionName"],
                          fio: value['DisplayNameAll'],
                          inSchool: value['Status'] != "1",
                          curator: value['Manager'],
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class PersonTile extends StatefulWidget {
  PersonTile(
      {super.key,
      required this.index,
      required this.isGray,
      required this.fio,
      required this.inSchool,
      required this.curator,
      required this.clas,
      required this.maxin,
      required this.maxout,
      required this.minin,
      required this.role});
  final String fio, curator, clas, maxin, maxout, minin, role, index;
  final bool inSchool;
  bool isGray;
  @override
  State<PersonTile> createState() => _PersonTileState();
}

class _PersonTileState extends State<PersonTile> {
  late bool isChecked; // Initialize the isChecked variable

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    // Initialize isChecked based on the inSchool property
    isChecked = !widget.inSchool;
  }

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
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: widget.isGray
                    ? Colors.grey[250]
                    : Color.fromARGB(255, 242, 241, 247),
                border: Border.all(color: Colors.transparent, width: 0),
              ),
              child: Row(
                children: [
                  // Glowing stick
                  Container(
                    height: 70,
                    width: 10,
                    decoration: BoxDecoration(
                      color: isChecked ? Colors.green : Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: isChecked ? Colors.green : Colors.red,
                          blurRadius: 0,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.fio} ${widget.clas}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              isChecked ? "Не в школе" : "В школе",
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
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                        _databaseReference
                            .child('users/${widget.index}/Status')
                            .set(isChecked ? 0 : 1);
                      });
                    },
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
