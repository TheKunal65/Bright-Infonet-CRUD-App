import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kunal_bright_infonet/pages/employee_form.dart';
import 'package:kunal_bright_infonet/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeData();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeesDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name: " + ds["Name"],
                                    style: TextStyle(fontFamily: "Dela"),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        nameController.text = ds["Name"];
                                        ageController.text = ds["Age"];
                                        locationController.text =
                                            ds["Location"];
                                        editEmployeeData(ds["Id"].toString());
                                      },
                                      child: Icon(Icons.edit)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: GestureDetector(
                                        onTap: () async {
                                          await DatabaseMethods()
                                              .deleteEmployeeData(
                                                  ds["Id"].toString());
                                        },
                                        child: Icon(Icons.delete)),
                                  )
                                ],
                              ),
                              Text(
                                "Age: " + ds["Age"],
                                style: TextStyle(fontFamily: "Dela"),
                              ),
                              Text(
                                "Location: " + ds["Location"],
                                style: TextStyle(fontFamily: "Dela"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeForm(),
                ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          toolbarHeight: 80,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40))),
          title: Text(
            "Bright Infonet CRUD",
            style: TextStyle(color: Colors.white, fontFamily: "Dela"),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              Expanded(child: allEmployeesDetails()),
            ],
          ),
        ));
  }

  Future editEmployeeData(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(width: 10),
                      Text("Edit Details",
                          style: TextStyle(fontFamily: "Dela", fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Name",
                      style: TextStyle(fontSize: 20, fontFamily: "Dela")),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Age",
                      style: TextStyle(fontSize: 20, fontFamily: "Dela")),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Location",
                      style: TextStyle(fontSize: 20, fontFamily: "Dela")),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updateInfo = {
                          "Name": nameController.text,
                          "Age": ageController.text,
                          "Id": id, // Use the `id` string directly
                          "Location": locationController.text,
                        };
                        await DatabaseMethods()
                            .updateEmployeeData(id, updateInfo)
                            .then((value) {
                          Navigator.pop(context); // Close the dialog
                        });
                      },
                      child: Text(
                        "Update",
                        style:
                            TextStyle(fontFamily: "Dela", color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ));
}
