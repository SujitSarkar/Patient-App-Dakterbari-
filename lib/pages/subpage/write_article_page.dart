import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/widgets/button_widgets.dart';

class CreateArticle extends StatefulWidget {
  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter=0;
  File  _articleImageFile;
  final picker = ImagePicker();

  _initializedData(ArticleProvider provider){
    setState(()=>_counter++);
    provider.articleModel.category=null;
    provider.articleModel.title='';
    provider.articleModel.abstract='';
    provider.articleModel.introduction='';
    provider.articleModel.methods='';
    provider.articleModel.results='';
    provider.articleModel.conclusion='';
    provider.articleModel.acknowledgement='';
    provider.articleModel.reference='';
  }

  @override
  Widget build(BuildContext context) {
    final ArticleProvider provider = Provider.of<ArticleProvider>(context);
    if(_counter==0) _initializedData(provider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, "Write Article"),
      body: _bodyUI(provider),
    );
  }

  Widget _bodyUI(ArticleProvider provider) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///Article Image...
            GestureDetector(
              onTap: () =>_getImageFromGallery(),
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 250,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Color(0xffF4F7F5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      _articleImageFile==null? Icon(Icons.add_photo_alternate,
                          size: 230, color: Color(0xffBCEDF2))
                          :ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.file(_articleImageFile,height: 250,width: size.width,fit: BoxFit.cover,)),
                      _articleImageFile==null? Text(
                        "Select an image for this article",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ):Container()
                    ],
                  )),
            ),

            ///Article Form...
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  ///Title...
                  _textFormBuilder('Title',provider),
                  SizedBox(height: 20),

                  ///Category Dropdown...
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xffF4F7F5),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: size.width,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: provider.articleModel.category,
                        hint: Text("Select Article Category",style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16)),
                        items: StaticVariables.articleCategoryItems.map((category){
                          return DropdownMenuItem(
                            child: Text(category,style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 16,)),
                            value: category,
                          );
                        }).toList(),
                        onChanged: (newValue)=> setState(() => provider.articleModel.category = newValue),
                        dropdownColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ///Abstract...
                  _textFormBuilder('Abstract',provider),
                  SizedBox(height: 20),

                  ///Introduction...
                  _textFormBuilder('Introduction',provider),
                  SizedBox(height: 20),

                  ///Methods...
                  _textFormBuilder('Methods',provider),
                  SizedBox(height: 20),

                  ///Results/Findings...
                  _textFormBuilder('Results',provider),
                  SizedBox(height: 20),

                  ///Conclusion...
                  _textFormBuilder('Conclusion',provider),
                  SizedBox(height: 20),

                  ///Acknowledgements...
                  _textFormBuilder('Acknowledgements',provider),
                  SizedBox(height: 20),

                  ///References/Work cited...
                  _textFormBuilder('References',provider),
                  SizedBox(height: 20),

                  ///Submit Button...
                  Consumer<DoctorProvider>(
                    builder: (context, drProvider,child){
                      return GestureDetector(
                        onTap: ()=> _checkValidity(provider,drProvider),
                        child: button(context, "Submit  Article"),
                      );
                    },
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFormBuilder(String hint,ArticleProvider provider) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: FormDecorationWithoutPrefix.copyWith(
        alignLabelWithHint: true,
          labelText: hint, fillColor: Color(0xffF4F7F5),
      ),
      validator: (val)=>val.isEmpty? "Enter $hint":null,
      maxLines: hint == 'Title'
          ? 2 : 5,

      onChanged: (val) {
        if (hint == 'Title') provider.articleModel.title=val;
        if (hint == 'Abstract') provider.articleModel.abstract=val;
        if (hint == 'Introduction') provider.articleModel.introduction=val;
        if (hint == 'Methods') provider.articleModel.methods=val;
        if (hint == 'Results') provider.articleModel.results=val;
        if (hint == 'Conclusion') provider.articleModel.conclusion=val;
        if (hint == 'Acknowledgements') provider.articleModel.acknowledgement=val;
        if (hint == 'References') provider.articleModel.reference=val;
      },
    );
  }

  _checkValidity(ArticleProvider provider,DoctorProvider drProvider){
    if(_articleImageFile!=null){
      if(provider.articleModel.title.isNotEmpty
          && provider.articleModel.abstract.isNotEmpty
          && provider.articleModel.introduction.isNotEmpty
          && provider.articleModel.methods.isNotEmpty
          && provider.articleModel.results.isNotEmpty
          && provider.articleModel.conclusion.isNotEmpty
          && provider.articleModel.acknowledgement.isNotEmpty
          && provider.articleModel.reference.isNotEmpty){
        provider.loadingMgs='Submitting article...';
        showLoadingDialog(context,provider);
        provider.submitArticle(provider,drProvider,_articleImageFile, context, _scaffoldKey);
      }else{
        showSnackBar(_scaffoldKey, 'Fill the required fields', Colors.deepOrange);
      }
    }else showSnackBar(_scaffoldKey,'Select article image',Colors.deepOrange);
  }

  Future<void> _getImageFromGallery()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxWidth: 700,maxHeight: 500);
    if(pickedFile!=null){
      setState(()=>_articleImageFile = File(pickedFile.path));
    }else {
      showSnackBar(_scaffoldKey, 'No image selected', Colors.deepOrange);
    }

  }
}
