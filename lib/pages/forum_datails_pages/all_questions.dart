import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/forum_provider.dart';
import 'package:user_panel/pages/forum_datails_pages/forum_answers_page.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:expandable_text/expandable_text.dart';

class AllQuestions extends StatefulWidget {

  @override
  _AllQuestionsState createState() => _AllQuestionsState();
}

class _AllQuestionsState extends State<AllQuestions> {


  @override
  Widget build(BuildContext context) {
    //final PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    final ForumProvider forumProvider = Provider.of<ForumProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: _bodyUI(forumProvider),
    );
  }
  Widget _bodyUI(ForumProvider forumProvider) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: size.height,
      width: size.width,
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: ()=>forumProvider.getAllQuestionList(),
        child: AnimationLimiter(
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: forumProvider.allQuesList.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 400,
                      child: FadeInAnimation(
                        child: QuestionBuilder(index: index),),
                    )
                );
              }
          ),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class QuestionBuilder extends StatelessWidget {
  int index;
  QuestionBuilder({this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<ForumProvider>(
      builder: (context, forumProvider, child){
        return GestureDetector(
          onTap: ()async{
            forumProvider.loadingMgs='Please wait...';
            showLoadingDialog(context,forumProvider);
            await forumProvider.getForumAnswer(forumProvider.allQuesList[index].id).then((value){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ForumAnswers(
                question: forumProvider.allQuesList[index].question,
              )));
            });
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title Section...
                ExpandableText(
                  forumProvider.allQuesList[index].question,
                  expandText: 'more',
                  collapseText: 'less',
                  maxLines: 3,
                  linkColor: Theme.of(context).primaryColor,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: size.width*.036,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900]),
                ),
                SizedBox(height: 5),

                //Middle Section..
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${forumProvider.allQuesList[index].totalAns??'0'} Answers · ",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: size.width*.030,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                      Text(
                        forumProvider.allQuesList[index].quesDate,
                        maxLines: 1,
                        style: TextStyle(fontSize: size.width*.030, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey[900],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

