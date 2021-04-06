import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/model/medicine_model.dart';
import 'package:user_panel/pages/subpage/medicine_details.dart';
import 'package:user_panel/provider/medicine_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:user_panel/shared/form_decoration.dart';

class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
   List<String> strList = [];
   List<Widget> normalList = [];
   List<MedicineModel> medicineList=[];
  TextEditingController searchController = TextEditingController();
  int _counter=0;

  _customInitState(MedicineProvider provider){
    medicineList =  provider.medicineList;

    ///Sort list by alphabetically
    medicineList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    filterList();
    searchController.addListener(() {
      filterList();
    });
    setState(()=>_counter++);
  }

  ///SearchList builder
  filterList() {
    List<MedicineModel> medicines=[];
    medicines.addAll(medicineList);
    normalList = [];
    strList = [];
    if (searchController.text.isNotEmpty) {
      medicines.retainWhere((medicine) =>
          medicine.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()));
    }
    medicines.forEach((medicine) {
      normalList.add(
        MedicineTile(
          name: medicine.name,
          strength: medicine.strength,
          genericName: medicine.genericName,
          dosage: medicine.dosage,
          manufacturer: medicine.manufacturer,
          price: medicine.price,
          indications: medicine.indications,
          adultDose: medicine.adultDose,
          childDose: medicine.childDose,
          renalDose: medicine.renalDose,
          administration: medicine.administration,
          contradiction: medicine.contradiction,
          sideEffect: medicine.sideEffect,
          precautions: medicine.precautions,
          pregnancy: medicine.pregnancy,
          therapeutic: medicine.therapeutic,
          modeOfAction: medicine.modeOfAction,
          interaction: medicine.interaction,
          darNo: medicine.darNo,
        ),
      );
      strList.add(medicine.name);
    });
    setState(() {
      strList;
      normalList;
    });
  }


  @override
  Widget build(BuildContext context) {
    final MedicineProvider provider = Provider.of<MedicineProvider>(context);
    if(_counter==0) _customInitState(provider);

    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'Medicines'),
      body: _bodyUI(provider),
    );
  }

  Widget _bodyUI(MedicineProvider provider) {
    final Size size = MediaQuery.of(context).size;
    return AlphabetListScrollView(
      strList: strList,
      highlightTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      showPreview: true,
      itemBuilder: (context, index) {
        return normalList[index];
      },
      indexedHeight: (i) {
        return size.width*.34;
      },
      keyboardUsage: true,
      headerWidgetList: <AlphabetScrollListHeader>[
        AlphabetScrollListHeader(
            widgetList: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search medicine...",
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none
                )
              ),
            ),
          ),
        ],
            icon: Icon(Icons.search), indexedHeaderHeight: (index) => 60),
      ],
    );
  }


}

// ignore: must_be_immutable
class MedicineTile extends StatelessWidget {
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
  MedicineTile({
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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineDetails(
          name:name,
          strength:strength,
          genericName:genericName,
          dosage:dosage,
          manufacturer:manufacturer,
          price:price,
          indications:indications,
          adultDose:adultDose,
          childDose:childDose,
          renalDose:renalDose,
          administration:administration,
          contradiction:contradiction,
          sideEffect:sideEffect,
          precautions:precautions,
          pregnancy:pregnancy,
          therapeutic:therapeutic,
          modeOfAction:modeOfAction,
          interaction:indications,
          darNo:darNo
      ))),
      child: Container(
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300], offset: Offset(1, 1), blurRadius: 2)
              ]),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: name??'',
                  style: TextStyle(fontSize: size.width*.05, color: Colors.grey[900]),
                  children: <InlineSpan>[
                    TextSpan(
                      text: ' $strength'??'',
                      style: TextStyle(
                        fontSize: size.width*.03, color: Colors.grey[700],
                        //decorationStyle: TextDecorationStyle.dotted,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
              ),

              Text(
                genericName??'',
                maxLines: 1,
                style: TextStyle(fontSize: size.width*.038, color: Colors.grey[700],fontStyle: FontStyle.italic),
              ),

              Text(
                dosage??'',
                maxLines: 1,
                style: TextStyle(fontSize:  size.width*.038, color: Colors.grey[700]),
              ),
              SizedBox(
                height: 5
              ),
              Text(
                '৳ $price'??'',
                maxLines: 1,
                style: TextStyle(fontSize:  size.width*.041, color: Colors.grey[800]),
              ),

              SizedBox(
                height: 2
              ),
              Text(
                manufacturer??'',
                maxLines: 1,
                style: TextStyle(
                    fontSize:  size.width*.038, color: Theme.of(context).primaryColor),
              ),
            ],
          )),
    );
  }
}