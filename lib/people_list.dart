import 'package:flutter/material.dart';
import 'package:nonsense/person_info_dialog.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: TextField(
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
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10.0),
                children: [
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: true, curator: "Мөлдір Оразбаевна"),
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: false, curator: "Мөлдір Оразбаевна"),
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: true, curator: "Мөлдір Оразбаевна"),
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: true, curator: "Мөлдір Оразбаевна"),
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: true, curator: "Мөлдір Оразбаевна"),
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: false, curator: "Мөлдір Оразбаевна"),
                  PersonTile(fio: 'Человек Человеков Человекович', inSchool: true, curator: "Мөлдір Оразбаевна"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonTile extends StatefulWidget {
  const PersonTile({super.key, required this.fio, required this.inSchool, required this.curator});
  final String fio, curator;
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