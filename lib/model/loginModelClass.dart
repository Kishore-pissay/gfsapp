class LogInModelClass {
  int? respCode;
  String? recordId;
  RecordInfo? recordInfo;
  String? errorMsg;

  LogInModelClass(
      {this.respCode, this.recordId, this.recordInfo, this.errorMsg});

  LogInModelClass.fromJson(Map<String, dynamic> json) {
    respCode = json['respCode'];
    recordId = json['recordId'];
    recordInfo = json['recordInfo'] != null
        ? new RecordInfo.fromJson(json['recordInfo'])
        : null;
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['respCode'] = this.respCode;
    data['recordId'] = this.recordId;
    if (this.recordInfo != null) {
      data['recordInfo'] = this.recordInfo!.toJson();
    }
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class RecordInfo {
  Attributes? attributes;
  String? id;
  String? lastName;
  String? phone;
  String? email;
  String? dateOfBirthC;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? panNumberC;
  String? aadharNumberC;
  String? servicesC;
  String? referedByC;
  String? occupationC;
  String? company;

  RecordInfo(
      {this.attributes,
      this.id,
      this.lastName,
      this.phone,
      this.email,
      this.dateOfBirthC,
      this.street,
      this.city,
      this.state,
      this.postalCode,
      this.country,
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
    lastName = json['LastName'];
    phone = json['Phone'];
    email = json['Email'];
    dateOfBirthC = json['DateOfBirth__c'];
    street = json['Street'];
    city = json['City'];
    state = json['State'];
    postalCode = json['PostalCode'];
    country = json['Country'];
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
    data['LastName'] = this.lastName;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['DateOfBirth__c'] = this.dateOfBirthC;
    data['Street'] = this.street;
    data['City'] = this.city;
    data['State'] = this.state;
    data['PostalCode'] = this.postalCode;
    data['Country'] = this.country;
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
