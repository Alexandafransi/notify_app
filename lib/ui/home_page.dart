import 'package:flutter/material.dart';
import 'package:notify_app/services/notification_services.dart';
import 'package:notify_app/services/theme_services.dart';
import 'package:get/get.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.displayNotification(
      title: "Theme Changed",
      body: Get.isDarkMode? "Activated Dark Theme": "Activated Light Theme"
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: const [
          Text("",
          style: TextStyle(
            fontSize: 30
          ),
          )
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activated Light Theme Alex": "Activated Dark Theme Alex"
          );
        },
        child: const Icon(Icons.nightlight_round,
        size: 25,),
      ),
      actions: const [
        Icon(Icons.person, size: 25,),
        SizedBox(width: 20,)
      ],
    );
  }
}
