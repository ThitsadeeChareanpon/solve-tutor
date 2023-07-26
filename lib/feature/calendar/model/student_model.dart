class StudentModel {
  String? id;
  String? name;
  String? image;
  DateTime? createTime;
  String? attend;
  String? statusShare;
  String? solvepadSize;

  StudentModel({
    this.id,
    this.name,
    this.image,
    this.createTime,
    this.attend = 'false',
    this.statusShare = 'disable',
    this.solvepadSize = '1059,547',
  });

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createTime = json['create_time'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['create_time'])
        : null;
    attend = json['attend'] ?? 'false';
    statusShare = json['status_share'] ?? 'disable';
    solvepadSize = json['solvepad_size'] ?? '1059,547';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['create_time'] = createTime?.toUtc().millisecondsSinceEpoch;
    data['attend'] = attend;
    data['status_share'] = statusShare;
    data['solvepad_size'] = solvepadSize;

    return data;
  }
}
