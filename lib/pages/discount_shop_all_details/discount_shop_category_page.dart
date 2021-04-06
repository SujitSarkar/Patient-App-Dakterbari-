import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/pages/discount_shop_all_details/discount_shop_list.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/shared/form_decoration.dart';

class DiscountShopCategory extends StatefulWidget {
  @override
  _DiscountShopCategoryState createState() => _DiscountShopCategoryState();
}

class _DiscountShopCategoryState extends State<DiscountShopCategory> {
  String hospitalLabPharmacy;
  String travelTour;
  String hotelRestaurant;
  String educationTraining;
  String entertainment;
  String weddingParlor;
  String familyNeeds;
  String demandService;
  String equipmentTools;
  String hireRent;
  String automobiles;
  String realState;
  String miscellaneous;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      //appBar: customAppBarDesign(context, "Discount Shop"),
      body:_bodyUI(),
       );
  }
  Widget _bodyUI(){
    Size size = MediaQuery.of(context).size;
    DiscountShopProvider disShopProvider=Provider.of<DiscountShopProvider>(context);
    return ListView(
      children: [
        _dropDownBuilder('Hospital/Lab/Pharmacy',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Travel & Tour',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Hotel & Restaurant',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Education & Training',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Entertainment',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Wedding & Parlor',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Family Needs',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Demand Service',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Equipment & Tools',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Hire & Rent',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Automobiles',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Real State',disShopProvider),
        SizedBox(height: size.width / 20),
        _dropDownBuilder('Miscellaneous',disShopProvider),
        SizedBox(height: size.width / 20),
      ],
    );
  }
  Widget _dropDownBuilder(String hint,DiscountShopProvider disShopProvider){
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,),
      decoration: BoxDecoration(
          color: Colors.white, //Color(0xffF4F7F5),
      ),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: cardDecoration,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: hint=="Hospital/Lab/Pharmacy"? hospitalLabPharmacy
                : hint=="Travel & Tour"? travelTour
                : hint=="Hotel & Restaurant"? hotelRestaurant
                : hint=="Education & Training"? educationTraining
                : hint=="Entertainment"? entertainment
                : hint=="Wedding & Parlor"? weddingParlor
                : hint=="Family Needs"? familyNeeds
                : hint=="Demand Service"? demandService
                : hint=="Equipment & Tools"? equipmentTools
                : hint=="Hire & Rent"? hireRent
                : hint=="Automobiles"? automobiles
                : hint=="Real State"? realState
                :miscellaneous,
            hint: Text(hint,style: TextStyle(
                color: Colors.grey[900],
                fontSize: 16)),
            items: hint=='Hospital/Lab/Pharmacy'?
            StaticVariables.hlpSubCategory.map((hospitalLabPharmacy){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(hospitalLabPharmacy,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: hospitalLabPharmacy,
              );
            }).toList()
                :hint=='Travel & Tour'?
            StaticVariables.tourSubCategory.map((travelTour){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(travelTour,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: travelTour,
              );
            }).toList()
            //for service category
                :hint=='Hotel & Restaurant'?
            StaticVariables.hotelSubCategory.map((hotelRestaurant){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(hotelRestaurant,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: hotelRestaurant,
              );
            }).toList()
            //for service category
                :hint=='Education & Training'?
            StaticVariables.educationSubCategory.map((educationTraining){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(educationTraining,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: educationTraining,
              );
            }).toList()
            //for service category
                :hint=='Entertainment'?
            StaticVariables.entertainSubCategory.map((entertainment){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(entertainment,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: entertainment,
              );
            }).toList()
            //for service category
                :hint=='Wedding & Parlor'?
            StaticVariables.weddingSubCategory.map((weddingParlor){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(weddingParlor,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: weddingParlor,
              );
            }).toList()
            //for service category
                :hint=='Family Needs'?
            StaticVariables.familySubCategory.map((familyNeeds){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(familyNeeds,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: familyNeeds,
              );
            }).toList()
            //for service category
                :hint=='Demand Service'?
            StaticVariables.demandSubCategory.map((demandService){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(demandService,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: demandService,
              );
            }).toList()
            //for service category
                :hint=='Equipment & Tools'?
            StaticVariables.equipmentSubCategory.map((equipmentTools){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(equipmentTools,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: equipmentTools,
              );
            }).toList()
            //for service category
                :hint=='Hire & Rent'?
            StaticVariables.hireSubCategory.map((hireRent){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(hireRent,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: hireRent,
              );
            }).toList()
            //for service category
                :hint=='Automobiles'?
            StaticVariables.autoMobileSubCategory.map((automobiles){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(automobiles,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: automobiles,
              );
            }).toList()
            //for service category
                :hint=='Real State'?
            StaticVariables.realStateSubCategory.map((realState){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(realState,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: realState,
              );
            }).toList()
            //for service category
                :StaticVariables.miscellaneousSubCategory.map((miscellaneous){
              return DropdownMenuItem(
                child: Container(
                  width: size.width*.75,
                  child: Text(miscellaneous,style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,)),
                ),
                value: miscellaneous,
              );
            }).toList(),
            onChanged: (newValue)async{
              setState(() {
                hint=="Hospital/Lab/Pharmacy"? hospitalLabPharmacy = newValue
                    :hint=="Travel & Tour"? travelTour = newValue
                    :hint=="Hotel & Restaurant"? hotelRestaurant = newValue
                    :hint=="Education & Training"? educationTraining = newValue
                    :hint=="Entertainment"? entertainment = newValue
                    :hint=="Wedding & Parlor"? weddingParlor = newValue
                    :hint=="Family Needs"? familyNeeds = newValue
                    :hint=="Demand Service"? demandService = newValue
                    :hint=="Equipment & Tools"? equipmentTools = newValue
                    :hint=="Hire & Rent"? hireRent = newValue
                    :hint=="Automobiles"? automobiles = newValue
                    :hint=="Real State"? realState = newValue
                    :miscellaneous = newValue;
              });
              disShopProvider.loadingMgs='Please wait...';
              showLoadingDialog(context,disShopProvider);
              await disShopProvider.getShop(newValue).then((value){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiscountShopList(newValue)));
              },onError: (error){
                Navigator.pop(context);
                showAlertDialog(context, error.toString());
              });
              },
            dropdownColor: Colors.white,
          ),
        ),
      ),
    );
  }
}