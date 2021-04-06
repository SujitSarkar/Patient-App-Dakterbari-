import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/provider/forum_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:expandable_text/expandable_text.dart';

// ignore: must_be_immutable
class ForumAnswers extends StatefulWidget {
  String question;
  ForumAnswers({this.question});
  @override
  _ForumAnswersState createState() => _ForumAnswersState();
}

class _ForumAnswersState extends State<ForumAnswers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context,'All Answer'),
      body: _bodyUI(),
      );
  }

  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ForumProvider>(
      builder: (context, forumProvider, child){
        return Container(
          height: size.height,
          width: size.width,
          //padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  //height: size.width*.4,
                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ExpandableText(
                      widget.question,
                      expandText: 'more',
                      collapseText: 'less',
                      maxLines: 8,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: size.width*.038),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: forumProvider.answerList.length,
                      itemBuilder: (context, index) {
                        return PatientQuestionTile(
                          drPhotoUrl: forumProvider.answerList[index].drPhotoUrl,
                          drName: forumProvider.answerList[index].drName,
                          ansDate: forumProvider.answerList[index].ansDate,
                          degree:forumProvider.answerList[index].drDegree,
                          answer: forumProvider.answerList[index].answer,
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

///ignore: must_be_immutable
class PatientQuestionTile extends StatelessWidget {
  String drPhotoUrl,drName, ansDate,degree, answer;

  PatientQuestionTile({this.drName,this.drPhotoUrl,this.degree,this.ansDate,this.answer});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(bottom: 10, left: 2, right: 2),
        padding: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300], offset: Offset(1, 1), blurRadius: 2)
            ]),
        child: ListTile(
          onTap: (){},
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width * .18,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Color(0xffAB5581),
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: drPhotoUrl==null?
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    child: Image.asset("assets/male.png", width: size.width * .18))
                    :ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  child: CachedNetworkImage(
                    imageUrl: drPhotoUrl,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/loadingimage.gif',width: size.width * .18,height: size.width*.18,
                        fit: BoxFit.cover,),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: size.width * .18,
                    height: size.width * .18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: size.width*.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$drName',
                        maxLines: 1,
                        style: TextStyle(fontSize: size.width*.045, fontWeight: FontWeight.bold,color: Colors.grey[900]),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ansDate??'',
                        maxLines: 1,
                        style: TextStyle(fontSize: size.width*.032, color: Colors.grey[700]),
                      ),

                      Text(
                        '${degree ?? 'Degree'}',
                        maxLines: 2,
                        style: TextStyle(fontSize: size.width*.033),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3,
              ),
              Text(
                'Answer : ',
                maxLines: 1,
                style: TextStyle(fontSize: size.width*.031, color: Colors.grey[800]),
              ),
              Text(answer,style:TextStyle(
                  fontSize: size.width * .035
              ),textAlign: TextAlign.justify,)
            ],
          ),
        ));
  }
}

