class QueryModel {
  int id;
  String name;
  String type;
  String email;
  String mobile;
  String description;
  int status;
  int userId;
  String createdAt;
  String updatedAt;
  String statusText;

  QueryModel(
      {this.id,
        this.name,
        this.type,
        this.email,
        this.mobile,
        this.description,
        this.status,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.statusText});

  QueryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    email = json['email'];
    mobile = json['mobile'];
    description = json['description'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['description'] = this.description;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status_text'] = this.statusText;
    return data;
  }
}
