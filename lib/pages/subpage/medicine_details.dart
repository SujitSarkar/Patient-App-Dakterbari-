import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/utils/custom_clipper.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class MedicineDetails extends StatefulWidget {
  String name;
  String strength;
  String genericName;
  String dosage;
  String manufacturer;
  String price;
  String indications;
  String adultDose;
  String childDose;
  String renalDose;
  String administration;
  String contradiction;
  String sideEffect;
  String precautions;
  String pregnancy;
  String therapeutic;
  String modeOfAction;
  String interaction;
  String darNo;
  MedicineDetails({
    this.name,
    this.strength,
    this.genericName,
    this.dosage,
    this.manufacturer,
    this.price,
    this.indications,
    this.adultDose,
    this.childDose,
    this.renalDose,
    this.administration,
    this.contradiction,
    this.sideEffect,
    this.precautions,
    this.pregnancy,
    this.therapeutic,
    this.modeOfAction,
    this.interaction,
    this.darNo});
  @override
  _MedicineDetailsState createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _customAppBar(),
      body: _bodyUI(),
    );
  }

  Widget _customAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: AppBar(
        title: Text(
          widget.name??'',
          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*.043),
        ),
        //centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        flexibleSpace: ClipPath(
          clipper: MyCustomClipperForAppBar(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Color(0xffAB5581),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              tileMode: TileMode.clamp,
            )),
          ),
        ),
      ),
    );
  }

  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          //Header...
      Container(
      height: size.width * .36,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: widget.name??'',
                style: TextStyle(fontSize: size.width*.048, color: Colors.white,fontWeight: FontWeight.bold),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' ${widget.strength}'??'',
                    style: TextStyle(
                        fontSize: size.width*.028, color: Colors.white
                      //decorationStyle: TextDecorationStyle.dotted,
                    ),
                  ),
                ],
              ),
              maxLines:2,
            ),
            Text(
              widget.genericName??'',
              maxLines: 1,
              style: TextStyle(
                  fontSize: size.width*.040,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 5),
            Text(
              widget.dosage??'',
              maxLines: 1,
              style: TextStyle(fontSize: size.width*.038, color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              '৳ ${widget.price}'??'',
              maxLines: 1,
              style: TextStyle(fontSize: size.width*.044, color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              widget.manufacturer??'',
              maxLines: 1,
              style: TextStyle(fontSize: size.width*.046, color: Colors.white),
            ),
            //SizedBox(height: 5),
          ],
        ),
      ),

          //body...
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index){
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 400,
                        child: FadeInAnimation(
                          child:EntryItemTile(
                              medicineDataList(
                                  widget.indications,
                                  widget.adultDose,
                                  widget.childDose,
                                  widget.renalDose,
                                  widget.administration,
                                  widget.contradiction,
                                  widget.sideEffect,
                                  widget.precautions,
                                  widget.pregnancy,
                                  widget.therapeutic,
                                  widget.modeOfAction,
                                  widget.interaction)[index],
                              size),
                            ),
                      )
                  );},
              ),
            ),
          )
        ],
      ),
    );
  }
}

///Create the widget for the row...
// ignore: must_be_immutable
class EntryItemTile extends StatelessWidget {
  final Entry entry;
  Size size;
  EntryItemTile(this.entry,this.size);

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(
          root.title,
          style: TextStyle(color: Colors.grey[800], fontSize: size.width*.036),
        ),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      childrenPadding: EdgeInsets.all(0.0),
      //tilePadding: EdgeInsets.all(0.0),
      title: Text(
        root.title,
        style: TextStyle(fontSize: size.width*.040),
      ),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
