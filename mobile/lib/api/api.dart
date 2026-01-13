import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bitirme_project/model/fruit_model.dart';
import 'dart:async';


  Future<Fruit> fetchFruit(String label) async {
    final cleanLabel = label.trim().toLowerCase();
    
    final response = await http.get(
      Uri.parse("http://172.20.10.5:3000/fruit/$cleanLabel")
    );

    final decoded = jsonDecode(response.body);

    return Fruit.fromJson(Map<String, dynamic>.from(decoded));
   
}
