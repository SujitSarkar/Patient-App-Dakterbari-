class PaymentAppointmentModel{
  String id;
  String pId;
  String pName;
  String drId;
  String drName;
  String transactionId;
  String amount;
  String takenService;
  String paymentDate;
  String currency;
  String timeStamp;

  PaymentAppointmentModel({
    this.id,
    this.pId,
    this.pName,
    this.drId,
    this.drName,
    this.transactionId,
    this.amount,
    this.takenService,
    this.paymentDate,
    this.currency,
    this.timeStamp});
}