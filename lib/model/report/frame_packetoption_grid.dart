class FramePacketOptionGridModel {
  List<FramePacketOptionData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  FramePacketOptionGridModel(
      {this.data, this.succeeded, this.errors, this.message});

  FramePacketOptionGridModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FramePacketOptionData>[];
      json['data'].forEach((v) {
        data!.add(new FramePacketOptionData.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    errors = json['errors'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class FramePacketOptionData {
  String? framePacketId;
  String? framePacketName;

  FramePacketOptionData({this.framePacketId, this.framePacketName});

  FramePacketOptionData.fromJson(Map<String, dynamic> json) {
    framePacketId = json['framePacketId'];
    framePacketName = json['framePacketName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['framePacketId'] = this.framePacketId;
    data['framePacketName'] = this.framePacketName;
    return data;
  }
}
