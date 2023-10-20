class OfferModel {
  int id;
  int salonId;
  String day;
  String fromTime;
  String toTime;
  int discount;
  String createdAt;
  String updatedAt;
  bool selected;
  OfferModel(
      {this.id,
        this.salonId,
        this.day,
        this.fromTime,
        this.toTime,
        this.discount,
        this.selected,
        this.createdAt,
        this.updatedAt});

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selected = true;
    salonId = json['salon_id'];
    day = json['day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    discount = json['discount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salon_id'] = this.salonId;
    data['day'] = this.day;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['discount'] = this.discount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
