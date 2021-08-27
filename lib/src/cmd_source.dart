import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class CMDB {
  CMDB.privateConstructor();
  static final CMDB _instance = CMDB.privateConstructor();
  static String? _url;

  factory CMDB() {
    return _instance;
  }

  Future<void> initialize(String urlDatabase) async {
    if (_url == null) {
      _url = urlDatabase;
    }
  }

  Future<bool> update<T>(String key, Map<String, dynamic> value) async {
    print(value);
    final response = await http.put(
      Uri.parse(_url! + '/' + key + '.json'),
      body: jsonEncode(value),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<Map<String, dynamic>?> create(
      String key, Map<String, dynamic> value) async {
    final response = await http.post(Uri.parse(_url! + '/' + key + '.json'),
        body: jsonEncode(value), headers: {'content-type': "application/json"});
    if (response.statusCode == 200) {
      print(response.statusCode);
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future delete(String key) async {
    final Response response = await http.delete(
      Uri.parse(_url! + '/' + key + '.json'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print('delete: ' + response.statusCode.toString());
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<T?> get<T>(String key) async {
    // async, await
    if (_url == null) throw Exception('CMDB needs to be initialize');
    final response = await http.get(Uri.parse(_url! + '/' + key + '.json'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse == null) {
        print('Field is empty');
        return null;
      }
      print(jsonResponse);
      switch (T.toString().split('<')[0]) {
        case "Map":
          return jsonResponse;
        case "List":
          List<Map<String, dynamic>> list = [];
          for (String key in jsonResponse.keys) {
            list.add(jsonResponse[key] as Map<String, dynamic>);
          }
          return list as T;
        case "String":
          return jsonResponse as T;
        default:
          print(
              'This type is not allow. It can be only returned String, Map or List type');
          return null;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
