import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notify_app/controllers/task_controller.dart';
import 'package:notify_app/services/notification_services.dart';
import 'package:notify_app/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:notify_app/ui/add_task_bar.dart';
import 'package:notify_app/ui/theme.dart';
import 'package:notify_app/ui/widgets/button.dart';
import 'package:notify_app/ui/widgets/task_tile.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    notifyHelper.displayNotification(
        title: "Theme Changed",
        body:
            Get.isDarkMode ? "Dark Mode" : "Light Mode");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTasks(),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Light Mode"
                  : "Activated Dark Mode");
        },
        child: Icon(
          Get.isDarkMode ? Icons.sunny : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 25,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/alex.jpg"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: () async {
          await  Get.to(AddTaskPage());
          _taskController.getTasks();
          })
        ],
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey),
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate = date;
          });
          // _selectedDate = date;
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted==1?
          MediaQuery.of(context).size.height*0.24:
          MediaQuery.of(context).size.height*0.32,
          color: Get.isDarkMode?darkGreyClr:Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
                ),
              ),
                Spacer(),
                task.isCompleted==1?Container():
                    _bottomSheetButton(label: "Task Completed", onTap: (){
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    }, clr: primaryClr,context:context),

              _bottomSheetButton(label: "Delete Task", onTap: (){
                _taskController.delete(task);
                // _taskController.getTasks();
                Get.back();
              }, clr: Colors.red[300]!,context:context),
              SizedBox(height: 20,),

              _bottomSheetButton(label: "Close", onTap: (){
                Get.back();
              }, clr: Colors.red[300]!,context:context,isClose: true),
              SizedBox(height: 5,),
            ],
          ),
        ),
      );
  }

_bottomSheetButton({
    required String label,
  required Function()? onTap,
  required Color clr,
  bool isClose=false,
  required BuildContext context,
}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
          ),
          borderRadius: BorderRadius.circular(20,),
          color: isClose==true?Colors.transparent:clr,

        ),
        child: Center(
          child: Text(label,
          style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white)),
        )
      ),
    );
}

  _showTasks(){
    print(_taskController.taskList.length);
    return Expanded(

      child: Obx((){
        return ListView.builder(

            itemCount: _taskController.taskList.length,
            itemBuilder: (_,index){
            print(_taskController.taskList.length);
            Task task = _taskController.taskList[index];
            if(task.repeat=='Daily'){

              notifyHelper.scheduledNotification(
                int.parse(task.startTime.toString().split(":")[0]),
                int.parse(task.startTime.toString().split(":")[1]),
                task
              );
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSheet(context,task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  )
              );

            }
            if(task.date==DateFormat.yMd().format(_selectedDate)){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSheet(context,task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  )
              );

            }else{
              return Container();
            }
          //   GestureDetector(
          //   onTap: (){
          //      _taskController.delete(_taskController.taskList[index]);
          //      _taskController.getTasks();
          //   },
          //   child: Container(
          //     width: 100,
          //     height: 50,
          //     color: Colors.brown,
          //     margin: const EdgeInsets.only(bottom: 10),
          //     child: Text(
          //       _taskController.taskList[index].title.toString()
          //     ),
          //   ),
          // );
        });
      }),

    );
  }
}
