import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main(){
  runApp(Test());
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
      ),
    );
  }
}
