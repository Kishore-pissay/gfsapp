class AuthorizationModelClass {
  String? accessToken;
  String? instanceUrl;
  String? id;
  String? tokenType;
  String? issuedAt;
  String? signature;

  AuthorizationModelClass(
      {this.accessToken,
      this.instanceUrl,
      this.id,
      this.tokenType,
      this.issuedAt,
      this.signature});

  AuthorizationModelClass.fromJson(Map<String?, dynamic> json) {
    accessToken = json['access_token'];
    instanceUrl = json['instance_url'];
    id = json['id'];
    tokenType = json['token_type'];
    issuedAt = json['issued_at'];
    signature = json['signature'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['access_token'] = this.accessToken;
    data['instance_url'] = this.instanceUrl;
    data['id'] = this.id;
    data['token_type'] = this.tokenType;
    data['issued_at'] = this.issuedAt;
    data['signature'] = this.signature;
    return data;
  }
}
