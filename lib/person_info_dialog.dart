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
                            color: Colors.white,
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
                                          10, 0, 0, 0),
                                      child: IconButton(
                                        hoverColor: Colors.transparent,
                                        color: Colors.transparent,
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black,
                                          size: 24,
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
                                                30, 0, 0, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            fio,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
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
                          height: 180,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      50, 15, 70, 0),
                                  child: Text(
                                    'Куратор: $curator',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      50, 0, 70, 20),
                                  child: Text(
                                    inSchool ? "В школе" : "Не в школе",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 100,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.white54,
                        //   ),
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsetsDirectional.fromSTEB(50, 0, 50, 50),
                        //     child: ElevatedButton(
                        //       onPressed: count != max
                        //           ? () {
                        //               AwesomeDialog(
                        //                 context: context,
                        //                 dialogType: DialogType.success,
                        //                 animType: AnimType.bottomSlide,
                        //                 showCloseIcon: false,
                        //                 title: 'Успешно!',
                        //                 desc: 'Вы успешно записались на курс!!',
                        //                 width: 500,
                        //                 btnOkText: 'Хорошо',
                        //                 btnOkOnPress: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //               ).show();
                        //             }
                        //           : null,
                        //       style: ElevatedButton.styleFrom(
                        //         padding: EdgeInsets.symmetric(horizontal: 24),
                        //         primary: count == max
                        //             ? Colors.grey
                        //             : DarkPurple, // Replace with your desired button color
                        //         elevation: 3,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(8),
                        //         ),
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             'Записаться',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.w100,
                        //               fontFamily: 'Poppins',
                        //               color: Colors.white,
                        //               fontSize: 16,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
