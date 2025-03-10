import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool today = true, tomorrow = false, nextweek = false;
  bool suggest = false;
  Stream? todoStream;

  // Removed duplicate declaration; only one instance is needed.
  TextEditingController todoController = TextEditingController();

  getontheload() async {
    todoStream = await DatabaseMethods().getalltheWork(
      today ? "Today" : tomorrow ? "Tomorrow" : "NextWeek",
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length, // Assuming snapshot.data.docs is correct.
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return CheckboxListTile(
              activeColor: const Color(0xff279cfb),
              title: Text(
                ds["Work"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: suggest,
              onChanged: (newValue) {
                setState(() {
                  suggest = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFF249fff),
          size: 30,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 90, left: 30),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff232fda),
              Color(0xff13D8CA),
              Color(0xff09adfe),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "HELLO\nVEER",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Good Morning!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // "Today" Option
                GestureDetector(
                  onTap: ()async {
                      today = true;
                      tomorrow = false;
                      nextweek = false;
                      await getontheload();
                      setState(() {

                      });
                  },
                  child: today
                      ? Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xff3dffe3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Today",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : const Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // "Tomorrow" Option
                GestureDetector(
                  onTap: () async{
                      today = false;
                      tomorrow = true;
                      nextweek = false;
                      await getontheload();
                      setState(() {

                      });
                  },
                  child: tomorrow
                      ? Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xff3dffe3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Tomorrow",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : const Text(
                    "Tomorrow",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // "Next Week" Option
                GestureDetector(
                  onTap: () async {
                      today = false;
                      tomorrow = false;
                      nextweek = true;
                      await getontheload();
                      setState(() {

                      });


                  },
                  child: nextweek
                      ? Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xff3dffe3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Next Week",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : const Text(
                    "Next Week",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: allWork()),
          ],
        ),
      ),
    );
  }

  Future openBox() => showDialog(
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
                  child: const Icon(Icons.cancel),
                ),
              ],
            ),
            const SizedBox(width: 60),
            const Text(
              "Add The Work ToDo",
              style: TextStyle(
                color: Color(0xff008080),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Add Text"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: todoController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Your Task",
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                String id = randomAlphaNumeric(10);
                Map<String, dynamic> userTodo = {
                  "Work": todoController.text,
                  "Id": id,
                };
                today
                    ? DatabaseMethods().addTodayWork(userTodo, id)
                    : tomorrow
                    ? DatabaseMethods().addTomorrowWork(userTodo, id)
                    : DatabaseMethods().addNextWeekWork(userTodo, id);
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000080),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text("Add", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
