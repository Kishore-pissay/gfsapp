class FileUpload {
  int? respCode;
  String? recordId;
  String? errorMsg;

  FileUpload({this.respCode, this.recordId, this.errorMsg});

  FileUpload.fromJson(Map<String, dynamic> json) {
    respCode = json['respCode'];
    recordId = json['recordId'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['respCode'] = this.respCode;
    data['recordId'] = this.recordId;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}
