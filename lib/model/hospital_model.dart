class HospitalModel{
  String id;
  String hospitalName;
  String hospitalAddress;
  String doctorId;
  String addingDate;
  List<dynamic> sat;
  List<dynamic> sun;
  List<dynamic> mon;
  List<dynamic> tue;
  List<dynamic> wed;
  List<dynamic> thu;
  List<dynamic> fri;

  HospitalModel({this.id,this.hospitalName, this.hospitalAddress, this.doctorId, this.addingDate, this.sat,
      this.sun, this.mon, this.tue, this.wed, this.thu, this.fri});
}