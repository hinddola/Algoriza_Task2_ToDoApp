import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp2_algorizatask2/controller/task_controller.dart';
import 'package:todoapp2_algorizatask2/services/notification_services.dart';
import 'package:todoapp2_algorizatask2/services/theme_services.dart';
import 'package:todoapp2_algorizatask2/ui/add_taskbar.dart';
import 'package:todoapp2_algorizatask2/ui/theme.dart';
import 'package:todoapp2_algorizatask2/ui/widgets/button.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTasks(),
        ],
      ) ,
    );
  }

  _showTasks(){
    return Expanded(
        child: Obx((){
          return ListView.builder(
            itemCount: _taskController.taskList.length,
              itemBuilder:(_,context) {
                return Container(
                  width: 100,
                  height: 50,
                  color: Colors.green,
                );
              });
        }
        ),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20 , left : 20),
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
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date){
          _selectedDate = date ;
        },

      ),
    );
  }
  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left :20 , right : 20 , top : 10 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                 Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage() ));
            },
            //onTap: () => Get.to(AddTaskPage()),
          ),
        ],
      ),
    );

  }
  _appBar(){
    return AppBar(
      elevation:0 ,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title:"Theme Changed",
            body : Get.isDarkMode? "Activated Light Theme" : "Activated Dark Theme"
          );
          notifyHelper.scheduledNotification();
          },
        child: Icon(
            Get.isDarkMode? Icons.wb_sunny_outlined : Icons.nightlight_outlined ,
            size: 20,
            color : Get.isDarkMode? Colors.white : Colors.black
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            "images/person-png-icon-2.jpg",
          ),

        ),

        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
