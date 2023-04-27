class HealthModel {
  Value? value;
  String? dataType;
  String? unit;
  String? dateFrom;
  String? dateTo;
  String? platformType;
  String? deviceId;
  String? sourceId;
  String? sourceName;

  HealthModel(
      {this.value,
        this.dataType,
        this.unit,
        this.dateFrom,
        this.dateTo,
        this.platformType,
        this.deviceId,
        this.sourceId,
        this.sourceName});

  HealthModel.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
    dataType = json['data_type'];
    unit = json['unit'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    platformType = json['platform_type'];
    deviceId = json['device_id'];
    sourceId = json['source_id'];
    sourceName = json['source_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['data_type'] = this.dataType;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['platform_type'] = this.platformType;
    data['device_id'] = this.deviceId;
    data['source_id'] = this.sourceId;
    data['source_name'] = this.sourceName;
    return data;
  }
}

class Value {
  String? numericValue;

  Value({this.numericValue});

  Value.fromJson(Map<String, dynamic> json) {
    numericValue = json['numericValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numericValue'] = this.numericValue;
    return data;
  }
}
