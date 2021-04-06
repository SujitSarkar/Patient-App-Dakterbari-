import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/model/medicine_model.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';

class MedicineProvider extends RegAuth{

  MedicineModel _medicineModel = MedicineModel();
  List<MedicineModel> _medicineList = [];

  get medicineModel=> _medicineModel;
  get medicineList=> _medicineList;

  set medicineModel(MedicineModel model){
    model = MedicineModel();
    _medicineModel = model;
    notifyListeners();
  }

  Future<void> getMedicine()async{
    try{
      await FirebaseFirestore.instance.collection('Medicines').where('state',isEqualTo: 'approved').get().then((snapshot){
        _medicineList.clear();
        snapshot.docChanges.forEach((element) {
          MedicineModel medicineModel = MedicineModel(
            id: element.doc['id'],
            name: element.doc['name'],
            strength: element.doc['strength'],
            genericName: element.doc['genericName'],
            dosage: element.doc['dosage'],
            manufacturer: element.doc['manufacturer'],
            price: element.doc['price'],
            indications: element.doc['indications'],
            adultDose: element.doc['adultDose'],
            childDose: element.doc['childDose'],
            renalDose: element.doc['renalDose'],
            administration: element.doc['administration'],
            contradiction: element.doc['contradiction'],
            sideEffect: element.doc['sideEffect'],
            precautions: element.doc['precautions'],
            pregnancy: element.doc['pregnancy'],
            therapeutic: element.doc['therapeutic'],
            modeOfAction: element.doc['modeOfAction'],
            interaction: element.doc['interaction'],
            darNo: element.doc['darNo'],
          );
          _medicineList.add(medicineModel);
        });
      });
      notifyListeners();
    }catch(error){}
  }


}