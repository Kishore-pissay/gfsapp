class OrderIdModel {
  String? orderCurrency;
  double? orderAmount;
  String? orderId;
  String? leadId;
  String? clientSecret;
  String? clientId;
  String? cftoken;
  String? message;
  String? status;

  OrderIdModel(
      {this.orderCurrency,
      this.orderAmount,
      this.orderId,
      this.leadId,
      this.clientSecret,
      this.clientId,
      this.cftoken,
      this.message,
      this.status});

  OrderIdModel.fromJson(Map<String, dynamic> json) {
    orderCurrency = json['orderCurrency'];
    orderAmount = json['orderAmount'];
    orderId = json['orderId'];
    leadId = json['leadId'];
    clientSecret = json['ClientSecret'];
    clientId = json['ClientId'];
    cftoken = json['cftoken'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderCurrency'] = this.orderCurrency;
    data['orderAmount'] = this.orderAmount;
    data['orderId'] = this.orderId;
    data['leadId'] = this.leadId;
    data['ClientSecret'] = this.clientSecret;
    data['ClientId'] = this.clientId;
    data['cftoken'] = this.cftoken;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
