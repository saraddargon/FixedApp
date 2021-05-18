import 'package:json_annotation/json_annotation.dart';
part 'checkNoList.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckNoList {
  CheckNoList(this.CheckNo, this.Admin);
  // ignore: non_constant_identifier_names
  String CheckNo, Admin;
  factory CheckNoList.fromJson(Map<String, dynamic> json) =>
      _$CheckNoListFromJson(json);
  Map<String, dynamic> toJson() => _$CheckNoListToJson(this);
}
