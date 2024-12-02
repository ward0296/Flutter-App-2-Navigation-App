class DataModel {
  final String name;
  final String email;

  DataModel({required this.name, required this.email});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json['name'],
      email: json['email'],
    );
  }
}
