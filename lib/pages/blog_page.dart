import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:user_panel/model/article_model.dart';
import 'package:user_panel/pages/subpage/all_article_category_page.dart';
import 'package:user_panel/pages/subpage/article_by_category.dart';
import 'package:user_panel/pages/subpage/read_article_page.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context,articleProvider,child){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          // Color(0xffF4F7F5),
          appBar: customAppBarDesign(context, "Daktarbari Blog"),
          body: _bodyUI(articleProvider),
        );
      },
    );
  }

  Widget _bodyUI(ArticleProvider articleProvider) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()async{
        await articleProvider.getAllArticle();
        await articleProvider.getPopularArticle();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _viewAllSection("Article Categories"),
          SizedBox(height: size.width / 40),
          _categoryBuilder(),
          SizedBox(height: size.width / 10),

          _viewAllSection("Recent Posts"),
          SizedBox(height: size.width / 40),
          articleProvider.allArticleList.isNotEmpty? _postBuilder('recent',articleProvider.allArticleList)
              :NoData(message:'No Recent Post \u{1f614}'),
          SizedBox(height: size.width / 10),

          _viewAllSection("Popular Posts"),
          SizedBox(height: size.width / 40),
          articleProvider.popularArticleList.isNotEmpty? _postBuilder('popular',articleProvider.popularArticleList)
              :NoData(message:'No Popular Post \u{1f614}'),
          SizedBox(height: size.width / 10),
        ],
      ),
    );
  }

  Widget _viewAllSection(String categoryName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            categoryName,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
          //Text("View all",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17,fontWeight: FontWeight.bold))
          GestureDetector(
              onTap: () {
                categoryName == 'Article Categories'?
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AllArticleCategory())):
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryArticle(categoryName)));
              },
              child: Icon(
                Icons.arrow_right_alt,
                size: 35,
                color: Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }

  Widget _categoryBuilder() {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 85,
        width: size.width,
        child: AnimationLimiter(
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: StaticVariables.articleCategoryItems.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: 400,
                      child: FadeInAnimation(
                        child: ArticleCategoryTile(
                          index: index,
                        ),),
                    )
                );
              }),
        ));
  }

  Widget _postBuilder(String identifier, List<ArticleModel> list) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 310,
        width: size.width,
        //color: Colors.grey,
        child: AnimationLimiter(
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: list.length>50? 50: list.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: -400,
                      child: FadeInAnimation(
                        child: PostTile(
                            identifier: identifier,
                            index: index,
                            list: list),),
                    )
                );
              }),
        ));
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
            width: 150,
            height: 80,
            margin: EdgeInsets.only(right: 10,left: 2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ///Background Image
                Container(
                  height: 80,
                  width: 150,
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
                    width: 140,
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
                  bottom: 3,
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                      //width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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

// ignore: must_be_immutable
class PostTile extends StatelessWidget {
  int index;
  String identifier;
  List<ArticleModel> list;
  PostTile({this.identifier,this.index,this.list});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context, articleProvider, child){
        return GestureDetector(
          onTap: ()async{
            articleProvider.loadingMgs= 'Please wait...';
            showLoadingDialog(context,articleProvider);
            await articleProvider.getArticleComments(list[index].id).then((value){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadArticle(
                articleIndex: index,
                id: list[index].id,
                photoUrl: list[index].photoUrl,
                date: list[index].date,
                title: list[index].title,
                author: list[index].author,
                authorPhoto: list[index].authorPhoto,
                like: list[index].like,
                share: list[index].share,
                category: list[index].category,
                abstract: list[index].abstract,
                introduction: list[index].introduction,
                methods: list[index].methods,
                results: list[index].results,
                conclusion: list[index].conclusion,
                acknowledgement: list[index].acknowledgement,
                reference: list[index].reference,
                doctorId: list[index].doctorId,
              )));
            });
          },
          child: Container(
            width: 200,
            height: 310,
            margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 2.5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 2.0, offset: Offset(0, 1))
                ]),
            child: Stack(
              children: [
                ///Image
                Positioned(
                    top: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: list[index].photoUrl,
                              width: 200,
                              height: 90,
                              placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/loadingimage.gif',height: 90, width: 200,fit: BoxFit.cover,),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),

                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),

                        ///Title, date, description
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Title...
                              Container(
                                  width: 195,
                                  child: Text(
                                    list[index].title,
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(height: 5),
                              //Vertical line
                              Container(
                                height: 3,
                                width: 100,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(height: 5),
                              //Date...
                              Container(
                                  width: 195,
                                  child: Text(
                                    list[index].date,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(height: 20),
                              //Description...
                              Container(
                                  width: 195,
                                  child: Text(
                                    list[index].abstract,
                                    maxLines: 5,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ],
                          ),
                        )
                      ],
                    )),

                ///Footer (like & share)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      height: 30,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${list[index].like ?? '0'}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.suit_heart,
                                color: Colors.pink,
                                size: 20,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${list[index].share ?? '0'}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.arrowshape_turn_up_right,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ],
                          )
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
