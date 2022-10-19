import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify_app/services/notification_services.dart';
import 'package:notify_app/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:notify_app/ui/theme.dart';
import 'package:notify_app/ui/widgets/button.dart';
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
        children:  [
          _addTaskBar(),
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activated Light Theme Alex": "Activated Dark Theme Alex"
          );
        },
        child:  Icon(Get.isDarkMode?Icons.sunny:Icons.nightlight_round,
        color: Get.isDarkMode ? Colors.white: Colors.black,
        size: 25,),
      ),
      actions: const [
        CircleAvatar(

          backgroundImage: AssetImage(
            "images/alex.jpg"
          ),

        ),
        SizedBox(width: 20,)
      ],
    );
  }

  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),

                Text("Today", style: headingStyle,)
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: ()=>null)
        ],
      ),
    );
  }
}
