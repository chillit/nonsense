import 'package:flutter/material.dart';
class TEST_page extends StatefulWidget {
  const TEST_page({Key? key}) : super(key: key);

  @override
  State<TEST_page> createState() => _TEST_pageState();
}

class _TEST_pageState extends State<TEST_page> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("ЕСТ"),),);
  }
}
