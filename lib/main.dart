import 'package:flutter/material.dart';
import 'package:local_database/models/student.dart';
import 'package:local_database/utils/db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/": (context) => Home()},
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Student> studentList = List<Student>();
  DbHelper _dbHelper = DbHelper();

  bool isActive = false;
  var nameController = TextEditingController();

  var selectedIndex;
  var selectedId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //dbden gelen veriler map yapisinda oldugu icin student objesine cevrilmeli
    _dbHelper.getStudents().then((value) {
      for (var studentMap in value) {
        studentList.add(Student.fromMap(studentMap));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Sqflite Usage"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.length < 3) {
                          return "name must be at least 4 chracters";
                        } else
                          return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Student Name"),
                    ),
                    SwitchListTile(
                        value: isActive,
                        title: Text(
                          "Active",
                          style: TextStyle(color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        })
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.green.shade300),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        addStudent(Student(
                            nameController.text, isActive == true ? 1 : 0));
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.blue.shade300),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        updateStudent(Student.withId(selectedId,
                            nameController.text, isActive == true ? 1 : 0));
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Clear Table",
                      style: TextStyle(color: Colors.red.shade300),
                    ),
                    onPressed: () {
                      deleteTable();
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: studentList[index].isActive == 1
                            ? Colors.green
                            : Colors.red,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              nameController.text = studentList[index].name;
                              isActive = studentList[index].isActive == 1
                                  ? true
                                  : false;
                            });
                            selectedIndex = index;
                            selectedId = studentList[index].id;
                          },
                          title: Text(studentList[index].name),
                          subtitle: Text(studentList[index].id.toString()),
                          trailing: GestureDetector(
                            onTap: () {
                              deleteStudent(studentList[index].id, index);
                            },
                            child: Icon(Icons.delete),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addStudent(Student student) async {
    var id = await _dbHelper.insert(student);
    if (id > 0) {
      student.id = id;
      setState(() {
        studentList.insert(0, student);
        nameController.text = " ";
        isActive = false;
      });
    }
  }

  void deleteTable() async {
    var result = await _dbHelper.deleteTable();
    if (result > 0) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${studentList.length} adet ogrenci silindi"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        studentList.clear();
      });
    }
  }

  void deleteStudent(int id, int index) async {
    var result = await _dbHelper.delete(id);
    if (result > 0) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Deleted"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        studentList.removeAt(index);
      });
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Error"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  void updateStudent(Student student) async {
    var result = await _dbHelper.update(student);
    if (result == 1) {
      setState(() {
        studentList[selectedIndex] = student;
      });
    }
  }
}
