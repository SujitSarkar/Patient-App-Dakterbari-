import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/pages/forum_datails_pages/all_questions.dart';
import 'package:user_panel/pages/forum_datails_pages/my_questions.dart';


class ForumTabPage extends StatefulWidget {
  @override
  _ForumTabPageState createState() => _ForumTabPageState();
}

class _ForumTabPageState extends State<ForumTabPage> {

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: Color(0xffF4F7F5),
        appBar: AppBar(
          title: Text("Forum",style: TextStyle(fontSize:  size.width * .046),),
          centerTitle: true,
          bottom: TabBar(
              indicatorColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize:  size.width * .036,
              ),
              tabs: [
                Tab(text: 'My Question'),
                Tab(text: 'All Question'),
              ]),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
              children: [
                MyQuestions(),
                AllQuestions(),
              ]
          ),
        ),
      ),
    );
  }
}
