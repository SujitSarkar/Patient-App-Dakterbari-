class PaymentDiscountModel{
  String id;
  String pId;
  String pName;
  String shopId;
  String transactionId;
  String shopName;
  String paymentDate;
  String amount;
  String currency;
  String timeStamp;
  PaymentDiscountModel({this.id, this.pId, this.pName, this.shopId,
    this.shopName, this.paymentDate, this.amount, this.timeStamp,this.transactionId,this.currency});
}