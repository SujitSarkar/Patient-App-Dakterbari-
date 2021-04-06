import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/model/hospital_model.dart';
import 'package:user_panel/model/doctor_model.dart';
import 'package:user_panel/model/faq_model.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';

class DoctorProvider extends RegAuth{
   List<DoctorDetailsModel> _doctorList=List<DoctorDetailsModel>();
   List<DoctorDetailsModel> _doctorCategoryList=List<DoctorDetailsModel>();
   List<DoctorDetailsModel> _optionalSpecificationList=List<DoctorDetailsModel>();
   List<FaqModel> _faqList = List<FaqModel>();

   List<HospitalModel> _hospitalList=List<HospitalModel>();
   FaqModel _faqModel = FaqModel();

   get doctorList=> _doctorList;
   get doctorCategoryList=> _doctorCategoryList;
   get optionalSpecificationList=>_optionalSpecificationList;
   get faqModel=> _faqModel;
   get faqList=> _faqList;

   get hospitalList=>_hospitalList;

   set faqModel(FaqModel model){
      model = FaqModel();
      _faqModel = model;
      notifyListeners();
   }
   void clearDoctorList(){
      _doctorList.clear();
      notifyListeners();
   }
   void clearFaqList(){
      _faqList.clear();
      notifyListeners();
   }

   Future<void> getDoctor(String id)async{
      try{
         await FirebaseFirestore.instance.collection('Doctors').where('id', isEqualTo: id).get().then((snapShot){
            _doctorList.clear();
            snapShot.docChanges.forEach((element) {
               DoctorDetailsModel doctors=DoctorDetailsModel(
                  id: element.doc['id'],
                  about: element.doc['about'],
                  appFee: element.doc['appFee'],
                  bmdcNumber: element.doc['bmdcNumber'],
                  countryCode: element.doc['countryCode'],
                  degree: element.doc['degree'],
                  email: element.doc['email'],
                  experience: element.doc['experience'],
                  gender: element.doc['gender'],
                  joinDate: element.doc['joinDate'],
                  fullName: element.doc['name'],
                  password: element.doc['password'],
                  phone: element.doc['phone'],
                  photoUrl: element.doc['photoUrl'],
                  provideTeleService: element.doc['provideTeleService'],
                  specification: element.doc['specification'],
                  teleFee: element.doc['teleFee'],
                  totalPrescribe: element.doc['totalPrescribe'],
                  country: element.doc['country'],
                  state: element.doc['state'],
                  city: element.doc['city'],
                  currency: element.doc['currency'],
                  totalTeleFee: element.doc['totalTeleFee'],
                  optionalSpecification: element.doc['optionalSpecification'],
                  sat: element.doc['teleSat'],
                  sun: element.doc['teleSun'],
                  mon: element.doc['teleMon'],
                  tue: element.doc['teleTue'],
                  wed: element.doc['teleWed'],
                  thu: element.doc['teleThu'],
                  fri: element.doc['teleFri'],
               );
               _doctorList.add(doctors);
            });
         });
         notifyListeners();
         print( _doctorList.length);
      }catch(error){}
   }

   Future<void> getDoctorByCategory(String specification) async{
      try{
         await FirebaseFirestore.instance.collection('Doctors').where('specification', isEqualTo: specification).get().then((snapShot){
            _doctorCategoryList.clear();
            snapShot.docChanges.forEach((element) {
               DoctorDetailsModel doctors=DoctorDetailsModel(
                  id: element.doc['id'],
                  about: element.doc['about'],
                  appFee: element.doc['appFee'],
                  bmdcNumber: element.doc['bmdcNumber'],
                  countryCode: element.doc['countryCode'],
                  degree: element.doc['degree'],
                  email: element.doc['email'],
                  experience: element.doc['experience'],
                  gender: element.doc['gender'],
                  joinDate: element.doc['joinDate'],
                  fullName: element.doc['name'],
                  password: element.doc['password'],
                  phone: element.doc['phone'],
                  photoUrl: element.doc['photoUrl'],
                  provideTeleService: element.doc['provideTeleService'],
                  specification: element.doc['specification'],
                  teleFee: element.doc['teleFee'],
                  totalPrescribe: element.doc['totalPrescribe'],
                  country: element.doc['country'],
                  state: element.doc['state'],
                  city: element.doc['city'],
                  currency: element.doc['currency'],
                  optionalSpecification: element.doc['optionalSpecification'],
                  sat: element.doc['teleSat'],
                  sun: element.doc['teleSun'],
                  mon: element.doc['teleMon'],
                  tue: element.doc['teleTue'],
                  wed: element.doc['teleWed'],
                  thu: element.doc['teleThu'],
                  fri: element.doc['teleFri'],
               );
               _doctorCategoryList.add(doctors);
            });
         });
         notifyListeners();
         print( _doctorCategoryList.length);
      }catch(error){}
   }

   Future<void> getFaq(String id) async{
      try{
         await FirebaseFirestore.instance.collection('FAQ').where('id', isEqualTo: id).get().then((snapshot){
            _faqList.clear();
            snapshot.docChanges.forEach((element) {
               FaqModel faqModel = FaqModel(
                  id: element.doc['id'],
                  one: element.doc['one'],
                  two: element.doc['two'],
                  three: element.doc['three'],
                  four: element.doc['four'],
                  five: element.doc['five'],
                  six: element.doc['six'],
                  seven: element.doc['seven'],
                  eight: element.doc['eight'],
                  nine: element.doc['nine'],
                  ten: element.doc['ten'],
               );
               _faqList.add(faqModel);
            });
         });
         notifyListeners();
      }catch(error){}
   }

   Future<void> getHospitals(String doctorId)async{
      try{
         await FirebaseFirestore.instance.collection('Hospitals').where('doctorId', isEqualTo: doctorId).get().then((snapShot){
            _hospitalList.clear();
            snapShot.docChanges.forEach((element) {
               HospitalModel hospitals = HospitalModel(
                  id: element.doc['id'],
                  doctorId: element.doc['doctorId'],
                  hospitalName: element.doc['hospitalName'],
                  hospitalAddress: element.doc['hospitalAddress'],
                  addingDate: element.doc['addingDate'],
                  sat: element.doc['sat'],
                  sun: element.doc['sun'],
                  mon: element.doc['mon'],
                  tue: element.doc['tue'],
                  wed: element.doc['wed'],
                  thu: element.doc['thu'],
                  fri: element.doc['fri'],
               );
               _hospitalList.add(hospitals);
            });
         });
         notifyListeners();
      }catch(error){}
   }
}