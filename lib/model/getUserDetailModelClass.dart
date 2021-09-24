class UserDetailsModel {
  int? respCode;
  RecordInfo? recordInfo;
  GstInfo? gstInfo;
  String? errorMsg;

  UserDetailsModel(
      {this.respCode, this.recordInfo, this.gstInfo, this.errorMsg});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    respCode = json['respCode'];
    recordInfo = json['recordInfo'] != null
        ? new RecordInfo.fromJson(json['recordInfo'])
        : null;
    gstInfo =
        json['gstInfo'] != null ? new GstInfo.fromJson(json['gstInfo']) : null;
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['respCode'] = this.respCode;
    if (this.recordInfo != null) {
      data['recordInfo'] = this.recordInfo!.toJson();
    }
    if (this.gstInfo != null) {
      data['gstInfo'] = this.gstInfo!.toJson();
    }
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class RecordInfo {
  Attributes? attributes;
  String? id;
  String? phone;
  String? email;
  String? status;
  String? passwordC;
  String? lastName;
  String? dateOfBirthC;
  String? city;
  String? state;
  String? postalCode;
  String? panNumberC;
  String? aadharNumberC;
  String? servicesC;
  String? referedByC;
  String? occupationC;
  String? company;

  RecordInfo(
      {this.attributes,
      this.id,
      this.phone,
      this.email,
      this.status,
      this.passwordC,
      this.lastName,
      this.dateOfBirthC,
      this.city,
      this.state,
      this.postalCode,
      this.panNumberC,
      this.aadharNumberC,
      this.servicesC,
      this.referedByC,
      this.occupationC,
      this.company});

  RecordInfo.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    id = json['Id'];
    phone = json['Phone'];
    email = json['Email'];
    status = json['Status'];
    passwordC = json['Password__c'];
    lastName = json['LastName'];
    dateOfBirthC = json['DateOfBirth__c'];
    city = json['City'];
    state = json['State'];
    postalCode = json['PostalCode'];
    panNumberC = json['Pan_Number__c'];
    aadharNumberC = json['Aadhar_Number__c'];
    servicesC = json['Services__c'];
    referedByC = json['Refered_by__c'];
    occupationC = json['Occupation__c'];
    company = json['Company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    data['Id'] = this.id;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['Status'] = this.status;
    data['Password__c'] = this.passwordC;
    data['LastName'] = this.lastName;
    data['DateOfBirth__c'] = this.dateOfBirthC;
    data['City'] = this.city;
    data['State'] = this.state;
    data['PostalCode'] = this.postalCode;
    data['Pan_Number__c'] = this.panNumberC;
    data['Aadhar_Number__c'] = this.aadharNumberC;
    data['Services__c'] = this.servicesC;
    data['Refered_by__c'] = this.referedByC;
    data['Occupation__c'] = this.occupationC;
    data['Company'] = this.company;
    return data;
  }
}

class Attributes {
  String? type;
  String? url;

  Attributes({this.type, this.url});

  Attributes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}

class GstInfo {
  String? subscription;
  String? status;
  String? planExpiryDate;
  String? gstPsw;
  String? gstNum;

  GstInfo(
      {this.subscription,
      this.status,
      this.planExpiryDate,
      this.gstPsw,
      this.gstNum});

  GstInfo.fromJson(Map<String, dynamic> json) {
    subscription = json['subscription'];
    status = json['status'];
    planExpiryDate = json['planExpiryDate'];
    gstPsw = json['gstPsw'];
    gstNum = json['gstNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription'] = this.subscription;
    data['status'] = this.status;
    data['planExpiryDate'] = this.planExpiryDate;
    data['gstPsw'] = this.gstPsw;
    data['gstNum'] = this.gstNum;
    return data;
  }
}
