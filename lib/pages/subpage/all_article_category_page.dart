import 'package:flutter/material.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'article_by_category.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AllArticleCategory extends StatefulWidget {
  @override
  _AllArticleCategoryState createState() => _AllArticleCategoryState();
}

class _AllArticleCategoryState extends State<AllArticleCategory> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Article Categories'),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI(){
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: AnimationLimiter(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 2
            ),
            itemCount: StaticVariables.articleCategoryItems.length,
            itemBuilder: (BuildContext context, int index){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: ArticleCategoryTile(
                        index: index,
                      ),),
                  )
              );
            }
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ArticleCategoryTile extends StatelessWidget {
  final int index;

  ArticleCategoryTile({this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context, articleProvider, child){
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryArticle(StaticVariables.articleCategoryItems[index])));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ///Background Color
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF4F7F5),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0,.2),
                            blurRadius: 2
                        )
                      ]
                  ),
                ),

                ///Category name
                Container(
                    child: Text(
                      StaticVariables.articleCategoryItems[index],
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            index==0?"${articleProvider.newsArticleList.length}"
                                :index==1?"${articleProvider.diseasesArticleList.length}"
                                :index==2?"${articleProvider.healthArticleList.length}"
                                :index==3?"${articleProvider.foodArticleList.length}"
                                :index==4?"${articleProvider.medicineArticleList.length}"
                                :index==5?"${articleProvider.medicareArticleList.length}"
                                :index==6?"${articleProvider.tourismArticleList.length}"
                                :index==7?"${articleProvider.symptomsArticleList.length}"
                                :"${articleProvider.visualArticleList.length}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
