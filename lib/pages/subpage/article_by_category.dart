import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/model/article_model.dart';
import 'package:user_panel/pages/subpage/read_article_page.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class CategoryArticle extends StatefulWidget {
  String categoryName;
  CategoryArticle(this.categoryName);

  @override
  _CategoryArticleState createState() => _CategoryArticleState();
}

class _CategoryArticleState extends State<CategoryArticle> {

  List<ArticleModel> articleList = List<ArticleModel>();
  int _counter=0;

  _initializeData(ArticleProvider articleProvider){
    setState((){
      if(widget.categoryName=='News') articleList.addAll(articleProvider.newsArticleList);
      else if(widget.categoryName=='Diseases & Cause') articleList.addAll(articleProvider.diseasesArticleList);
      else if(widget.categoryName=='Health Tips') articleList.addAll(articleProvider.healthArticleList);
      else if(widget.categoryName=='Food & Nutrition') articleList.addAll(articleProvider.foodArticleList);
      else if(widget.categoryName=='Medicine & Treatment') articleList.addAll(articleProvider.medicineArticleList);
      else if(widget.categoryName=='Medicare & Hospital') articleList.addAll(articleProvider.medicareArticleList);
      else if(widget.categoryName=='Tourism & Cost') articleList.addAll(articleProvider.tourismArticleList);
      else if(widget.categoryName=='Symptoms') articleList.addAll(articleProvider.symptomsArticleList);
      else if(widget.categoryName=='Visual Story') articleList.addAll(articleProvider.visualArticleList);

      else if(widget.categoryName=='Recent Posts') articleList.addAll(articleProvider.allArticleList);
      else if(widget.categoryName=='Popular Posts') articleList.addAll(articleProvider.popularArticleList);
      _counter++;
    });

  }

  @override
  Widget build(BuildContext context) {
    final ArticleProvider articleProvider = Provider.of<ArticleProvider>(context);
    if(_counter==0) _initializeData(articleProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, widget.categoryName),
      body: articleList.isEmpty? NoData(message: 'No article found \u{1f614}',): _bodyUI(),
    );
  }


  Widget _bodyUI(){
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: articleList.length,
          itemBuilder: (BuildContext context, int index){
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 400,
                  child: FadeInAnimation(
                    child: PostTile(
                      id: articleList[index].id,
                      index: index,
                      photoUrl: articleList[index].photoUrl,
                      date: articleList[index].date,
                      title: articleList[index].title,
                      author: articleList[index].author,
                      authorPhoto: articleList[index].authorPhoto,
                      share: articleList[index].share,
                      like: articleList[index].like,
                      category: articleList[index].category,
                      abstract: articleList[index].abstract,
                      introduction: articleList[index].introduction,
                      methods: articleList[index].methods,
                      results: articleList[index].results,
                      conclusion: articleList[index].conclusion,
                      acknowledgement: articleList[index].acknowledgement,
                      reference: articleList[index].reference,
                      doctorId: articleList[index].doctorId,
                    ),),
                )
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PostTile extends StatelessWidget {
  String id;
  int index;
  String photoUrl;
  String date;
  String title;
  String author;
  String authorPhoto;
  String like;
  String share;
  String category;
  String abstract;
  String introduction;
  String methods;
  String results;
  String conclusion;
  String acknowledgement;
  String reference;
  String doctorId;
  String timeStamp;

  PostTile({this.id,
    this.index,
    this.photoUrl,
    this.date,
    this.title,
    this.author,
    this.like,
    this.share,
    this.category,
    this.abstract,
    this.introduction,
    this.methods,
    this.results,
    this.conclusion,
    this.acknowledgement,
    this.reference,
    this.doctorId,
    this.authorPhoto});


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ArticleProvider>(
      builder: (context,articleProvider, child){
        return GestureDetector(
            onTap: ()async{
              articleProvider.loadingMgs= 'Please wait...';
              showLoadingDialog(context,articleProvider);
              await articleProvider.getArticleComments(id).then((value){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadArticle(
                  id: id,
                  articleIndex: index,
                  photoUrl: photoUrl,
                  date: date,
                  title: title,
                  author: author,
                  authorPhoto: authorPhoto,
                  like: like,
                  share: share,
                  category: category,
                  abstract: abstract,
                  introduction: introduction,
                  methods: methods,
                  results: results,
                  conclusion: conclusion,
                  acknowledgement: acknowledgement,
                  reference: reference,
                  doctorId: doctorId,
                )));
              });

            },
            child: Container(
              margin: EdgeInsets.only(left: 6,right: 6,top: 3,bottom: 20),
              //height: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[800],
                        //offset: Offset(1,1),
                        blurRadius: 3
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header Image
                  Container(
                    height: 120,
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
                        imageUrl: photoUrl,
                        width: size.width,
                        height: 120,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/loadingimage.gif',height: 120, width: size.width),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),

                  //Article Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      title,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 5),

                  //Vertical line
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 3,
                    width: size.width*.6,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 5),

                  //Article Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      date,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 20),

                  //Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      abstract,
                      maxLines: 5,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 10),

                  //Like Share
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${like??'0'}",
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
                              "${share??'0'}",
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
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            )
        );
      },
    );

  }
}
