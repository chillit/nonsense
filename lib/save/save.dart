import 'package:flutter/material.dart';

class PersonInfoDialog extends StatelessWidget {
  const PersonInfoDialog({super.key, required this.fio, required this.curator, required this.inSchool});
  final String fio, curator;
  final bool inSchool;
  @override
  Widget build(BuildContext context) {
    return Dialog(

      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(10),
        ),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Material(
                color: Colors.black12,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  width: 500,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 201, 201, 201),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, -1),
                          child: Material(
                            color: Color.fromRGBO(47, 16, 91, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 14),
                                      child: IconButton(
                                        hoverColor: Colors.transparent,
                                        color: Colors.transparent,
                                        icon: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            15, 15, 0, 17),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 25,
                                          child: Text(
                                            fio,
                                            // inSchool?"В школе": "Не в школе",
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(47, 16, 91, 1), // Color of the border
                              width: 2, // Width of the border
                            ),

                            borderRadius: BorderRadius.vertical(bottom:Radius.circular(10),),
                            color: Color.fromRGBO(47, 16, 91, 1),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.only(left: 7,right: 7,bottom: 7),
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(bottom:Radius.circular(10) ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          30, 14, 70, 0),
                                      child: Text(
                                        'Куратор: $curator',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        18, 0, 60, 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 3,
                                          decoration: BoxDecoration(
                                            color: inSchool ? Colors.green : Colors.red,
                                            boxShadow: inSchool
                                                ? [
                                              BoxShadow(
                                                color: Colors.green,
                                                blurRadius: 7.0,
                                                spreadRadius: 2.0,
                                              ),
                                            ]
                                                : [
                                              BoxShadow(
                                                color: Colors.red,
                                                blurRadius: 7.0,
                                                spreadRadius: 2.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          inSchool ? "В школе" : "Не в школе",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
