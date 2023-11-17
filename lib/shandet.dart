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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('NEskuchnoAta')),
        actions: <Widget>[],
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
                  if (!fio.contains(searchText) || value['Manager'] != widget.curator) {
                    return SizedBox.shrink(); // Hide if not matching search text or manager is different
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