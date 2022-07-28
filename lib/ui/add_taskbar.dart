import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp2_algorizatask2/controller/task_controller.dart';
import 'package:todoapp2_algorizatask2/models/task.dart';
import 'package:todoapp2_algorizatask2/ui/home_page.dart';
import 'package:todoapp2_algorizatask2/ui/theme.dart';
import 'package:todoapp2_algorizatask2/ui/widgets/button.dart';
import 'package:todoapp2_algorizatask2/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly'
  ];

  int _selectColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor ,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20 , right: 20),
        child : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Add Task',
                style:
                    headingStyle,
              ),
              const SizedBox(height: 20,),
              Text(
                'Title',
                style: headingStyle,
              ),
              TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your title',
            ),
                controller: _titleController,
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                'Note',
                style: headingStyle,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your note',
                ),
                controller: _noteController,
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                'Date',
                style: headingStyle,
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      print('hi there');
                    },
                    icon: Icon(Icons.calendar_today_outlined) ,
                    color: Colors.grey ,
                  ),
                  border: UnderlineInputBorder(),
                  labelText: DateFormat.yMd().format(_selectedDate),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              _getDateFormUser(isStartTime:true);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: _startTime,
                          labelText: ' start date',
                        ),
                      ),
                  ),
                  SizedBox(width:12,),
                  Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon:  IconButton(
                            onPressed: () {
                              _getDateFormUser(isStartTime:false);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: _endTime,
                          labelText: 'End date'
                        ),
                      )
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: DropdownButton(
                    icon:  Icon(Icons.keyboard_arrow_down),
                    iconDisabledColor: Colors.grey,
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged:(String? newValue){
                      setState(() {
                        _selectedRemind = int .parse(newValue!);
                      });
                    } ,
                    items: remindList.map<DropdownMenuItem<String>>((int value){
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }
                  ).toList(),
                  ),
                  hintText: '$_selectedRemind minutes early',
                  labelText: 'Reminder'
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    suffixIcon: DropdownButton(
                      icon:  Icon(Icons.keyboard_arrow_down),
                      iconDisabledColor: Colors.grey,
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged:(String? newValue){
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      } ,
                      items: repeatList.map<DropdownMenuItem<String>>((String? value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                              value!,
                             style: TextStyle(
                                  color: Colors.grey
                              )
                          ),
                        );
                      }
                      ).toList(),
                    ),
                    hintText: '$_selectedRepeat',
                    labelText: 'Repeat'
                ),
              ),
              const SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(
                      label: 'Create Task',
                      onTap: ()=> _validateDate(),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }

  _validateDate(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
     _addtaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty ){
      Get.snackbar('Require', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded),
      //  color:Colors.red,
      );
    }
  }

  _addtaskToDb() async {
    int value = await _taskController.addTask(
        task:Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectColor,
          isCompleted: 0,
        )
    );
    print ('My id is '+'$value');
  }
  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(height:8,),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index){
                return  GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectColor = index ;
                      print('$index');
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0 ? primaryClr : index ==1? pinkClr : yellowClr,
                      child: _selectColor == index? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      ) : Container(),
                    ),
                  ),
                );
              }
          ),
        ),

      ],
    );

  }
  _appBar(BuildContext context){
    return AppBar(
      elevation:0 ,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage() ));

        },
        child: Icon(
          Icons.arrow_back_ios,
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

  _getDateFormUser({required bool isStartTime}) async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2022)
    );

    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    }else{
      print('something went wrong');
    }
  }

 _getTimeFormUser({ required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      print('Time canceled');
    }else if(isStartTime == true){
      setState(() {
        _startTime =_formatedTime;
      });
    }else if(_startTime == false){
      setState(() {
        _endTime=_formatedTime;
      });
    }
  }

_showTimePicker(){
  return showTimePicker(
    initialEntryMode: TimePickerEntryMode.input,
      context: context,
  initialTime: TimeOfDay(
      hour: int.parse(_startTime.split(':')[0]),
      minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
  ),
  );
}


}
