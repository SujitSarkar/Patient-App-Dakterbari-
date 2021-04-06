import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


  // ignore: non_constant_identifier_names
  void ViewAllComment(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Consumer<ArticleProvider>(
          builder: (context, articleProvider, child){
            return Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                color: Colors.white
              ),
              child: Column(
                children: [
                  Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          ),
                        color: Theme.of(context).primaryColor,
                      ),
                     //Color(0xffF4F7F5),
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: ()=>Navigator.pop(context),
                      child: Icon(Icons.clear,color: Colors.grey[100],size: 30,),
                    )
                  ),

                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: articleProvider.articleCommentList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 400,
                                child: FadeInAnimation(
                                  child: Container(
                                    width: size.width,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width * .11,
                                          height: size.width * .11,
                                          decoration: BoxDecoration(
                                            color: Color(0xffAAF1E8),
                                            image: DecorationImage(
                                              image: articleProvider.articleCommentList[index].commenterPhoto==null? AssetImage('assets/male.png')
                                                  :NetworkImage(articleProvider.articleCommentList[index].commenterPhoto),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                        ),
                                        SizedBox(width: size.width * .01),
                                        Container(
                                          width: size.width * .81,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.blueGrey[100],
                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(articleProvider.articleCommentList[index].commenterName
                                                  ,style: TextStyle(fontSize: 13, color: Colors.grey[900],fontWeight: FontWeight.bold)),
                                              Text(
                                                articleProvider.articleCommentList[index].comment,
                                                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                              ),
                                              Text(
                                                articleProvider.articleCommentList[index].commentDate,
                                                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),),
                              )
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

