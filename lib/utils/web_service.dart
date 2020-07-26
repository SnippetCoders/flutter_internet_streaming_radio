import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_radio/models/base_model.dart';

class WebService {
  Future<BaseModel> getData(String url, BaseModel baseModel) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      baseModel.fromJson(json.decode(response.body));
      return baseModel;
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
