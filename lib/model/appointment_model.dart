class AppointmentDetailsModel {
  String id;
  String drId;
  String drName;
  String drPhotoUrl;
  String drDegree;
  String drEmail;
  String drAddress;
  String specification;
  String appFee;
  String teleFee;
  String currency;
  String prescribeDate;
  String prescribeState;
  String pId;
  String pName;
  String pPhotoUrl;
  String pAddress;
  String pAge;
  String pGender;
  String pProblem;
  String bookingDate;
  String appointDate;
  String chamberName;
  String chamberAddress;
  String bookingSchedule;
  String actualProblem;
  String rx;
  String advice;
  String nextVisit;
  String appointState; //telemedicine/chamber
  List<dynamic> medicines;
  String timeStamp;
  String prescribeNo;
  String reviewStar;
  String reviewComment;
  String reviewDate;
  String reviewTimeStamp;
  AppointmentDetailsModel(
      {this.id,
      this.drId,
      this.drName,
      this.drPhotoUrl,
      this.drDegree,
      this.drEmail,
      this.drAddress,
      this.prescribeDate,
      this.pName,
      this.pId,
      this.pPhotoUrl,
      this.pAddress,
      this.pAge,
      this.pGender,
      this.pProblem,
      this.bookingDate,
      this.bookingSchedule,
      this.rx,
      this.advice,
      this.nextVisit,
      this.appointDate,
      this.appointState,
      this.medicines,
      this.timeStamp,
      this.chamberName,
      this.chamberAddress,
      this.specification,
      this.appFee,
      this.teleFee,
      this.currency,
      this.actualProblem,
        this.prescribeState,
        this.prescribeNo,
        this.reviewStar,this.reviewDate,
        this.reviewComment,this.reviewTimeStamp
      });

}
