import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/forum_provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/pages/forum_datails_pages/forum_answers_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:expandable_text/expandable_text.dart';

// ignore: must_be_immutable
class MyQuestions extends StatefulWidget {
  @override
  _MyQuestionsState createState() => _MyQuestionsState();
}

class _MyQuestionsState extends State<MyQuestions> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    final ForumProvider forumProvider = Provider.of<ForumProvider>(context);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: customAppBarDesign(context, 'Public Forum'),
      body: _bodyUI(patientProvider, forumProvider),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _addQuestion(patientProvider, forumProvider),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Add Question',
        child: Icon(
          Icons.add,
          color: Colors.white,
          size:  size.width * .046,
        ),
      ),
    );
  }

  Widget _bodyUI(PatientProvider patientProvider, ForumProvider forumProvider) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      margin: EdgeInsets.only(top: 20),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: ()=>forumProvider.getMyQuestionList(),
        child: AnimationLimiter(
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: forumProvider.myQuesList.length,
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
              }),
        ),
      ),
    );
  }

  void _addQuestion(
      PatientProvider patientProvider, ForumProvider forumProvider) {
    Size size=MediaQuery.of(context).size;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              scrollable: true,
          contentPadding: EdgeInsets.all(15),
              title: Text(
                "Add Your Questions",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize:  size.width * .042),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _questionController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val)=> val.isEmpty?'Write your question':null,
                      decoration: FormDecorationWithoutPrefix.copyWith(
                          labelText: 'Write your question',
                          alignLabelWithHint: true,
                          fillColor: Color(0xffF4F7F5)),
                      maxLines: 8,
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                            color: Colors.redAccent,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white,fontSize:  size.width * .030),
                            )),
                        RaisedButton(
                            onPressed: () async{
                              if(_formKey.currentState.validate()){
                                forumProvider.loadingMgs='Submitting question...';
                                showLoadingDialog(context, forumProvider);
                                await forumProvider.submitForumQues(patientProvider, forumProvider, _questionController.text, context, _scaffoldKey);
                              }
                            },
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white,fontSize:  size.width * .030),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ));
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
            await forumProvider.getForumAnswer(forumProvider.myQuesList[index].id).then((value){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ForumAnswers(
                question: forumProvider.myQuesList[index].question,
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
                  forumProvider.myQuesList[index].question,
                  expandText: 'more',
                  collapseText: 'less',
                  maxLines: 3,
                  linkColor: Theme.of(context).primaryColor,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize:  size.width * .036,
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
                        "${forumProvider.myQuesList[index].totalAns??'0'} Answers · ",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize:  size.width * .030,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                      Text(
                        forumProvider.myQuesList[index].quesDate,
                        maxLines: 1,
                        style: TextStyle(fontSize:  size.width * .030, color: Colors.grey[700]),
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
